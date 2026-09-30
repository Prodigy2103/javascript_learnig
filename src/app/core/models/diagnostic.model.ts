export type HintTier = 1 | 2 | 3 | 4;

export type DiagnosticSeverity = 'info' | 'warning' | 'error';

export type DiagnosticCategory =
  | 'return_vs_console_log'
  | 'missing_parameters'
  | 'unused_parameters'
  | 'missing_guard_clause'
  | 'mutation_detected'
  | 'missing_return_statement'
  | 'infinite_loop_hazard'
  | 'syntax_violation';

export interface DiagnosticFinding {
  readonly id: string;
  readonly category: DiagnosticCategory;
  readonly severity: DiagnosticSeverity;
  readonly title: string;
  readonly message: string;
  readonly lineReference?: number;
  readonly suggestedFixDescription: string;
}

export interface DidacticHintItem {
  readonly tier: HintTier;
  readonly tierName: string;
  readonly headline: string;
  readonly explanationMarkdown: string;
  readonly codeSnippetTemplate?: string;
  readonly unlocked: boolean;
}

export interface TaskHintCollection {
  readonly taskId: string;
  readonly tierOneDiagnosis: DidacticHintItem;
  readonly tierTwoConceptTip: DidacticHintItem;
  readonly tierThreeClozeTemplate: DidacticHintItem;
  readonly tierFourFullSolution: DidacticHintItem;
}
