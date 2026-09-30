import { Component, computed, inject, signal } from '@angular/core';
import { EditorComponent } from './features/editor/editor.component';
import { GraduationModalComponent } from './features/graduation-modal/graduation-modal.component';
import { KataStudioModalComponent } from './features/kata-studio/kata-studio-modal.component';
import { TestRunnerService } from './core/services/test-runner.service';
import { TaskCatalogService } from './core/services/task-catalog.service';
import { SupabaseService } from './core/services/supabase.service';
import { MasteryStateService } from './core/services/mastery-state.service';
import { ExecutionReport, LearningTask } from './core/models';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    EditorComponent,
    GraduationModalComponent,
    KataStudioModalComponent
  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  private readonly testRunnerService = inject(TestRunnerService);
  private readonly taskCatalogService = inject(TaskCatalogService);
  private readonly supabaseService = inject(SupabaseService);
  public readonly masteryStateService = inject(MasteryStateService);

  public readonly applicationTitle = 'JavaScript Learning Lab';
  public readonly currentTaskIndex = signal<number>(0);
  public readonly streakCounter = signal<number>(0);
  public readonly activeHintTier = signal<number>(1);
  public readonly isExecuting = signal<boolean>(false);
  public readonly executionReport = signal<ExecutionReport | null>(null);

  public readonly totalTasksCount = computed<number>(() => this.taskCatalogService.getTotalCount());

  public readonly activeTask = computed<LearningTask>(() => {
    const task = this.taskCatalogService.getTaskByIndex(this.currentTaskIndex());
    return task ?? this.taskCatalogService.getAllTasks()[0];
  });

  public readonly currentStageName = computed<string>(() => {
    const stageMap: Record<number, string> = {
      1: 'Phase 1: Core Syntax, Typen & Execution Context',
      2: 'Phase 2: Asynchrones JavaScript & Die Engine-Mechanik',
      3: 'Phase 3: DOM, Web APIs & Browser-Performance',
      4: 'Phase 4: Fortgeschrittene APIs & Meta-Programming',
      5: 'Phase 5: Modularisierung, Tooling & Code-Qualität'
    };
    return stageMap[this.activeTask().stage] ?? 'Lernstufe';
  });

  public readonly userCode = signal<string>(this.taskCatalogService.getAllTasks()[0].starterCode);

  public setHintTier(selectedTier: number): void {
    if (selectedTier >= 1 && selectedTier <= 4) {
      this.activeHintTier.set(selectedTier);
    }
  }

  public resetCodeToStarter(): void {
    this.userCode.set(this.activeTask().starterCode);
    this.executionReport.set(null);
  }

  public async executeCodeTests(): Promise<void> {
    this.isExecuting.set(true);
    const currentCode = this.userCode();
    const task = this.activeTask();
    const freshReport = await this.testRunnerService.executeTestSuite(currentCode, task.testCases);

    this.executionReport.set(freshReport);
    this.isExecuting.set(false);
    this.handleStreakUpdate(freshReport.allPassed);
    this.supabaseService.logTestExecution(task.id, currentCode, freshReport);
    this.masteryStateService.registerTestResult(task.id, freshReport, this.totalTasksCount(), this.activeHintTier());
  }

  public openKataStudio(): void {
    this.masteryStateService.openKataStudio();
  }

  public navigateToNextTask(): void {
    const nextIndex = this.currentTaskIndex() + 1;
    if (nextIndex < this.totalTasksCount()) {
      this.switchTaskByIndex(nextIndex);
    }
  }

  public navigateToPreviousTask(): void {
    const previousIndex = this.currentTaskIndex() - 1;
    if (previousIndex >= 0) {
      this.switchTaskByIndex(previousIndex);
    }
  }

  private switchTaskByIndex(targetIndex: number): void {
    this.currentTaskIndex.set(targetIndex);
    this.userCode.set(this.activeTask().starterCode);
    this.executionReport.set(null);
    this.activeHintTier.set(1);
  }

  private handleStreakUpdate(testsPassed: boolean): void {
    if (testsPassed) {
      this.streakCounter.update((previousStreak) => previousStreak + 1);
    }
  }
}
