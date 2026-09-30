import { Injectable } from '@angular/core';
import { ExecutionReport, ExecutionStatus, SingleTestResult, TaskTestCase } from '../models';

@Injectable({
  providedIn: 'root'
})
export class TestRunnerService {
  public async executeTestSuite(functionCode: string, testCases: readonly TaskTestCase[]): Promise<ExecutionReport> {
    const startTimeStamp = performance.now();
    const evaluationOutcome = this.compileUserFunction(functionCode);

    if (!evaluationOutcome.compiledFunction) {
      return this.buildSyntaxErrorReport(evaluationOutcome.errorMessage, performance.now() - startTimeStamp);
    }

    const testResults = await this.runIndividualCases(evaluationOutcome.compiledFunction, testCases);
    return this.buildExecutionReport(testResults, performance.now() - startTimeStamp);
  }

  private compileUserFunction(functionCode: string): { compiledFunction: Function | null; errorMessage: string | null } {
    try {
      const wrappedFactory = new Function(`"use strict"; return (${functionCode});`);
      const compiledFunction = wrappedFactory();
      return typeof compiledFunction === 'function'
        ? { compiledFunction, errorMessage: null }
        : { compiledFunction: null, errorMessage: 'Code must define and return a valid function.' };
    } catch (syntaxError) {
      const failureMessage = syntaxError instanceof Error ? syntaxError.message : 'Syntax error in code.';
      return { compiledFunction: null, errorMessage: failureMessage };
    }
  }

  private async runIndividualCases(userFunction: Function, testCases: readonly TaskTestCase[]): Promise<readonly SingleTestResult[]> {
    const results: SingleTestResult[] = [];
    for (const testCase of testCases) {
      results.push(await this.evaluateSingleCase(userFunction, testCase));
    }
    return results;
  }

  private async evaluateSingleCase(userFunction: Function, testCase: TaskTestCase): Promise<SingleTestResult> {
    const executionStart = performance.now();
    try {
      const actualOutput = await Promise.resolve(userFunction(...testCase.inputArguments));
      const passed = this.compareOutputs(actualOutput, testCase.expectedOutput);
      const failureMessage = passed ? null : this.generateFailureDiagnostic(actualOutput, testCase.expectedOutput);
      return this.createSingleResult(testCase, passed, testCase.expectedOutput, actualOutput, performance.now() - executionStart, failureMessage);
    } catch (runtimeError) {
      const errorMessage = runtimeError instanceof Error ? runtimeError.message : 'Runtime execution error.';
      return this.createSingleResult(testCase, false, testCase.expectedOutput, undefined, performance.now() - executionStart, errorMessage);
    }
  }

  private createSingleResult(
    testCase: TaskTestCase,
    passed: boolean,
    expectedOutput: unknown,
    actualOutput: unknown,
    executionTimeMs: number,
    failureMessage: string | null
  ): SingleTestResult {
    return {
      testCaseId: testCase.id,
      description: testCase.description,
      passed,
      expectedOutput,
      actualOutput,
      executionTimeMs: Math.round(executionTimeMs * 100) / 100,
      failureMessage
    };
  }

  private compareOutputs(actualOutput: unknown, expectedOutput: unknown): boolean {
    return JSON.stringify(actualOutput) === JSON.stringify(expectedOutput);
  }

  private generateFailureDiagnostic(actualOutput: unknown, expectedOutput: unknown): string {
    if (actualOutput === undefined) {
      return `Expected ${JSON.stringify(expectedOutput)}, but received undefined. Did you forget the 'return' statement?`;
    }
    return `Expected ${JSON.stringify(expectedOutput)}, but received ${JSON.stringify(actualOutput)}.`;
  }

  private buildSyntaxErrorReport(syntaxErrorMessage: string | null, totalDurationMs: number): ExecutionReport {
    return {
      status: 'syntax_error',
      passedCount: 0,
      totalCount: 0,
      allPassed: false,
      testResults: [],
      consoleLogs: [],
      totalExecutionTimeMs: Math.round(totalDurationMs * 100) / 100,
      globalErrorMessage: syntaxErrorMessage
    };
  }

  private buildExecutionReport(testResults: readonly SingleTestResult[], totalDurationMs: number): ExecutionReport {
    const passedCount = testResults.filter((result) => result.passed).length;
    const allPassed = passedCount === testResults.length && testResults.length > 0;
    const finalStatus: ExecutionStatus = allPassed ? 'success' : 'assertion_failure';

    return {
      status: finalStatus,
      passedCount,
      totalCount: testResults.length,
      allPassed,
      testResults,
      consoleLogs: [],
      totalExecutionTimeMs: Math.round(totalDurationMs * 100) / 100,
      globalErrorMessage: null
    };
  }
}
