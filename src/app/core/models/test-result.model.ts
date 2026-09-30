export type ExecutionStatus =
  | 'idle'
  | 'running'
  | 'success'
  | 'assertion_failure'
  | 'syntax_error'
  | 'runtime_error'
  | 'timeout';

export interface ConsoleLogEntry {
  readonly timestamp: number;
  readonly level: 'log' | 'info' | 'warn' | 'error';
  readonly message: string;
}

export interface SingleTestResult {
  readonly testCaseId: string;
  readonly description: string;
  readonly passed: boolean;
  readonly expectedOutput: unknown;
  readonly actualOutput: unknown;
  readonly executionTimeMs: number;
  readonly failureMessage: string | null;
}

export interface ExecutionReport {
  readonly status: ExecutionStatus;
  readonly passedCount: number;
  readonly totalCount: number;
  readonly allPassed: boolean;
  readonly testResults: readonly SingleTestResult[];
  readonly consoleLogs: readonly ConsoleLogEntry[];
  readonly totalExecutionTimeMs: number;
  readonly globalErrorMessage: string | null;
}
