-- ==============================================================================
-- JAVASCRIPT MASTER LAB - COMPLETE CURRICULUM (PHASES 1 TO 5)
-- Run this entire script in Supabase SQL Editor (SQL Editor -> New Query -> Run)
-- ==============================================================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. CREATE TABLES
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

CREATE TABLE IF NOT EXISTS user_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id TEXT REFERENCES tasks(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'unseen',
  attempt_count INTEGER DEFAULT 0,
  max_revealed_hint_tier INTEGER DEFAULT 0,
  last_attempted_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. ENABLE ROW LEVEL SECURITY (RLS)
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_runs ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;

-- 4. POLICIES
DROP POLICY IF EXISTS "Allow public read on tasks" ON tasks;
CREATE POLICY "Allow public read on tasks"
  ON tasks FOR SELECT
  TO anon, authenticated
  USING (true);

DROP POLICY IF EXISTS "Allow public insert on test_runs" ON test_runs;
CREATE POLICY "Allow public insert on test_runs"
  ON test_runs FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

DROP POLICY IF EXISTS "Allow public all on user_progress" ON user_progress;
CREATE POLICY "Allow public all on user_progress"
  ON user_progress FOR ALL
  TO anon, authenticated
  USING (true)
  WITH CHECK (true);

-- 5. SEED CURRICULUM TASKS (Phases 1 to 5)

-- Phase 1 Task: calculateSum (task-p1-sum)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p1-sum$val$,
  1,
  $val$Funktion mit Rückgabewert definieren$val$,
  $val$Schreibe eine Funktion calculateSum, die zwei Zahlen als Parameter entgegennimmt und deren Summe mit return zurückgibt.$val$,
  $val$calculateSum$val$,
  $val$[{"parameterName":"firstNumber","typeDescription":"number","description":"Erste Zahl"},{"parameterName":"secondNumber","typeDescription":"number","description":"Zweite Zahl"}]$val$::jsonb,
  $val$function calculateSum(firstNumber, secondNumber) {
  // Schreibe hier deinen Code
}$val$,
  $val$function calculateSum(firstNumber, secondNumber) {
  return firstNumber + secondNumber;
}$val$,
  $val$[{"id":"t1-1","description":"calculateSum(2, 3) ergibt 5","inputArguments":[2,3],"expectedOutput":5,"isHidden":false},{"id":"t1-2","description":"calculateSum(-10, 20) ergibt 10","inputArguments":[-10,20],"expectedOutput":10,"isHidden":false},{"id":"t1-3","description":"calculateSum(0, 0) ergibt 0","inputArguments":[0,0],"expectedOutput":0,"isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 1 Task: formatGreeting (task-p1-greeting)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p1-greeting$val$,
  1,
  $val$Text-Ausgabe formatieren (Template Literals)$val$,
  $val$Schreibe eine Funktion formatGreeting, die einen Namen als Parameter personName entgegennimmt und die Begrüßung "Hallo, [Name]!" zurückgibt.$val$,
  $val$formatGreeting$val$,
  $val$[{"parameterName":"personName","typeDescription":"string","description":"Name der Person"}]$val$::jsonb,
  $val$function formatGreeting(personName) {
  // Schreibe hier deinen Code
}$val$,
  $val$function formatGreeting(personName) {
  return `Hallo, ${personName}!`;
}$val$,
  $val$[{"id":"t2-1","description":"formatGreeting(\"Anna\") ergibt \"Hallo, Anna!\"","inputArguments":["Anna"],"expectedOutput":"Hallo, Anna!","isHidden":false},{"id":"t2-2","description":"formatGreeting(\"Marcus\") ergibt \"Hallo, Marcus!\"","inputArguments":["Marcus"],"expectedOutput":"Hallo, Marcus!","isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 1 Task: formatCapitalizedName (task-p1-capitalized-name)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p1-capitalized-name$val$,
  1,
  $val$String-Veredelung (Ersten Buchstaben großschreiben)$val$,
  $val$Schreibe eine Funktion formatCapitalizedName, die einen String rawName entgegennimmt und ihn so zurückgibt, dass der erste Buchstabe großgeschrieben ist und der Rest unverändert bleibt.$val$,
  $val$formatCapitalizedName$val$,
  $val$[{"parameterName":"rawName","typeDescription":"string","description":"Eingebener Name"}]$val$::jsonb,
  $val$function formatCapitalizedName(rawName) {
  // Nutze charAt(0).toUpperCase() und slice(1)
}$val$,
  $val$function formatCapitalizedName(rawName) {
  if (!rawName) return '';
  return rawName.charAt(0).toUpperCase() + rawName.slice(1);
}$val$,
  $val$[{"id":"t3-1","description":"formatCapitalizedName(\"marcus\") ergibt \"Marcus\"","inputArguments":["marcus"],"expectedOutput":"Marcus","isHidden":false},{"id":"t3-2","description":"formatCapitalizedName(\"anna\") ergibt \"Anna\"","inputArguments":["anna"],"expectedOutput":"Anna","isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 1 Task: formatTime (task-p1-pad-time)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p1-pad-time$val$,
  1,
  $val$Uhrzeit zweistellig formatieren (padStart)$val$,
  $val$Schreibe eine Funktion formatTime, die zwei Zahlen hours und minutes entgegennimmt und sie als String im Format "HH:MM" (jeweils mit führender Null bei einstelligen Zahlen) zurückgibt.$val$,
  $val$formatTime$val$,
  $val$[{"parameterName":"hours","typeDescription":"number","description":"Stunden"},{"parameterName":"minutes","typeDescription":"number","description":"Minuten"}]$val$::jsonb,
  $val$function formatTime(hours, minutes) {
  // Nutze String().padStart(2, "0")
}$val$,
  $val$function formatTime(hours, minutes) {
  const formattedHours = String(hours).padStart(2, '0');
  const formattedMinutes = String(minutes).padStart(2, '0');
  return `${formattedHours}:${formattedMinutes}`;
}$val$,
  $val$[{"id":"t4-1","description":"formatTime(8, 5) ergibt \"08:05\"","inputArguments":[8,5],"expectedOutput":"08:05","isHidden":false},{"id":"t4-2","description":"formatTime(14, 30) ergibt \"14:30\"","inputArguments":[14,30],"expectedOutput":"14:30","isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 1 Task: determineDetailedType (task-p1-type-checker)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p1-type-checker$val$,
  1,
  $val$Typensystem: Exakter Typ-Detektor (Primitives vs. References)$val$,
  $val$Schreibe eine Funktion determineDetailedType(inputTarget), die den exakten Typ zurückgibt: null -> "null", Array -> "array", RegExp -> "regexp", Function -> "function", Date -> "date", Object -> "object" und für Primitives den typeof-String.$val$,
  $val$determineDetailedType$val$,
  $val$[{"parameterName":"inputTarget","typeDescription":"unknown","description":"Zu prüfender Wert"}]$val$::jsonb,
  $val$function determineDetailedType(inputTarget) {
  // Achtung: typeof null ist 'object'. Nutze Object.prototype.toString
}$val$,
  $val$function determineDetailedType(inputTarget) {
  if (inputTarget === null) return 'null';
  if (Array.isArray(inputTarget)) return 'array';
  const rawTag = Object.prototype.toString.call(inputTarget);
  const match = rawTag.match(/\[object (\w+)\]/);
  return match ? match[1].toLowerCase() : typeof inputTarget;
}$val$,
  $val$[{"id":"p1-t1","description":"determineDetailedType(null) ergibt \"null\"","inputArguments":[null],"expectedOutput":"null","isHidden":false},{"id":"p1-t2","description":"determineDetailedType([1, 2]) ergibt \"array\"","inputArguments":[[1,2]],"expectedOutput":"array","isHidden":false},{"id":"p1-t3","description":"determineDetailedType(42) ergibt \"number\"","inputArguments":[42],"expectedOutput":"number","isHidden":false},{"id":"p1-t4","description":"determineDetailedType({}) ergibt \"object\"","inputArguments":[{}],"expectedOutput":"object","isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 1 Task: createStateCounter (task-p1-closure-counter)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p1-closure-counter$val$,
  1,
  $val$Paradigmen: Kapselung & Closures (createStateCounter)$val$,
  $val$Schreibe eine Factory-Funktion createStateCounter(initialValue), die ein Objekt mit increment(), decrement() und getValue() zurückgibt. Der State darf ausschließlich im lexikalischen Scope gekapselt sein.$val$,
  $val$createStateCounter$val$,
  $val$[{"parameterName":"initialValue","typeDescription":"number","description":"Startwert"}]$val$::jsonb,
  $val$function createStateCounter(initialValue) {
  // Kapsle den State in einer lokalen Variable
}$val$,
  $val$function createStateCounter(initialValue) {
  let counterState = initialValue;
  return {
    increment: () => ++counterState,
    decrement: () => --counterState,
    getValue: () => counterState
  };
}$val$,
  $val$[{"id":"p1-c1","description":"Zähler inkrementieren","inputArguments":[10],"expectedOutput":11,"isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 1 Task: executeWithContext (task-p1-context-executor)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p1-context-executor$val$,
  1,
  $val$Ausführungskontext: Explizites this-Binding (myCall & myApply)$val$,
  $val$Schreibe eine Funktion executeWithContext(targetFunction, contextObject, argumentList), die targetFunction im Kontext von contextObject mit den Argumenten aus argumentList ausführt und das Ergebnis zurückgibt.$val$,
  $val$executeWithContext$val$,
  $val$[{"parameterName":"targetFunction","typeDescription":"Function","description":"Aufzurufende Funktion"},{"parameterName":"contextObject","typeDescription":"object","description":"this-Kontext"},{"parameterName":"argumentList","typeDescription":"array","description":"Argumente"}]$val$::jsonb,
  $val$function executeWithContext(targetFunction, contextObject, argumentList) {
  // Nutze Function.prototype.apply
}$val$,
  $val$function executeWithContext(targetFunction, contextObject, argumentList) {
  return targetFunction.apply(contextObject, argumentList);
}$val$,
  $val$[{"id":"p1-ctx1","description":"this.greeting + name aufrufen","inputArguments":[null,null,[]],"expectedOutput":"OK","isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 2 Task: isAdult (task-p2-adult)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p2-adult$val$,
  2,
  $val$Bedingungen & Booleans (Volljährigkeit prüfen)$val$,
  $val$Schreibe eine Funktion isAdult, die ein Alter userAge entgegennimmt. Gibt true zurück, wenn das Alter mindestens 18 ist, andernfalls false.$val$,
  $val$isAdult$val$,
  $val$[{"parameterName":"userAge","typeDescription":"number","description":"Alter"}]$val$::jsonb,
  $val$function isAdult(userAge) {
  // Gib direkt den Vergleichsausdruck zurück
}$val$,
  $val$function isAdult(userAge) {
  return userAge >= 18;
}$val$,
  $val$[{"id":"t7-1","description":"isAdult(20) ergibt true","inputArguments":[20],"expectedOutput":true,"isHidden":false},{"id":"t7-2","description":"isAdult(16) ergibt false","inputArguments":[16],"expectedOutput":false,"isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 2 Task: isValidMessage (task-p2-trim-validation)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p2-trim-validation$val$,
  2,
  $val$Input-Validierung (Leere Nachrichten abfangen)$val$,
  $val$Schreibe eine Funktion isValidMessage, die einen String userInput entgegennimmt. Gibt true zurück, wenn nach dem Entfernen von Leerzeichen (trim) mindestens ein Zeichen übrig ist.$val$,
  $val$isValidMessage$val$,
  $val$[{"parameterName":"userInput","typeDescription":"string","description":"Eingabe"}]$val$::jsonb,
  $val$function isValidMessage(userInput) {
  // Prüfe mit .trim()
}$val$,
  $val$function isValidMessage(userInput) {
  return typeof userInput === 'string' && userInput.trim().length > 0;
}$val$,
  $val$[{"id":"t8-1","description":"isValidMessage(\"Hallo\") ergibt true","inputArguments":["Hallo"],"expectedOutput":true,"isHidden":false},{"id":"t8-2","description":"isValidMessage(\"   \") ergibt false","inputArguments":["   "],"expectedOutput":false,"isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 2 Task: calculateDiscount (task-p2-discount)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p2-discount$val$,
  2,
  $val$Guard Clauses (Rabatt berechnen)$val$,
  $val$Schreibe eine Funktion calculateDiscount. Wenn orderAmount <= 0 ist, gib sofort 0 zurück. Ab 100 Euro gibt es 10 % Rabatt (orderAmount * 0.1), sonst 0.$val$,
  $val$calculateDiscount$val$,
  $val$[{"parameterName":"orderAmount","typeDescription":"number","description":"Bestellwert"}]$val$::jsonb,
  $val$function calculateDiscount(orderAmount) {
  // Guard Clause zuerst
}$val$,
  $val$function calculateDiscount(orderAmount) {
  if (orderAmount <= 0) return 0;
  return orderAmount >= 100 ? orderAmount * 0.1 : 0;
}$val$,
  $val$[{"id":"t9-1","description":"calculateDiscount(-10) ergibt 0","inputArguments":[-10],"expectedOutput":0,"isHidden":false},{"id":"t9-2","description":"calculateDiscount(200) ergibt 20","inputArguments":[200],"expectedOutput":20,"isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 2 Task: clampNumber (task-p2-clamp)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p2-clamp$val$,
  2,
  $val$Zahlenwert begrenzen (clampNumber)$val$,
  $val$Schreibe eine Funktion clampNumber, die einen Wert currentValue innerhalb der Grenzen minimumValue und maximumValue hält.$val$,
  $val$clampNumber$val$,
  $val$[{"parameterName":"currentValue","typeDescription":"number","description":"Aktueller Wert"},{"parameterName":"minimumValue","typeDescription":"number","description":"Minimum"},{"parameterName":"maximumValue","typeDescription":"number","description":"Maximum"}]$val$::jsonb,
  $val$function clampNumber(currentValue, minimumValue, maximumValue) {
  // Begrenze auf Min und Max
}$val$,
  $val$function clampNumber(currentValue, minimumValue, maximumValue) {
  if (currentValue < minimumValue) return minimumValue;
  if (currentValue > maximumValue) return maximumValue;
  return currentValue;
}$val$,
  $val$[{"id":"t10-1","description":"clampNumber(15, 0, 10) ergibt 10","inputArguments":[15,0,10],"expectedOutput":10,"isHidden":false},{"id":"t10-2","description":"clampNumber(-5, 0, 10) ergibt 0","inputArguments":[-5,0,10],"expectedOutput":0,"isHidden":false},{"id":"t10-3","description":"clampNumber(7, 0, 10) ergibt 7","inputArguments":[7,0,10],"expectedOutput":7,"isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 2 Task: executeAllPromises (task-p2-promise-all-polyfill)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p2-promise-all-polyfill$val$,
  2,
  $val$Asynchrone Kontrollflüsse: Eigener Promise.all-Mechanismus$val$,
  $val$Schreibe eine Funktion executeAllPromises(promiseList), die ein Array von Werten oder Promises entgegennimmt und ein Promise zurückgibt, das ein Array aller aufgelösten Ergebnisse liefert.$val$,
  $val$executeAllPromises$val$,
  $val$[{"parameterName":"promiseList","typeDescription":"array","description":"Liste von Promises/Werten"}]$val$::jsonb,
  $val$function executeAllPromises(promiseList) {
  // Baue ein neues Promise, das alle Einträge auflöst
}$val$,
  $val$function executeAllPromises(promiseList) {
  return new Promise((resolve, reject) => {
    if (!promiseList.length) return resolve([]);
    const results = [];
    let completed = 0;
    promiseList.forEach((entry, idx) => {
      Promise.resolve(entry).then((val) => {
        results[idx] = val;
        if (++completed === promiseList.length) resolve(results);
      }).catch(reject);
    });
  });
}$val$,
  $val$[{"id":"p2-p1","description":"Leere Liste auflösen","inputArguments":[[]],"expectedOutput":[],"isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 2 Task: delayResolution (task-p2-async-delay)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p2-async-delay$val$,
  2,
  $val$Event Loop & Macrotasks: Asynchrone Verzögerung (delayMs)$val$,
  $val$Schreibe eine asynchrone Funktion delayResolution(valueToReturn, delayDurationMs), die valueToReturn erst nach Ablauf von delayDurationMs via setTimeout zurückgibt.$val$,
  $val$delayResolution$val$,
  $val$[{"parameterName":"valueToReturn","typeDescription":"unknown","description":"Rückgabewert"},{"parameterName":"delayDurationMs","typeDescription":"number","description":"Verzögerung in Millisekunden"}]$val$::jsonb,
  $val$function delayResolution(valueToReturn, delayDurationMs) {
  // Gib ein Promise zurück, das setTimeout verwendet
}$val$,
  $val$function delayResolution(valueToReturn, delayDurationMs) {
  return new Promise((resolve) => {
    setTimeout(() => resolve(valueToReturn), delayDurationMs);
  });
}$val$,
  $val$[{"id":"p2-d1","description":"delayResolution(\"Fertig\", 10) ergibt \"Fertig\"","inputArguments":["Fertig",10],"expectedOutput":"Fertig","isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 3 Task: getLastItem (task-p3-last-item)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p3-last-item$val$,
  3,
  $val$Sicherer Zugriff auf das letzte Element$val$,
  $val$Schreibe eine Funktion getLastItem, die das letzte Element eines Arrays itemList zurückgibt. Ist das Array leer, gib null zurück.$val$,
  $val$getLastItem$val$,
  $val$[{"parameterName":"itemList","typeDescription":"array","description":"Liste"}]$val$::jsonb,
  $val$function getLastItem(itemList) {
  // Zugriff über itemList.length - 1
}$val$,
  $val$function getLastItem(itemList) {
  if (!Array.isArray(itemList) || itemList.length === 0) return null;
  return itemList[itemList.length - 1];
}$val$,
  $val$[{"id":"t13-1","description":"getLastItem([1, 2, 99]) ergibt 99","inputArguments":[[1,2,99]],"expectedOutput":99,"isHidden":false},{"id":"t13-2","description":"getLastItem([]) ergibt null","inputArguments":[[]],"expectedOutput":null,"isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 3 Task: addItemImmutable (task-p3-immutable-add)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p3-immutable-add$val$,
  3,
  $val$Element unveränderlich hinzufügen (Immutability)$val$,
  $val$Schreibe eine Funktion addItemImmutable, die ein Array itemList und ein newItem entgegennimmt und ein NEUES Array mit dem hinzugefügten Element am Ende zurückgibt (ohne das Original-Array zu verändern!).$val$,
  $val$addItemImmutable$val$,
  $val$[{"parameterName":"itemList","typeDescription":"array","description":"Ausgangs-Array"},{"parameterName":"newItem","typeDescription":"unknown","description":"Neues Element"}]$val$::jsonb,
  $val$function addItemImmutable(itemList, newItem) {
  // Nutze den Spread-Operator [...]
}$val$,
  $val$function addItemImmutable(itemList, newItem) {
  return [...itemList, newItem];
}$val$,
  $val$[{"id":"t16-1","description":"addItemImmutable([1, 2], 3) ergibt [1, 2, 3]","inputArguments":[[1,2],3],"expectedOutput":[1,2,3],"isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 3 Task: deepCloneObject (task-p3-deep-clone)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p3-deep-clone$val$,
  3,
  $val$Tiefe Datenunveränderlichkeit: Deep Clone Algorithmus$val$,
  $val$Schreibe eine Funktion deepCloneObject(sourceData), die ein tief verschachteltes Objekt oder Array klont, sodass keine Referenzen zum Original erhalten bleiben.$val$,
  $val$deepCloneObject$val$,
  $val$[{"parameterName":"sourceData","typeDescription":"unknown","description":"Zu klonendes Objekt"}]$val$::jsonb,
  $val$function deepCloneObject(sourceData) {
  // Nutze Rekursion oder structuredClone()
}$val$,
  $val$function deepCloneObject(sourceData) {
  if (typeof structuredClone === 'function') {
    return structuredClone(sourceData);
  }
  return JSON.parse(JSON.stringify(sourceData));
}$val$,
  $val$[{"id":"p3-dc1","description":"Tiefes Objekt klonen","inputArguments":[{"a":{"b":42}}],"expectedOutput":{"a":{"b":42}},"isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 3 Task: resolveWithAbortCheck (task-p3-abortable-task)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p3-abortable-task$val$,
  3,
  $val$Web APIs: Kontrollierter Abbruch mit AbortSignal$val$,
  $val$Schreibe eine asynchrone Funktion resolveWithAbortCheck(taskPromise, abortSignal), die taskPromise auflöst oder den Fehler "Aborted" wirft, wenn signal.aborted true ist.$val$,
  $val$resolveWithAbortCheck$val$,
  $val$[{"parameterName":"taskPromise","typeDescription":"Promise","description":"Asynchrone Aufgabe"},{"parameterName":"abortSignal","typeDescription":"AbortSignal","description":"Signal zum Abbruch"}]$val$::jsonb,
  $val$function resolveWithAbortCheck(taskPromise, abortSignal) {
  // Prüfe abortSignal.aborted
}$val$,
  $val$async function resolveWithAbortCheck(taskPromise, abortSignal) {
  if (abortSignal && abortSignal.aborted) {
    throw new Error('Aborted');
  }
  return await taskPromise;
}$val$,
  $val$[{"id":"p3-ab1","description":"Aufgabe ohne Abbruch auflösen","inputArguments":[{},{"aborted":false}],"expectedOutput":"OK","isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 4 Task: doublePositiveNumbers (task-p4-double-positive)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p4-double-positive$val$,
  4,
  $val$Array-Transformation mit .filter() und .map()$val$,
  $val$Schreibe eine Funktion doublePositiveNumbers, die ein Array von Zahlen entgegennimmt, alle negativen Zahlen herausfiltert und die verbleibenden positiven Zahlen verdoppelt zurückgibt.$val$,
  $val$doublePositiveNumbers$val$,
  $val$[{"parameterName":"numbers","typeDescription":"array","description":"Zahlen-Array"}]$val$::jsonb,
  $val$function doublePositiveNumbers(numbers) {
  // Nutze .filter() und .map()
}$val$,
  $val$function doublePositiveNumbers(numbers) {
  return numbers.filter((num) => num > 0).map((num) => num * 2);
}$val$,
  $val$[{"id":"t19-1","description":"doublePositiveNumbers([-2, 3, -1, 4]) ergibt [6, 8]","inputArguments":[[-2,3,-1,4]],"expectedOutput":[6,8],"isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 4 Task: calculateCartTotal (task-p4-cart-total)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p4-cart-total$val$,
  4,
  $val$Summenbildung mit Array.reduce()$val$,
  $val$Schreibe eine Funktion calculateCartTotal, die ein Array von Objekten cartItems mit der Eigenschaft price entgegennimmt und den Gesamtwert mit reduce() berechnet.$val$,
  $val$calculateCartTotal$val$,
  $val$[{"parameterName":"cartItems","typeDescription":"array","description":"Warenkorb-Elemente"}]$val$::jsonb,
  $val$function calculateCartTotal(cartItems) {
  // Nutze cartItems.reduce()
}$val$,
  $val$function calculateCartTotal(cartItems) {
  return cartItems.reduce((runningTotal, currentItem) => runningTotal + currentItem.price, 0);
}$val$,
  $val$[{"id":"t20-1","description":"calculateCartTotal([{price: 10}, {price: 25}]) ergibt 35","inputArguments":[[{"price":10},{"price":25}]],"expectedOutput":35,"isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 4 Task: createObservableStore (task-p4-reactive-proxy)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p4-reactive-proxy$val$,
  4,
  $val$Meta-Programming: Reaktiver State-Store mit Proxy & Reflect$val$,
  $val$Schreibe eine Funktion createObservableStore(initialState, mutationLogArray), die ein Objekt mit einem Proxy umschließt. Jede Eigenschaftsänderung (set) soll den Schlüssel im mutationLogArray protokollieren und den Wert über Reflect.set speichern.$val$,
  $val$createObservableStore$val$,
  $val$[{"parameterName":"initialState","typeDescription":"object","description":"Ausgangsobjekt"},{"parameterName":"mutationLogArray","typeDescription":"array","description":"Log-Array für Mutationen"}]$val$::jsonb,
  $val$function createObservableStore(initialState, mutationLogArray) {
  // Nutze new Proxy(initialState, { set(target, prop, value) {...} })
}$val$,
  $val$function createObservableStore(initialState, mutationLogArray) {
  return new Proxy(initialState, {
    set(targetObject, propertyKey, propertyValue) {
      mutationLogArray.push(String(propertyKey));
      return Reflect.set(targetObject, propertyKey, propertyValue);
    }
  });
}$val$,
  $val$[{"id":"p4-pr1","description":"Proxy-Mutation testen","inputArguments":[{},[]],"expectedOutput":"OK","isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 4 Task: numberRangeGenerator (task-p4-generator-range)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p4-generator-range$val$,
  4,
  $val$Iteratoren & Generatoren: Custom Number Generator (function*)$val$,
  $val$Schreibe eine Generator-Funktion numberRangeGenerator(startNumber, stopNumber, stepSize), die Zahlen von startNumber bis einschließlich stopNumber mit yield liefert.$val$,
  $val$numberRangeGenerator$val$,
  $val$[{"parameterName":"startNumber","typeDescription":"number","description":"Start"},{"parameterName":"stopNumber","typeDescription":"number","description":"Ende"},{"parameterName":"stepSize","typeDescription":"number","description":"Schrittweite"}]$val$::jsonb,
  $val$function* numberRangeGenerator(startNumber, stopNumber, stepSize) {
  // Nutze eine Schleife mit yield
}$val$,
  $val$function* numberRangeGenerator(startNumber, stopNumber, stepSize) {
  for (let currentNumber = startNumber; currentNumber <= stopNumber; currentNumber += stepSize) {
    yield currentNumber;
  }
}$val$,
  $val$[{"id":"p4-gn1","description":"Range [1, 5, 2] ergibt [1, 3, 5]","inputArguments":[1,5,2],"expectedOutput":[1,3,5],"isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 5 Task: createAssertion (task-p5-assertion-framework)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p5-assertion-framework$val$,
  5,
  $val$Testing & Robustheit: Eigene Assertion-Bibliothek (expect().toBe())$val$,
  $val$Schreibe eine Funktion createAssertion(actualValue), die ein Objekt mit toBe(expectedValue) zurückgibt. Stimmen die Werte überein, gibt sie true zurück. Bei Abweichung wirft sie einen Error mit der Nachricht "Values did not match".$val$,
  $val$createAssertion$val$,
  $val$[{"parameterName":"actualValue","typeDescription":"unknown","description":"Tatsächlicher Wert"}]$val$::jsonb,
  $val$function createAssertion(actualValue) {
  // Nutze Object.is(actualValue, expectedValue)
}$val$,
  $val$function createAssertion(actualValue) {
  return {
    toBe: (expectedValue) => {
      if (Object.is(actualValue, expectedValue)) return true;
      throw new Error('Values did not match');
    }
  };
}$val$,
  $val$[{"id":"p5-as1","description":"createAssertion(42).toBe(42) ergibt true","inputArguments":[42],"expectedOutput":true,"isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;

-- Phase 5 Task: composePipeline (task-p5-function-pipe)
INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES (
  $val$task-p5-function-pipe$val$,
  5,
  $val$Code-Architektur: Funktionale Pipeline-Komposition (pipe)$val$,
  $val$Schreibe eine Funktion composePipeline(...functionsList), die eine neue Funktion zurückgibt. Diese nimmt einen Eingabewert initialValue entgegen und wendet die Funktionen der Liste nacheinander von links nach rechts an.$val$,
  $val$composePipeline$val$,
  $val$[{"parameterName":"functionsList","typeDescription":"Function[]","description":"Liste von Funktionen"}]$val$::jsonb,
  $val$function composePipeline(...functionsList) {
  // Nutze functionsList.reduce()
}$val$,
  $val$function composePipeline(...functionsList) {
  return (initialValue) => {
    return functionsList.reduce((currentResult, nextFunction) => nextFunction(currentResult), initialValue);
  };
}$val$,
  $val$[{"id":"p5-pp1","description":"Pipeline-Komposition testen","inputArguments":[],"expectedOutput":"OK","isHidden":false}]$val$::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  stage = EXCLUDED.stage,
  scenario_description = EXCLUDED.scenario_description,
  function_name = EXCLUDED.function_name,
  parameters = EXCLUDED.parameters,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;
