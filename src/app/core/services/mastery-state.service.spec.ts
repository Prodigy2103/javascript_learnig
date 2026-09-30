import { TestBed } from '@angular/core/testing';
import { MasteryStateService } from './mastery-state.service';
import { SupabaseService } from './supabase.service';
import { ExecutionReport } from '../models';

describe('MasteryStateService', () => {
  let service: MasteryStateService;
  let supabaseMock: jasmine.SpyObj<SupabaseService>;

  const mockSuccessReport: ExecutionReport = {
    status: 'success',
    passedCount: 2,
    totalCount: 2,
    allPassed: true,
    testResults: [],
    consoleLogs: [],
    totalExecutionTimeMs: 15,
    globalErrorMessage: null
  };

  const mockFailureReport: ExecutionReport = {
    status: 'assertion_failure',
    passedCount: 1,
    totalCount: 2,
    allPassed: false,
    testResults: [],
    consoleLogs: [],
    totalExecutionTimeMs: 20,
    globalErrorMessage: null
  };

  beforeEach(() => {
    supabaseMock = jasmine.createSpyObj<SupabaseService>('SupabaseService', [
      'recordTaskProgress',
      'insertCustomKata'
    ]);
    supabaseMock.recordTaskProgress.and.resolveTo(null);

    TestBed.configureTestingModule({
      providers: [
        MasteryStateService,
        { provide: SupabaseService, useValue: supabaseMock }
      ]
    });
    service = TestBed.inject(MasteryStateService);
  });

  it('should initialize with 0 completed tasks and closed modals', () => {
    expect(service.completedCount()).toBe(0);
    expect(service.isGraduationModalOpen()).toBeFalse();
    expect(service.isKataStudioOpen()).toBeFalse();
  });

  it('should mark task completed and compute overview percentage', () => {
    service.registerTestResult('task-1', mockSuccessReport, 4, 1);
    const overview = service.getMasteryOverview(4, 3);

    expect(service.completedCount()).toBe(1);
    expect(overview.masteryPercentage).toBe(25);
    expect(overview.isCurriculumCompleted).toBeFalse();
  });

  it('should open graduation modal when all tasks are completed', () => {
    service.registerTestResult('task-1', mockSuccessReport, 2, 1);
    expect(service.isGraduationModalOpen()).toBeFalse();

    service.registerTestResult('task-2', mockSuccessReport, 2, 1);
    expect(service.completedCount()).toBe(2);
    expect(service.isGraduationModalOpen()).toBeTrue();
  });

  it('should not mark task as completed on assertion failure', () => {
    service.registerTestResult('task-failed', mockFailureReport, 5, 1);
    expect(service.completedCount()).toBe(0);
  });

  it('should toggle Kata Studio modal correctly', () => {
    service.openKataStudio();
    expect(service.isKataStudioOpen()).toBeTrue();

    service.closeKataStudio();
    expect(service.isKataStudioOpen()).toBeFalse();
  });
});
