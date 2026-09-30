-- ==============================================================================
-- JAVASCRIPT MASTER LAB - SERVER-AUTHORITATIVE MASTERY & EXPANSION RPC
-- Run this script in Supabase SQL Editor
-- ==============================================================================

-- 1. EXTEND USER_PROGRESS SCHEMA WITH SPACED REPETITION COLUMNS
ALTER TABLE user_progress 
ADD COLUMN IF NOT EXISTS repetition_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS interval_days INTEGER DEFAULT 1,
ADD COLUMN IF NOT EXISTS ease_factor NUMERIC(4, 2) DEFAULT 2.50,
ADD COLUMN IF NOT EXISTS next_due_date TIMESTAMPTZ DEFAULT NOW();

-- 2. SERVER-AUTHORITATIVE RPC: RECORD PROGRESS & CALCULATE REPETITION (SM-2 LIGHT)
CREATE OR REPLACE FUNCTION record_task_progress(
  p_task_id TEXT,
  p_passed BOOLEAN,
  p_hint_tier INTEGER
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_current RECORD;
  v_new_repetitions INTEGER := 0;
  v_new_interval INTEGER := 1;
  v_new_ease NUMERIC(4, 2) := 2.50;
  v_status TEXT;
  v_next_due TIMESTAMPTZ;
  v_result JSONB;
BEGIN
  -- Fetch existing progress if present
  SELECT * INTO v_current 
  FROM user_progress 
  WHERE task_id = p_task_id 
  LIMIT 1;

  IF p_passed THEN
    IF p_hint_tier > 1 THEN
      v_status := 'solved_with_hints';
      v_new_repetitions := COALESCE(v_current.repetition_count, 0) + 1;
      v_new_interval := 1; -- Repeat soon due to hints needed
      v_new_ease := GREATEST(1.30, COALESCE(v_current.ease_factor, 2.50) - 0.15);
    ELSE
      v_status := 'solved_clean';
      v_new_repetitions := COALESCE(v_current.repetition_count, 0) + 1;
      -- Standard SM-2 interval progression: 1 -> 3 -> 7 -> 14...
      IF v_new_repetitions = 1 THEN
        v_new_interval := 1;
      ELSIF v_new_repetitions = 2 THEN
        v_new_interval := 3;
      ELSIF v_new_repetitions = 3 THEN
        v_new_interval := 7;
      ELSE
        v_new_interval := ROUND(COALESCE(v_current.interval_days, 7) * COALESCE(v_current.ease_factor, 2.50));
      END IF;
      v_new_ease := LEAST(3.00, COALESCE(v_current.ease_factor, 2.50) + 0.10);
    END IF;
  ELSE
    v_status := 'failed';
    v_new_repetitions := 0; -- Reset interval streak on failure
    v_new_interval := 1;
    v_new_ease := GREATEST(1.30, COALESCE(v_current.ease_factor, 2.50) - 0.20);
  END IF;

  v_next_due := NOW() + (v_new_interval || ' days')::INTERVAL;

  -- Upsert progress record
  INSERT INTO user_progress (
    task_id,
    status,
    attempt_count,
    max_revealed_hint_tier,
    repetition_count,
    interval_days,
    ease_factor,
    next_due_date,
    last_attempted_at,
    completed_at
  )
  VALUES (
    p_task_id,
    v_status,
    COALESCE(v_current.attempt_count, 0) + 1,
    GREATEST(COALESCE(v_current.max_revealed_hint_tier, 0), p_hint_tier),
    v_new_repetitions,
    v_new_interval,
    v_new_ease,
    v_next_due,
    NOW(),
    CASE WHEN p_passed THEN NOW() ELSE v_current.completed_at END
  )
  ON CONFLICT (id) DO UPDATE SET
    status = EXCLUDED.status,
    attempt_count = EXCLUDED.attempt_count,
    max_revealed_hint_tier = EXCLUDED.max_revealed_hint_tier,
    repetition_count = EXCLUDED.repetition_count,
    interval_days = EXCLUDED.interval_days,
    ease_factor = EXCLUDED.ease_factor,
    next_due_date = EXCLUDED.next_due_date,
    last_attempted_at = EXCLUDED.last_attempted_at,
    completed_at = EXCLUDED.completed_at;

  SELECT jsonb_build_object(
    'taskId', p_task_id,
    'status', v_status,
    'repetitionCount', v_new_repetitions,
    'intervalDays', v_new_interval,
    'easeFactor', v_new_ease,
    'nextDueDate', v_next_due
  ) INTO v_result;

  RETURN v_result;
END;
$$;

-- 3. SERVER-AUTHORITATIVE RPC: INSERT CUSTOM KATA (KATA STUDIO)
CREATE OR REPLACE FUNCTION create_custom_kata(
  p_title TEXT,
  p_stage INTEGER,
  p_scenario_description TEXT,
  p_function_name TEXT,
  p_starter_code TEXT,
  p_solution_code TEXT,
  p_test_cases JSONB
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_new_id TEXT;
  v_inserted_task RECORD;
BEGIN
  -- Generate unique ID
  v_new_id := 'task-custom-' || lower(regexp_replace(p_function_name, '[^a-zA-Z0-9]', '-', 'g')) || '-' || substr(md5(random()::text), 1, 6);

  INSERT INTO tasks (
    id,
    stage,
    title,
    scenario_description,
    function_name,
    starter_code,
    solution_code,
    test_cases
  )
  VALUES (
    v_new_id,
    p_stage,
    p_title,
    p_scenario_description,
    p_function_name,
    p_starter_code,
    p_solution_code,
    COALESCE(p_test_cases, '[]'::jsonb)
  )
  RETURNING * INTO v_inserted_task;

  RETURN jsonb_build_object(
    'id', v_inserted_task.id,
    'title', v_inserted_task.title,
    'stage', v_inserted_task.stage,
    'functionName', v_inserted_task.function_name
  );
END;
$$;
