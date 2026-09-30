import { TestBed } from '@angular/core/testing';
import { TestRunnerService } from './test-runner.service';
import { TaskTestCase } from '../models';

describe('TestRunnerService', () => {
  let serviceInstance: TestRunnerService;

  const mockTestCases: readonly TaskTestCase[] = [
    {
      id: 'test-case-1',
      description: 'calculateSum(2, 3) equals 5',
      inputArguments: [2, 3],
      expectedOutput: 5,
      isHidden: false
    },
    {
      id: 'test-case-2',
      description: 'calculateSum(10, -5) equals 5',
      inputArguments: [10, -5],
      expectedOutput: 5,
      isHidden: false
    }
  ];

  beforeEach(() => {
    TestBed.configureTestingModule({});
    serviceInstance = TestBed.inject(TestRunnerService);
  });

  it('should compile and pass all assertions for a correct solution', async () => {
    const validCode = 'function calculateSum(firstNumber, secondNumber) { return firstNumber + secondNumber; }';
    const executionReport = await serviceInstance.executeTestSuite(validCode, mockTestCases);

    expect(executionReport.allPassed).toBeTrue();
    expect(executionReport.passedCount).toBe(2);
    expect(executionReport.status).toBe('success');
  });

  it('should support asynchronous functions and promises', async () => {
    const asyncCode = 'async function calculateSum(firstNumber, secondNumber) { return firstNumber + secondNumber; }';
    const executionReport = await serviceInstance.executeTestSuite(asyncCode, mockTestCases);

    expect(executionReport.allPassed).toBeTrue();
    expect(executionReport.passedCount).toBe(2);
    expect(executionReport.status).toBe('success');
  });

  it('should diagnose undefined output when return statement is omitted', async () => {
    const codeWithoutReturn = 'function calculateSum(firstNumber, secondNumber) { console.log(firstNumber + secondNumber); }';
    const executionReport = await serviceInstance.executeTestSuite(codeWithoutReturn, mockTestCases);

    expect(executionReport.allPassed).toBeFalse();
    expect(executionReport.status).toBe('assertion_failure');
    expect(executionReport.testResults[0].failureMessage).toContain("Did you forget the 'return' statement?");
  });

  it('should catch syntax errors gracefully without crashing', async () => {
    const brokenCode = 'function calculateSum(firstNumber, secondNumber) { return firstNumber +; }';
    const executionReport = await serviceInstance.executeTestSuite(brokenCode, mockTestCases);

    expect(executionReport.allPassed).toBeFalse();
    expect(executionReport.status).toBe('syntax_error');
    expect(executionReport.globalErrorMessage).toBeTruthy();
  });
});
