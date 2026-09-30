export type DidacticStage = 1 | 2 | 3 | 4 | 5;

export interface TaskParameterSpecification {
  readonly parameterName: string;
  readonly typeDescription: string;
  readonly description: string;
}

export interface TaskTestCase {
  readonly id: string;
  readonly description: string;
  readonly inputArguments: readonly unknown[];
  readonly expectedOutput: unknown;
  readonly isHidden: boolean;
}

export interface TaskVariantParameters {
  readonly functionName: string;
  readonly scenarioDescription: string;
  readonly exampleInputs: readonly unknown[];
  readonly dynamicValues: Readonly<Record<string, unknown>>;
}

export interface TaskTemplate {
  readonly templateId: string;
  readonly stage: DidacticStage;
  readonly title: string;
  readonly category: string;
  readonly descriptionMarkdown: string;
  readonly parameters: readonly TaskParameterSpecification[];
  readonly starterCodeTemplate: string;
  readonly solutionCodeTemplate: string;
  readonly generateVariant: (variantSeed: number) => TaskVariantParameters;
}

export interface LearningTask {
  readonly id: string;
  readonly templateId: string;
  readonly stage: DidacticStage;
  readonly title: string;
  readonly scenarioDescription: string;
  readonly functionName: string;
  readonly parameters: readonly TaskParameterSpecification[];
  readonly starterCode: string;
  readonly solutionCode: string;
  readonly testCases: readonly TaskTestCase[];
}
