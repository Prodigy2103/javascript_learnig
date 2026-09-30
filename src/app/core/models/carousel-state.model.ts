import { HintTier } from './diagnostic.model';

export type TaskProgressStatus =
  | 'unseen'
  | 'in_progress'
  | 'failed'
  | 'solved_with_hints'
  | 'solved_clean';

export interface CarouselQueueItem {
  readonly queueItemId: string;
  readonly templateId: string;
  readonly variantSeed: number;
  readonly attemptCount: number;
  readonly maxRevealedHintTier: HintTier | 0;
  readonly status: TaskProgressStatus;
  readonly lastAttemptedAt: string | null;
  readonly completedAt: string | null;
}

export interface CarouselState {
  readonly activeQueue: readonly CarouselQueueItem[];
  readonly completedArchive: readonly CarouselQueueItem[];
  readonly currentActiveIndex: number;
  readonly streakCount: number;
  readonly totalSolvedCleanCount: number;
  readonly totalAttemptsCount: number;
}
