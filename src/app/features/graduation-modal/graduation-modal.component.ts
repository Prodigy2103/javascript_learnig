import { Component, inject } from '@angular/core';
import { MasteryStateService } from '../../core/services/mastery-state.service';
import { TaskCatalogService } from '../../core/services/task-catalog.service';

@Component({
  selector: 'app-graduation-modal',
  standalone: true,
  templateUrl: './graduation-modal.component.html',
  styleUrl: './graduation-modal.component.scss'
})
export class GraduationModalComponent {
  private readonly masteryStateService = inject(MasteryStateService);
  private readonly taskCatalogService = inject(TaskCatalogService);

  public readonly totalTasksCount = this.taskCatalogService.getTotalCount();
  public readonly isVisible = this.masteryStateService.isGraduationModalOpen;

  public closeModal(): void {
    this.masteryStateService.closeGraduationModal();
  }

  public openKataStudio(): void {
    this.masteryStateService.closeGraduationModal();
    this.masteryStateService.openKataStudio();
  }
}
