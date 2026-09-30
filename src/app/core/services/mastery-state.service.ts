import { computed, inject, Injectable, signal } from '@angular/core';
import { CustomKataPayload, ExecutionReport, MasteryOverview, MasteryRepetitionItem } from '../models';
import { SupabaseService } from './supabase.service';

@Injectable({
  providedIn: 'root'
})
export class MasteryStateService {
  private readonly supabaseService = inject(SupabaseService);

  private readonly completedTaskIdsSignal = signal<ReadonlySet<string>>(new Set<string>());
  private readonly repetitionQueueSignal = signal<readonly MasteryRepetitionItem[]>([]);
  private readonly isGraduationModalOpenSignal = signal<boolean>(false);
  private readonly isKataStudioOpenSignal = signal<boolean>(false);

  public readonly completedCount = computed<number>(() => this.completedTaskIdsSignal().size);
  public readonly isGraduationModalOpen = this.isGraduationModalOpenSignal.asReadonly();
  public readonly isKataStudioOpen = this.isKataStudioOpenSignal.asReadonly();

  public registerTestResult(taskId: string, report: ExecutionReport, totalTasksCount: number, hintTier: number): void {
    if (!report.allPassed) return;
    this.markTaskCompleted(taskId);
    this.checkCurriculumGraduation(totalTasksCount);
    this.syncProgressToSupabase(taskId, report.allPassed, hintTier);
  }

  public getMasteryOverview(totalTasksCount: number, currentStreak: number): MasteryOverview {
    const completed = this.completedTaskIdsSignal().size;
    const isCompleted = totalTasksCount > 0 && completed >= totalTasksCount;
    const percentage = totalTasksCount > 0 ? Math.round((completed / totalTasksCount) * 100) : 0;
    return { totalCompleted: completed, totalTasks: totalTasksCount, isCurriculumCompleted: isCompleted, masteryPercentage: percentage, currentStreak };
  }

  public openGraduationModal(): void {
    this.isGraduationModalOpenSignal.set(true);
  }

  public closeGraduationModal(): void {
    this.isGraduationModalOpenSignal.set(false);
  }

  public openKataStudio(): void {
    this.isKataStudioOpenSignal.set(true);
  }

  public closeKataStudio(): void {
    this.isKataStudioOpenSignal.set(false);
  }

  public async saveCustomKata(payload: CustomKataPayload): Promise<string | null> {
    const createdId = await this.supabaseService.insertCustomKata(payload);
    if (createdId) this.closeKataStudio();
    return createdId;
  }

  private markTaskCompleted(taskId: string): void {
    this.completedTaskIdsSignal.update((currentSet) => new Set([...currentSet, taskId]));
  }

  private checkCurriculumGraduation(totalTasksCount: number): void {
    if (totalTasksCount > 0 && this.completedTaskIdsSignal().size >= totalTasksCount) {
      this.isGraduationModalOpenSignal.set(true);
    }
  }

  private syncProgressToSupabase(taskId: string, passed: boolean, hintTier: number): void {
    this.supabaseService.recordTaskProgress(taskId, passed, hintTier).then((repetitionItem) => {
      if (repetitionItem) this.updateRepetitionQueue(repetitionItem);
    });
  }

  private updateRepetitionQueue(newItem: MasteryRepetitionItem): void {
    this.repetitionQueueSignal.update((prevQueue) => [
      ...prevQueue.filter((item) => item.taskId !== newItem.taskId),
      newItem
    ]);
  }
}
