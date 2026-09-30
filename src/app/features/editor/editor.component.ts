import { Component, computed, ElementRef, model, viewChild } from '@angular/core';

@Component({
  selector: 'app-editor',
  standalone: true,
  templateUrl: './editor.component.html',
  styleUrl: './editor.component.scss'
})
export class EditorComponent {
  public readonly codeContent = model<string>('');
  public readonly textareaReference = viewChild<ElementRef<HTMLTextAreaElement>>('codeTextarea');
  public readonly gutterReference = viewChild<ElementRef<HTMLDivElement>>('lineGutter');

  public readonly lineNumbers = computed<readonly number[]>(() => {
    const rawCode = this.codeContent();
    const lineCount = rawCode.split('\n').length;
    return Array.from({ length: Math.max(lineCount, 1) }, (_, index) => index + 1);
  });

  public handleCodeInput(eventTarget: EventTarget | null): void {
    const targetElement = eventTarget as HTMLTextAreaElement | null;
    if (targetElement) {
      this.codeContent.set(targetElement.value);
    }
  }

  public handleTextareaScroll(): void {
    const textareaElement = this.textareaReference()?.nativeElement;
    const gutterElement = this.gutterReference()?.nativeElement;
    if (textareaElement && gutterElement) {
      gutterElement.scrollTop = textareaElement.scrollTop;
    }
  }

  public handleKeydown(keyboardEvent: KeyboardEvent): void {
    if (keyboardEvent.key === 'Tab') {
      keyboardEvent.preventDefault();
      this.insertTabSpaces();
    }
  }

  private insertTabSpaces(): void {
    const textareaElement = this.textareaReference()?.nativeElement;
    if (!textareaElement) {
      return;
    }
    const selectionStart = textareaElement.selectionStart;
    const selectionEnd = textareaElement.selectionEnd;
    const currentCode = this.codeContent();
    const updatedCode = `${currentCode.substring(0, selectionStart)}  ${currentCode.substring(selectionEnd)}`;

    this.codeContent.set(updatedCode);
    setTimeout(() => {
      textareaElement.selectionStart = selectionStart + 2;
      textareaElement.selectionEnd = selectionStart + 2;
    }, 0);
  }
}
