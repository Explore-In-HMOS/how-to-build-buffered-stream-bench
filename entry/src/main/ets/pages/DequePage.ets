import { Deque } from '@kit.ArkTS';

@Component
export struct DequePage {
  @Consume('pathStack') pathStack: NavPathStack;
  private deque: Deque<string> = new Deque<string>();
  private nextSeed: number = 1;
  @State dequeText: string = 'empty';
  @State resultText: string = 'Ready';

  aboutToAppear(): void {
    this.resetDeque();
  }

  private refreshDequeText(): void {
    let joined = '';
    try {
      this.deque.forEach((value: string) => {
        joined = joined.length === 0 ? value : `${joined}, ${value}`;
      });
    } catch (err) {
      this.resultText = `Refresh failed: ${JSON.stringify(err)}`;
      this.dequeText = 'error';
      return;
    }
    this.dequeText = joined.length === 0 ? 'empty' : joined;
  }

  private addFront(): void {
    const value = `F${this.nextSeed}`;
    this.nextSeed += 1;
    try {
      this.deque.insertFront(value);
    } catch (err) {
      this.resultText = `Add front failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = `Added front ${value}`;
    this.refreshDequeText();
  }

  private addEnd(): void {
    const value = `E${this.nextSeed}`;
    this.nextSeed += 1;
    try {
      this.deque.insertEnd(value);
    } catch (err) {
      this.resultText = `Add end failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = `Added end ${value}`;
    this.refreshDequeText();
  }

  private peekEnds(): void {
    if (this.deque.length === 0) {
      this.resultText = 'Deque is empty';
      return;
    }
    try {
      this.resultText = `Front ${this.deque.getFirst()} · Back ${this.deque.getLast()}`;
    } catch (err) {
      this.resultText = `Inspect failed: ${JSON.stringify(err)}`;
    }
  }

  private popFront(): void {
    if (this.deque.length === 0) {
      this.resultText = 'Nothing to pop';
      return;
    }
    let removed: string;
    try {
      removed = this.deque.popFirst();
    } catch (err) {
      this.resultText = `Pop front failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = `Popped front ${removed}`;
    this.refreshDequeText();
  }

  private popBack(): void {
    if (this.deque.length === 0) {
      this.resultText = 'Nothing to pop';
      return;
    }
    let removed: string;
    try {
      removed = this.deque.popLast();
    } catch (err) {
      this.resultText = `Pop back failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = `Popped back ${removed}`;
    this.refreshDequeText();
  }

  private resetDeque(): void {
    this.deque = new Deque<string>();
    this.nextSeed = 1;
    this.resultText = 'Deque reset';
    this.refreshDequeText();
  }

  private backToHome(): void {
    this.pathStack.pop();
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 10 }) {
      Text('Deque Core')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F4F8FF')

      Button('Add Front · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#EEF5FF')
        .backgroundColor('#2A4B7C')
        .borderRadius(17)
        .onClick(() => this.addFront())

      Button('Add End · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#EAF3FF')
        .backgroundColor('#4A3E73')
        .borderRadius(17)
        .onClick(() => this.addEnd())

      Button('Front/Back · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#E9FFF5')
        .backgroundColor('#235A67')
        .borderRadius(18)
        .onClick(() => this.peekEnds())

      Button('Pop Front · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#FDEDF0')
        .backgroundColor('#6A2C35')
        .borderRadius(17)
        .onClick(() => this.popFront())

      Button('Pop Back · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#FFF9EA')
        .backgroundColor('#6A4E1E')
        .borderRadius(17)
        .onClick(() => this.popBack())

      Button('Reset · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#FDEDF0')
        .backgroundColor('#5A2A34')
        .borderRadius(17)
        .onClick(() => this.resetDeque())

      Column({ space: 4 }) {
        Text(`Deque: ${this.dequeText}`)
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
