import { inject, Injectable, PLATFORM_ID, signal } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { LearningTask } from '../models';
import { SupabaseService } from './supabase.service';

@Injectable({
  providedIn: 'root'
})
export class TaskCatalogService {
  private readonly supabaseService = inject(SupabaseService);
  private readonly platformId = inject(PLATFORM_ID);

  private readonly defaultTasks: readonly LearningTask[] = [
    {
      id: 'task-stage-1-return-01',
      templateId: 'tpl-return-basic',
      stage: 1,
      title: 'Funktion mit Rückgabewert definieren',
      scenarioDescription: 'Schreibe eine Funktion calculateSum, die zwei Zahlen als Parameter entgegennimmt und deren Summe mit return zurückgibt.',
      functionName: 'calculateSum',
      parameters: [
        { parameterName: 'firstNumber', typeDescription: 'number', description: 'Erste Zahl' },
        { parameterName: 'secondNumber', typeDescription: 'number', description: 'Zweite Zahl' }
      ],
      starterCode: 'function calculateSum(firstNumber, secondNumber) {\n  // Schreibe hier deinen Code\n}',
      solutionCode: 'function calculateSum(firstNumber, secondNumber) {\n  return firstNumber + secondNumber;\n}',
      testCases: [
        { id: 'test-1-1', description: 'calculateSum(2, 3) ergibt 5', inputArguments: [2, 3], expectedOutput: 5, isHidden: false },
        { id: 'test-1-2', description: 'calculateSum(-10, 20) ergibt 10', inputArguments: [-10, 20], expectedOutput: 10, isHidden: false },
        { id: 'test-1-3', description: 'calculateSum(0, 0) ergibt 0', inputArguments: [0, 0], expectedOutput: 0, isHidden: false }
      ]
    },
    {
      id: 'task-stage-1-strings-02',
      templateId: 'tpl-string-greeting',
      stage: 1,
      title: 'Text-Ausgabe formatieren (Template Literals)',
      scenarioDescription: 'Schreibe eine Funktion formatGreeting, die einen Namen als Parameter personName entgegennimmt und die Begrüßung "Hallo, [Name]!" zurückgibt.',
      functionName: 'formatGreeting',
      parameters: [
        { parameterName: 'personName', typeDescription: 'string', description: 'Der Name der Person' }
      ],
      starterCode: 'function formatGreeting(personName) {\n  // Schreibe hier deinen Code\n}',
      solutionCode: 'function formatGreeting(personName) {\n  return `Hallo, ${personName}!`;\n}',
      testCases: [
        { id: 'test-2-1', description: 'formatGreeting("Anna") ergibt "Hallo, Anna!"', inputArguments: ['Anna'], expectedOutput: 'Hallo, Anna!', isHidden: false },
        { id: 'test-2-2', description: 'formatGreeting("Marcus") ergibt "Hallo, Marcus!"', inputArguments: ['Marcus'], expectedOutput: 'Hallo, Marcus!', isHidden: false }
      ]
    },
    {
      id: 'task-stage-2-conditionals-03',
      templateId: 'tpl-boolean-logic',
      stage: 2,
      title: 'Bedingungen & Booleans (Volljährigkeit prüfen)',
      scenarioDescription: 'Schreibe eine Funktion isAdult, die ein Alter userAge entgegennimmt. Gibt true zurück, wenn das Alter mindestens 18 ist, andernfalls false.',
      functionName: 'isAdult',
      parameters: [
        { parameterName: 'userAge', typeDescription: 'number', description: 'Alter der Person' }
      ],
      starterCode: 'function isAdult(userAge) {\n  // Schreibe hier deinen Code\n}',
      solutionCode: 'function isAdult(userAge) {\n  return userAge >= 18;\n}',
      testCases: [
        { id: 'test-3-1', description: 'isAdult(20) ergibt true', inputArguments: [20], expectedOutput: true, isHidden: false },
        { id: 'test-3-2', description: 'isAdult(16) ergibt false', inputArguments: [16], expectedOutput: false, isHidden: false }
      ]
    }
  ];

  public readonly tasksSignal = signal<readonly LearningTask[]>(this.defaultTasks);

  constructor() {
    if (isPlatformBrowser(this.platformId)) {
      this.syncWithSupabase();
    }
  }

  public async syncWithSupabase(): Promise<void> {
    if (!this.supabaseService.isAvailable()) {
      return;
    }
    const remoteTasks = await this.supabaseService.fetchAllTasks();
    if (remoteTasks.length > 0) {
      this.tasksSignal.set(remoteTasks);
    }
  }

  public getAllTasks(): readonly LearningTask[] {
    return this.tasksSignal();
  }

  public getTaskByIndex(taskIndex: number): LearningTask | null {
    const currentList = this.tasksSignal();
    return taskIndex >= 0 && taskIndex < currentList.length ? currentList[taskIndex] : null;
  }

  public getTotalCount(): number {
    return this.tasksSignal().length;
  }
}
