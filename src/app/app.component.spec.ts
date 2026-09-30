import { TestBed } from '@angular/core/testing';
import { AppComponent } from './app.component';

describe('AppComponent', () => {
  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AppComponent]
    }).compileComponents();
  });

  it('should create the learning app component', () => {
    const componentFixture = TestBed.createComponent(AppComponent);
    const componentInstance = componentFixture.componentInstance;
    expect(componentInstance).toBeTruthy();
  });

  it('should navigate to next task and update active task title', () => {
    const componentFixture = TestBed.createComponent(AppComponent);
    const componentInstance = componentFixture.componentInstance;

    expect(componentInstance.currentTaskIndex()).toBe(0);
    componentInstance.navigateToNextTask();

    expect(componentInstance.currentTaskIndex()).toBe(1);
    expect(componentInstance.activeTask().title).toContain('Template Literals');
  });

  it('should execute tests and produce an execution report', async () => {
    const componentFixture = TestBed.createComponent(AppComponent);
    const componentInstance = componentFixture.componentInstance;
    await componentInstance.executeCodeTests();
    expect(componentInstance.executionReport()).not.toBeNull();
  });
});
