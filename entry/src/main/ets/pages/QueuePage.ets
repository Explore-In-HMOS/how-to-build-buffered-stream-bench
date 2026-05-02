import { Queue } from '@kit.ArkTS';

@Component
export struct QueuePage {
  @Consume('pathStack') pathStack: NavPathStack;
  private queue: Queue<string> = new Queue<string>();
  private nextSeed: number = 1;
  @State queueText: string = 'empty';
  @State resultText: string = 'Ready';

  aboutToAppear(): void {
    this.resetQueue();
  }

  private refreshQueueText(): void {
    let joined = '';
    try {
      this.queue.forEach((value: string) => {
        joined = joined.length === 0 ? value : `${joined}, ${value}`;
      });
    } catch (err) {
      this.resultText = `Refresh failed: ${JSON.stringify(err)}`;
      this.queueText = 'error';
      return;
    }
    this.queueText = joined.length === 0 ? 'empty' : joined;
  }

  private addItem(): void {
    const value = `Item ${this.nextSeed}`;
    this.nextSeed += 1;
    try {
      this.queue.add(value);
    } catch (err) {
      this.resultText = `Add failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = `Added ${value}`;
    this.refreshQueueText();
  }

  private peekItem(): void {
    if (this.queue.length === 0) {
      this.resultText = 'Queue is empty';
      return;
    }
    try {
      this.resultText = `Front: ${this.queue.getFirst()}`;
    } catch (err) {
      this.resultText = `Peek failed: ${JSON.stringify(err)}`;
    }
  }

  private removeItem(): void {
    if (this.queue.length === 0) {
      this.resultText = 'Nothing to remove';
      return;
    }
    let removed: string;
    try {
      removed = this.queue.pop();
    } catch (err) {
      this.resultText = `Delete failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = `Removed ${removed}`;
    this.refreshQueueText();
  }

  private checkEmpty(): void {
    this.resultText = `isEmpty: ${this.queue.length === 0}`;
  }

  private resetQueue(): void {
    this.queue = new Queue<string>();
    this.nextSeed = 1;
    this.resultText = 'Queue reset';
    this.refreshQueueText();
  }

  private backToHome(): void {
    this.pathStack.pop();
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 10 }) {
          Text('Queue Core')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#F4F8FF')

          Button('Add · O(1)')
            .width('100%')
            .height(32)
            .fontSize(10)
            .fontColor('#EEF5FF')
            .backgroundColor('#2A4B7C')
            .borderRadius(18)
            .onClick(() => this.addItem())

          Button('Peek · O(1)')
            .width('100%')
            .height(32)
            .fontSize(10)
            .fontColor('#E9FFF5')
            .backgroundColor('#235A67')
            .borderRadius(18)
            .onClick(() => this.peekItem())

          Button('Delete · O(1)')
            .width('100%')
            .height(32)
            .fontSize(10)
            .fontColor('#FDEDF0')
            .backgroundColor('#6A2C35')
            .borderRadius(18)
            .onClick(() => this.removeItem())

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
            .onClick(() => this.resetQueue())

          Column({ space: 4 }) {
            Text(`Queue: ${this.queueText}`)
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
