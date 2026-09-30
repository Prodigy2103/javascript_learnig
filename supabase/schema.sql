-- Supabase Schema for JavaScript Learning Lab
-- Run this in your Supabase SQL Editor

-- 1. Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Tasks Table
CREATE TABLE IF NOT EXISTS tasks (
  id TEXT PRIMARY KEY,
  stage INTEGER NOT NULL,
  title TEXT NOT NULL,
  scenario_description TEXT NOT NULL,
  function_name TEXT NOT NULL,
  parameters JSONB NOT NULL DEFAULT '[]'::jsonb,
  starter_code TEXT NOT NULL,
  solution_code TEXT NOT NULL,
  test_cases JSONB NOT NULL DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Test Runs Log Table
CREATE TABLE IF NOT EXISTS test_runs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id TEXT REFERENCES tasks(id) ON DELETE CASCADE,
  submitted_code TEXT NOT NULL,
  passed BOOLEAN NOT NULL,
  passed_count INTEGER NOT NULL,
  total_count INTEGER NOT NULL,
  execution_time_ms NUMERIC(8, 2) NOT NULL,
  failure_message TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. User Progress Table (for Carousel state)
CREATE TABLE IF NOT EXISTS user_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id TEXT REFERENCES tasks(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'unseen', -- 'unseen' | 'failed' | 'solved_with_hints' | 'solved_clean'
  attempt_count INTEGER DEFAULT 0,
  max_revealed_hint_tier INTEGER DEFAULT 0,
  last_attempted_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Row Level Security (RLS) Settings
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_runs ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;

-- Allow public read access to tasks
CREATE POLICY "Allow public read on tasks"
  ON tasks FOR SELECT
  TO anon, authenticated
  USING (true);

-- Allow public insert on test_runs
CREATE POLICY "Allow public insert on test_runs"
  ON test_runs FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- Allow public read/write on user_progress
CREATE POLICY "Allow public all on user_progress"
  ON user_progress FOR ALL
  TO anon, authenticated
  USING (true)
  WITH CHECK (true);
