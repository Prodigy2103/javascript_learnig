import { inject, Injectable, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { createClient, SupabaseClient } from '@supabase/supabase-js';
import { environment } from '../../../environments/environment';
import { LearningTask, ExecutionReport, CustomKataPayload, MasteryRepetitionItem } from '../models';

@Injectable({
  providedIn: 'root'
})
export class SupabaseService {
  private readonly platformId = inject(PLATFORM_ID);
  private readonly supabaseClient: SupabaseClient | null = null;

  constructor() {
    if (isPlatformBrowser(this.platformId) && this.isValidUrl(environment.supabaseUrl)) {
      this.supabaseClient = createClient(environment.supabaseUrl, environment.supabaseAnonKey, {
        auth: {
          persistSession: true,
          autoRefreshToken: true
        }
      });
    }
  }

  public isAvailable(): boolean {
    return this.supabaseClient !== null;
  }

  public async fetchAllTasks(): Promise<readonly LearningTask[]> {
    if (!this.supabaseClient) {
      return [];
    }
    const queryResult = await this.supabaseClient.from('tasks').select('*').order('stage', { ascending: true });
    if (queryResult.error || !queryResult.data) {
      return [];
    }
    return queryResult.data.map((rawRow) => this.mapRowToLearningTask(rawRow));
  }

  public async logTestExecution(taskId: string, submittedCode: string, report: ExecutionReport): Promise<void> {
    if (!this.supabaseClient) {
      return;
    }
    await this.supabaseClient.from('test_runs').insert({
      task_id: taskId,
      submitted_code: submittedCode,
      passed: report.allPassed,
      passed_count: report.passedCount,
      total_count: report.totalCount,
      execution_time_ms: report.totalExecutionTimeMs,
      failure_message: report.globalErrorMessage ?? report.testResults.find((r) => !r.passed)?.failureMessage ?? null
    });
  }

  public async recordTaskProgress(taskId: string, passed: boolean, hintTier: number): Promise<MasteryRepetitionItem | null> {
    if (!this.supabaseClient) return null;
    const rpcResponse = await this.supabaseClient.rpc('record_task_progress', {
      p_task_id: taskId,
      p_passed: passed,
      p_hint_tier: hintTier
    });
    return rpcResponse.data ? this.mapRpcToRepetitionItem(rpcResponse.data as Record<string, unknown>) : null;
  }

  public async insertCustomKata(payload: CustomKataPayload): Promise<string | null> {
    if (!this.supabaseClient) return null;
    const rpcResponse = await this.supabaseClient.rpc('create_custom_kata', {
      p_title: payload.title,
      p_stage: payload.stage,
      p_scenario_description: payload.scenarioDescription,
      p_function_name: payload.functionName,
      p_starter_code: payload.starterCode,
      p_solution_code: payload.solutionCode,
      p_test_cases: payload.testCases
    });
    return rpcResponse.data ? String((rpcResponse.data as Record<string, unknown>)['id']) : null;
  }

  private mapRpcToRepetitionItem(payload: Record<string, unknown>): MasteryRepetitionItem {
    return {
      taskId: String(payload['taskId']),
      repetitionCount: Number(payload['repetitionCount'] ?? 0),
      intervalDays: Number(payload['intervalDays'] ?? 1),
      easeFactor: Number(payload['easeFactor'] ?? 2.5),
      nextDueDate: String(payload['nextDueDate'] ?? new Date().toISOString()),
      isGraduated: Number(payload['repetitionCount'] ?? 0) >= 3
    };
  }

  private mapRowToLearningTask(rawRow: Record<string, unknown>): LearningTask {
    return {
      id: String(rawRow['id']),
      templateId: String(rawRow['id']),
      stage: Number(rawRow['stage']) as 1 | 2 | 3 | 4 | 5,
      title: String(rawRow['title']),
      scenarioDescription: String(rawRow['scenario_description']),
      functionName: String(rawRow['function_name']),
      parameters: (rawRow['parameters'] as readonly never[]) ?? [],
      starterCode: String(rawRow['starter_code']),
      solutionCode: String(rawRow['solution_code']),
      testCases: (rawRow['test_cases'] as readonly never[]) ?? []
    };
  }

  private isValidUrl(urlCandidate: string): boolean {
    return urlCandidate.trim().startsWith('http://') || urlCandidate.trim().startsWith('https://');
  }
}
