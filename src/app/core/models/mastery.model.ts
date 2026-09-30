export interface MasteryRepetitionItem {
  readonly taskId: string;
  readonly repetitionCount: number;
  readonly intervalDays: number;
  readonly easeFactor: number;
  readonly nextDueDate: string;
  readonly isGraduated: boolean;
}

export interface MasteryOverview {
  readonly totalCompleted: number;
  readonly totalTasks: number;
  readonly isCurriculumCompleted: boolean;
  readonly masteryPercentage: number;
  readonly currentStreak: number;
}

export interface CustomKataPayload {
  readonly title: string;
  readonly stage: 1 | 2 | 3 | 4 | 5;
  readonly scenarioDescription: string;
  readonly functionName: string;
  readonly starterCode: string;
  readonly solutionCode: string;
  readonly testCases: readonly {
    readonly id: string;
    readonly description: string;
    readonly inputArguments: readonly unknown[];
    readonly expectedOutput: unknown;
    readonly isHidden: boolean;
  }[];
}
