import { Stack } from '@kit.ArkTS';

@Component
export struct StackPage {
  @Consume('pathStack') pathStack: NavPathStack;
  private stack: Stack<string> = new Stack<string>();
  private nextSeed: number = 1;
  @State stackText: string = 'empty';
  @State resultText: string = 'Ready';

  aboutToAppear(): void {
    this.resetStack();
  }

  private refreshStackText(): void {
    let joined = '';
    try {
      this.stack.forEach((value: string) => {
        joined = joined.length === 0 ? value : `${joined}, ${value}`;
      });
    } catch (err) {
      this.resultText = `Refresh failed: ${JSON.stringify(err)}`;
      this.stackText = 'error';
      return;
    }
    this.stackText = joined.length === 0 ? 'empty' : joined;
  }

  private pushItem(): void {
    const value = `Item ${this.nextSeed}`;
    this.nextSeed += 1;
    try {
      this.stack.push(value);
    } catch (err) {
      this.resultText = `Push failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = `Pushed ${value}`;
    this.refreshStackText();
  }

  private peekItem(): void {
    if (this.stack.length === 0) {
      this.resultText = 'Stack is empty';
      return;
    }
    try {
      this.resultText = `Top: ${this.stack.peek()}`;
    } catch (err) {
      this.resultText = `Peek failed: ${JSON.stringify(err)}`;
    }
  }

  private popItem(): void {
    if (this.stack.length === 0) {
      this.resultText = 'Nothing to pop';
      return;
    }
    let removed: string;
    try {
      removed = this.stack.pop();
    } catch (err) {
      this.resultText = `Pop failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = `Popped ${removed}`;
    this.refreshStackText();
  }

  private checkEmpty(): void {
    try {
      this.resultText = `isEmpty: ${this.stack.isEmpty()}`;
    } catch (err) {
      this.resultText = `Check failed: ${JSON.stringify(err)}`;
    }
  }

  private resetStack(): void {
    this.stack = new Stack<string>();
    this.nextSeed = 1;
    this.resultText = 'Stack reset';
    this.refreshStackText();
  }

  private backToHome(): void {
    this.pathStack.pop();
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 10 }) {
      Text('Stack Core')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F4F8FF')

      Button('Push · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#EEF5FF')
        .backgroundColor('#2A4B7C')
        .borderRadius(17)
        .onClick(() => this.pushItem())

      Button('Peek · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#E9FFF5')
        .backgroundColor('#235A67')
        .borderRadius(18)
        .onClick(() => this.peekItem())

      Button('Pop · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#FDEDF0')
        .backgroundColor('#6A2C35')
        .borderRadius(18)
        .onClick(() => this.popItem())

      Button('isEmpty · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#EEF5FF')
        .backgroundColor('#4A3E73')
        .borderRadius(18)
        .onClick(() => this.checkEmpty())

      Button('Reset · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#FDEDF0')
        .backgroundColor('#5A2A34')
        .borderRadius(18)
        .onClick(() => this.resetStack())

      Column({ space: 4 }) {
        Text(`Stack: ${this.stackText}`)
          .fontSize(9)
          .fontColor('#A9BDDA')
          .width('100%')
        Text(`Result: ${this.resultText}`)
          .fontSize(9)
          .fontColor('#A9BDDA')
          .width('100%')
      }
      .width('100%')
      .padding(10)
      .backgroundColor('#18293F')
      .borderRadius(10)

      Button('Back')
        .width('100%')
        .height(34)
        .fontSize(10)
        .fontColor('#FFF1F1')
        .backgroundColor('#6A2C35')
        .borderRadius(17)
        .onClick(() => this.backToHome())

        }
        .padding({ left: 16, right: 16, top: 20, bottom: 20 })
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0B111B')
  }
}
