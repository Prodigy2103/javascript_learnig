import { Component, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { MasteryStateService } from '../../core/services/mastery-state.service';
import { TaskCatalogService } from '../../core/services/task-catalog.service';
import { CustomKataPayload } from '../../core/models';

@Component({
  selector: 'app-kata-studio-modal',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './kata-studio-modal.component.html',
  styleUrl: './kata-studio-modal.component.scss'
})
export class KataStudioModalComponent {
  private readonly masteryStateService = inject(MasteryStateService);
  private readonly taskCatalogService = inject(TaskCatalogService);

  public readonly isVisible = this.masteryStateService.isKataStudioOpen;
  public readonly isSubmitting = signal<boolean>(false);
  public readonly errorMessage = signal<string | null>(null);

  public title = '';
  public stage: 1 | 2 | 3 | 4 | 5 = 1;
  public scenarioDescription = '';
  public functionName = '';
  public starterCode = 'function exampleFunction(argumentValue) {\n  // Code hier\n}';
  public solutionCode = 'function exampleFunction(argumentValue) {\n  return argumentValue;\n}';
  public testInputString = '10';
  public testExpectedString = '10';

  public closeModal(): void {
    this.masteryStateService.closeKataStudio();
    this.errorMessage.set(null);
  }

  public async submitCustomKata(): Promise<void> {
    if (!this.title.trim() || !this.functionName.trim()) {
      this.errorMessage.set('Bitte Titel und Funktionsnamen angeben.');
      return;
    }
    this.isSubmitting.set(true);
    this.errorMessage.set(null);
    const payload = this.buildPayload();
    const createdId = await this.masteryStateService.saveCustomKata(payload);

    if (createdId) {
      await this.taskCatalogService.syncWithSupabase();
      this.closeModal();
    } else {
      this.errorMessage.set('Fehler beim Speichern in Supabase. Bitte RLS/RPC prüfen.');
    }
    this.isSubmitting.set(false);
  }

  private buildPayload(): CustomKataPayload {
    const parsedInput = this.parseJsonSafe(this.testInputString);
    const parsedExpected = this.parseJsonSafe(this.testExpectedString);
    return {
      title: this.title.trim(),
      stage: Number(this.stage) as 1 | 2 | 3 | 4 | 5,
      scenarioDescription: this.scenarioDescription.trim(),
      functionName: this.functionName.trim(),
      starterCode: this.starterCode,
      solutionCode: this.solutionCode,
      testCases: [{
        id: 'tc-custom-1',
        description: `${this.functionName}(${this.testInputString}) ergibt ${this.testExpectedString}`,
        inputArguments: [parsedInput],
        expectedOutput: parsedExpected,
        isHidden: false
      }]
    };
  }

  private parseJsonSafe(valueCandidate: string): unknown {
    try {
      return JSON.parse(valueCandidate);
    } catch {
      return valueCandidate;
    }
  }
}
