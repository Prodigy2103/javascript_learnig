-- Seed Tasks for JavaScript Learning Lab (Stages 1 to 4)
-- Run this in your Supabase SQL Editor after running schema.sql

INSERT INTO tasks (id, stage, title, scenario_description, function_name, parameters, starter_code, solution_code, test_cases)
VALUES
  -- STAGE 1: ANATOMIE & SYNTAX
  (
    'task-s1-sum',
    1,
    'Funktion mit Rückgabewert definieren',
    'Schreibe eine Funktion calculateSum, die zwei Zahlen als Parameter entgegennimmt und deren Summe mit return zurückgibt.',
    'calculateSum',
    '[{"parameterName": "firstNumber", "typeDescription": "number", "description": "Erste Zahl"}, {"parameterName": "secondNumber", "typeDescription": "number", "description": "Zweite Zahl"}]'::jsonb,
    'function calculateSum(firstNumber, secondNumber) {\n  // Schreibe hier deinen Code\n}',
    'function calculateSum(firstNumber, secondNumber) {\n  return firstNumber + secondNumber;\n}',
    '[{"id": "t1-1", "description": "calculateSum(2, 3) ergibt 5", "inputArguments": [2, 3], "expectedOutput": 5, "isHidden": false}, {"id": "t1-2", "description": "calculateSum(-10, 20) ergibt 10", "inputArguments": [-10, 20], "expectedOutput": 10, "isHidden": false}, {"id": "t1-3", "description": "calculateSum(0, 0) ergibt 0", "inputArguments": [0, 0], "expectedOutput": 0, "isHidden": false}]'::jsonb
  ),
  (
    'task-s1-greeting',
    1,
    'Text-Ausgabe formatieren (Template Literals)',
    'Schreibe eine Funktion formatGreeting, die einen Namen als Parameter personName entgegennimmt und die Begrüßung "Hallo, [Name]!" zurückgibt.',
    'formatGreeting',
    '[{"parameterName": "personName", "typeDescription": "string", "description": "Name der Person"}]'::jsonb,
    'function formatGreeting(personName) {\n  // Schreibe hier deinen Code\n}',
    'function formatGreeting(personName) {\n  return `Hallo, ${personName}!`;\n}',
    '[{"id": "t2-1", "description": "formatGreeting(\"Anna\") ergibt \"Hallo, Anna!\"", "inputArguments": ["Anna"], "expectedOutput": "Hallo, Anna!", "isHidden": false}, {"id": "t2-2", "description": "formatGreeting(\"Marcus\") ergibt \"Hallo, Marcus!\"", "inputArguments": ["Marcus"], "expectedOutput": "Hallo, Marcus!", "isHidden": false}]'::jsonb
  ),
  (
    'task-s1-capitalized-name',
    1,
    'String-Veredelung (Ersten Buchstaben großschreiben)',
    'Schreibe eine Funktion formatCapitalizedName, die einen String rawName entgegennimmt und ihn so zurückgibt, dass der erste Buchstabe großgeschrieben ist und der Rest unverändert bleibt.',
    'formatCapitalizedName',
    '[{"parameterName": "rawName", "typeDescription": "string", "description": "Eingebener Name"}]'::jsonb,
    'function formatCapitalizedName(rawName) {\n  // Nutze charAt(0).toUpperCase() und slice(1)\n}',
    'function formatCapitalizedName(rawName) {\n  if (!rawName) return "";\n  return rawName.charAt(0).toUpperCase() + rawName.slice(1);\n}',
    '[{"id": "t3-1", "description": "formatCapitalizedName(\"marcus\") ergibt \"Marcus\"", "inputArguments": ["marcus"], "expectedOutput": "Marcus", "isHidden": false}, {"id": "t3-2", "description": "formatCapitalizedName(\"anna\") ergibt \"Anna\"", "inputArguments": ["anna"], "expectedOutput": "Anna", "isHidden": false}]'::jsonb
  ),
  (
    'task-s1-pad-time',
    1,
    'Uhrzeit zweistellig formatieren (padStart)',
    'Schreibe eine Funktion formatTime, die zwei Zahlen hours und minutes entgegennimmt und sie als String im Format "HH:MM" (jeweils mit führender Null bei einstelligen Zahlen) zurückgibt.',
    'formatTime',
    '[{"parameterName": "hours", "typeDescription": "number", "description": "Stunden"}, {"parameterName": "minutes", "typeDescription": "number", "description": "Minuten"}]'::jsonb,
    'function formatTime(hours, minutes) {\n  // Nutze String().padStart(2, "0")\n}',
    'function formatTime(hours, minutes) {\n  const formattedHours = String(hours).padStart(2, "0");\n  const formattedMinutes = String(minutes).padStart(2, "0");\n  return `${formattedHours}:${formattedMinutes}`;\n}',
    '[{"id": "t4-1", "description": "formatTime(8, 5) ergibt \"08:05\"", "inputArguments": [8, 5], "expectedOutput": "08:05", "isHidden": false}, {"id": "t4-2", "description": "formatTime(14, 30) ergibt \"14:30\"", "inputArguments": [14, 30], "expectedOutput": "14:30", "isHidden": false}]'::jsonb
  ),
  (
    'task-s1-celsius',
    1,
    'Temperatur umrechnen (Celsius in Fahrenheit)',
    'Schreibe eine Funktion convertCelsiusToFahrenheit, die eine Temperatur in celsius entgegennimmt und den entsprechenden Fahrenheit-Wert berechnet ((celsius * 9/5) + 32).',
    'convertCelsiusToFahrenheit',
    '[{"parameterName": "celsius", "typeDescription": "number", "description": "Temperatur in Grad Celsius"}]'::jsonb,
    'function convertCelsiusToFahrenheit(celsius) {\n  // Berechne Fahrenheit und gib es zurück\n}',
    'function convertCelsiusToFahrenheit(celsius) {\n  return (celsius * 9 / 5) + 32;\n}',
    '[{"id": "t5-1", "description": "convertCelsiusToFahrenheit(0) ergibt 32", "inputArguments": [0], "expectedOutput": 32, "isHidden": false}, {"id": "t5-2", "description": "convertCelsiusToFahrenheit(100) ergibt 212", "inputArguments": [100], "expectedOutput": 212, "isHidden": false}]'::jsonb
  ),
  (
    'task-s1-average',
    1,
    'Mittelwert aus drei Zahlen berechnen',
    'Schreibe eine Funktion calculateAverage, die drei Zahlen entgegennimmt und deren arithmetisches Mittel zurückgibt.',
    'calculateAverage',
    '[{"parameterName": "firstNumber", "typeDescription": "number", "description": "Zahl 1"}, {"parameterName": "secondNumber", "typeDescription": "number", "description": "Zahl 2"}, {"parameterName": "thirdNumber", "typeDescription": "number", "description": "Zahl 3"}]'::jsonb,
    'function calculateAverage(firstNumber, secondNumber, thirdNumber) {\n  // Summe geteilt durch 3\n}',
    'function calculateAverage(firstNumber, secondNumber, thirdNumber) {\n  return (firstNumber + secondNumber + thirdNumber) / 3;\n}',
    '[{"id": "t6-1", "description": "calculateAverage(10, 20, 30) ergibt 20", "inputArguments": [10, 20, 30], "expectedOutput": 20, "isHidden": false}, {"id": "t6-2", "description": "calculateAverage(3, 3, 3) ergibt 3", "inputArguments": [3, 3, 3], "expectedOutput": 3, "isHidden": false}]'::jsonb
  ),

  -- STAGE 2: KONTROLLFLUSS & GUARD CLAUSES
  (
    'task-s2-adult',
    2,
    'Bedingungen & Booleans (Volljährigkeit prüfen)',
    'Schreibe eine Funktion isAdult, die ein Alter userAge entgegennimmt. Gibt true zurück, wenn das Alter mindestens 18 ist, andernfalls false.',
    'isAdult',
    '[{"parameterName": "userAge", "typeDescription": "number", "description": "Alter"}]'::jsonb,
    'function isAdult(userAge) {\n  // Gib direkt den Vergleichsausdruck zurück\n}',
    'function isAdult(userAge) {\n  return userAge >= 18;\n}',
    '[{"id": "t7-1", "description": "isAdult(20) ergibt true", "inputArguments": [20], "expectedOutput": true, "isHidden": false}, {"id": "t7-2", "description": "isAdult(16) ergibt false", "inputArguments": [16], "expectedOutput": false, "isHidden": false}]'::jsonb
  ),
  (
    'task-s2-trim-validation',
    2,
    'Input-Validierung (Leere Nachrichten abfangen)',
    'Schreibe eine Funktion isValidMessage, die einen String userInput entgegennimmt. Gibt true zurück, wenn nach dem Entfernen von Leerzeichen (trim) mindestens ein Zeichen übrig ist.',
    'isValidMessage',
    '[{"parameterName": "userInput", "typeDescription": "string", "description": "Eingabe"}]'::jsonb,
    'function isValidMessage(userInput) {\n  // Prüfe mit .trim()\n}',
    'function isValidMessage(userInput) {\n  return typeof userInput === "string" && userInput.trim().length > 0;\n}',
    '[{"id": "t8-1", "description": "isValidMessage(\"Hallo\") ergibt true", "inputArguments": ["Hallo"], "expectedOutput": true, "isHidden": false}, {"id": "t8-2", "description": "isValidMessage(\"   \") ergibt false", "inputArguments": ["   "], "expectedOutput": false, "isHidden": false}]'::jsonb
  ),
  (
    'task-s2-discount',
    2,
    'Guard Clauses (Rabatt berechnen)',
    'Schreibe eine Funktion calculateDiscount. Wenn orderAmount <= 0 ist, gib sofort 0 zurück. Ab 100 Euro gibt es 10 % Rabatt (orderAmount * 0.1), sonst 0.',
    'calculateDiscount',
    '[{"parameterName": "orderAmount", "typeDescription": "number", "description": "Bestellwert"}]'::jsonb,
    'function calculateDiscount(orderAmount) {\n  // Guard Clause zuerst\n}',
    'function calculateDiscount(orderAmount) {\n  if (orderAmount <= 0) return 0;\n  return orderAmount >= 100 ? orderAmount * 0.1 : 0;\n}',
    '[{"id": "t9-1", "description": "calculateDiscount(-10) ergibt 0", "inputArguments": [-10], "expectedOutput": 0, "isHidden": false}, {"id": "t9-2", "description": "calculateDiscount(200) ergibt 20", "inputArguments": [200], "expectedOutput": 20, "isHidden": false}]'::jsonb
  ),
  (
    'task-s2-clamp',
    2,
    'Zahlenwert begrenzen (clampNumber)',
    'Schreibe eine Funktion clampNumber, die einen Wert currentValue innerhalb der Grenzen minimumValue und maximumValue hält.',
    'clampNumber',
    '[{"parameterName": "currentValue", "typeDescription": "number", "description": "Aktueller Wert"}, {"parameterName": "minimumValue", "typeDescription": "number", "description": "Minimum"}, {"parameterName": "maximumValue", "typeDescription": "number", "description": "Maximum"}]'::jsonb,
    'function clampNumber(currentValue, minimumValue, maximumValue) {\n  // Begrenze auf Min und Max\n}',
    'function clampNumber(currentValue, minimumValue, maximumValue) {\n  if (currentValue < minimumValue) return minimumValue;\n  if (currentValue > maximumValue) return maximumValue;\n  return currentValue;\n}',
    '[{"id": "t10-1", "description": "clampNumber(15, 0, 10) ergibt 10", "inputArguments": [15, 0, 10], "expectedOutput": 10, "isHidden": false}, {"id": "t10-2", "description": "clampNumber(-5, 0, 10) ergibt 0", "inputArguments": [-5, 0, 10], "expectedOutput": 0, "isHidden": false}, {"id": "t10-3", "description": "clampNumber(7, 0, 10) ergibt 7", "inputArguments": [7, 0, 10], "expectedOutput": 7, "isHidden": false}]'::jsonb
  ),

  -- STAGE 3: DATENSTRUKTUREN & UNVERÄNDERLICHKEIT
  (
    'task-s3-last-item',
    3,
    'Sicherer Zugriff auf das letzte Element',
    'Schreibe eine Funktion getLastItem, die das letzte Element eines Arrays itemList zurückgibt. Ist das Array leer, gib null zurück.',
    'getLastItem',
    '[{"parameterName": "itemList", "typeDescription": "array", "description": "Liste"}]'::jsonb,
    'function getLastItem(itemList) {\n  // Zugriff über itemList.length - 1\n}',
    'function getLastItem(itemList) {\n  if (!Array.isArray(itemList) || itemList.length === 0) return null;\n  return itemList[itemList.length - 1];\n}',
    '[{"id": "t13-1", "description": "getLastItem([1, 2, 99]) ergibt 99", "inputArguments": [[1, 2, 99]], "expectedOutput": 99, "isHidden": false}, {"id": "t13-2", "description": "getLastItem([]) ergibt null", "inputArguments": [[]], "expectedOutput": null, "isHidden": false}]'::jsonb
  ),
  (
    'task-s3-immutable-add',
    3,
    'Element unveränderlich hinzufügen (Immutability)',
    'Schreibe eine Funktion addItemImmutable, die ein Array itemList und ein newItem entgegennimmt und ein NEUES Array mit dem hinzugefügten Element am Ende zurückgibt (ohne das Original-Array zu verändern!).',
    'addItemImmutable',
    '[{"parameterName": "itemList", "typeDescription": "array", "description": "Ausgangs-Array"}, {"parameterName": "newItem", "typeDescription": "unknown", "description": "Neues Element"}]'::jsonb,
    'function addItemImmutable(itemList, newItem) {\n  // Nutze den Spread-Operator [...]\n}',
    'function addItemImmutable(itemList, newItem) {\n  return [...itemList, newItem];\n}',
    '[{"id": "t16-1", "description": "addItemImmutable([1, 2], 3) ergibt [1, 2, 3]", "inputArguments": [[1, 2], 3], "expectedOutput": [1, 2, 3], "isHidden": false}]'::jsonb
  ),

  -- STAGE 4: FORTGESCHRITTENE METHODEN & REDUCE
  (
    'task-s4-double-positive',
    4,
    'Array Chaining (filter & map)',
    'Schreibe eine Funktion doublePositiveNumbers, die ein Array von Zahlen entgegennimmt, alle positiven Zahlen (> 0) filtert und diese verdoppelt zurückgibt.',
    'doublePositiveNumbers',
    '[{"parameterName": "numbers", "typeDescription": "array", "description": "Zahlen-Array"}]'::jsonb,
    'function doublePositiveNumbers(numbers) {\n  // Nutze .filter() und .map()\n}',
    'function doublePositiveNumbers(numbers) {\n  return numbers.filter((num) => num > 0).map((num) => num * 2);\n}',
    '[{"id": "t19-1", "description": "doublePositiveNumbers([-2, 3, -1, 4]) ergibt [6, 8]", "inputArguments": [[-2, 3, -1, 4]], "expectedOutput": [6, 8], "isHidden": false}]'::jsonb
  ),
  (
    'task-s4-cart-total',
    4,
    'Summenbildung mit Array.reduce()',
    'Schreibe eine Funktion calculateCartTotal, die ein Array von Objekten cartItems mit der Eigenschaft price entgegennimmt und den Gesamtwert mit reduce() berechnet.',
    'calculateCartTotal',
    '[{"parameterName": "cartItems", "typeDescription": "array", "description": "Warenkorb-Elemente"}]'::jsonb,
    'function calculateCartTotal(cartItems) {\n  // Nutze cartItems.reduce()\n}',
    'function calculateCartTotal(cartItems) {\n  return cartItems.reduce((runningTotal, currentItem) => runningTotal + currentItem.price, 0);\n}',
    '[{"id": "t20-1", "description": "calculateCartTotal([{price: 10}, {price: 25}]) ergibt 35", "inputArguments": [[{"price": 10}, {"price": 25}]], "expectedOutput": 35, "isHidden": false}]'::jsonb
  )
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  scenario_description = EXCLUDED.scenario_description,
  starter_code = EXCLUDED.starter_code,
  solution_code = EXCLUDED.solution_code,
  test_cases = EXCLUDED.test_cases;
