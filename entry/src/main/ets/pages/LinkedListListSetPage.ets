import { LinkedList, List } from '@kit.ArkTS';

@Component
export struct LinkedListListSetPage {
  @Consume('pathStack') pathStack: NavPathStack;
  private linkedList: LinkedList<string> = new LinkedList<string>();
  private list: List<string> = new List<string>();
  private nextSeed: number = 1;
  @State linkedText: string = 'empty';
  @State listText: string = 'empty';
  @State resultText: string = 'Ready';

  aboutToAppear(): void {
    this.resetBoth();
  }

  private joinLinked(): string {
    let joined = '';
    try {
      this.linkedList.forEach((value: string) => {
        joined = joined.length === 0 ? value : `${joined}, ${value}`;
      });
    } catch (err) {
      this.resultText = `Linked refresh failed: ${JSON.stringify(err)}`;
      return 'error';
    }
    return joined.length === 0 ? 'empty' : joined;
  }

  private joinList(): string {
    let joined = '';
    try {
      this.list.forEach((value: string) => {
        joined = joined.length === 0 ? value : `${joined}, ${value}`;
      });
    } catch (err) {
      this.resultText = `List refresh failed: ${JSON.stringify(err)}`;
      return 'error';
    }
    return joined.length === 0 ? 'empty' : joined;
  }

  private refreshText(): void {
    this.linkedText = this.joinLinked();
    this.listText = this.joinList();
  }

  private addToBoth(): void {
    const value = `N${this.nextSeed}`;
    this.nextSeed += 1;
    try {
      this.linkedList.add(value);
      this.list.add(value);
    } catch (err) {
      this.resultText = `Add failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = `Added ${value} to both`;
    this.refreshText();
  }

  private setMiddle(): void {
    if (this.linkedList.length < 2 || this.list.length < 2) {
      this.resultText = 'Need 2+ items';
      return;
    }
    try {
      this.linkedList.set(1, 'L-Updated');
      this.list.set(1, 'S-Updated');
    } catch (err) {
      this.resultText = `Update failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = 'Set index 1 in both';
    this.refreshText();
  }

  private peekMiddle(): void {
    if (this.linkedList.length < 2 || this.list.length < 2) {
      this.resultText = 'Need 2+ items';
      return;
    }
    try {
      this.resultText = `Linked ${this.linkedList.get(1)} · List ${this.list.get(1)}`;
    } catch (err) {
      this.resultText = `Peek failed: ${JSON.stringify(err)}`;
    }
  }

  private deleteMiddle(): void {
    if (this.linkedList.length < 2 || this.list.length < 2) {
      this.resultText = 'Need 2+ items';
      return;
    }
    let linkedRemoved: string;
    let listRemoved: string;
    try {
      linkedRemoved = this.linkedList.removeByIndex(1);
      listRemoved = this.list.removeByIndex(1);
    } catch (err) {
      this.resultText = `Delete failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = `Deleted ${linkedRemoved}/${listRemoved}`;
    this.refreshText();
  }

  private resetBoth(): void {
    this.linkedList = new LinkedList<string>();
    this.list = new List<string>();
    this.nextSeed = 1;
    this.resultText = 'Both lists reset';
    this.refreshText();
  }

  private backToHome(): void {
    this.pathStack.pop();
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 10 }) {
      Text('LinkedList + List')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F4F8FF')

      Button('Add · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#EEF5FF')
        .backgroundColor('#2A4B7C')
        .borderRadius(17)
        .onClick(() => this.addToBoth())

      Button('Update(set) · O(n)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#E9FFF5')
        .backgroundColor('#235A67')
        .borderRadius(17)
        .onClick(() => this.setMiddle())

      Button('Peek(get) · O(n)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#EEF5FF')
        .backgroundColor('#4A3E73')
        .borderRadius(17)
        .onClick(() => this.peekMiddle())

      Button('Delete · O(n)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#FDEDF0')
        .backgroundColor('#6A2C35')
        .borderRadius(17)
        .onClick(() => this.deleteMiddle())

      Button('Reset · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#FDEDF0')
        .backgroundColor('#5A2A34')
        .borderRadius(17)
        .onClick(() => this.resetBoth())

      Column({ space: 4 }) {
        Text(`LinkedList: ${this.linkedText}`)
          .fontSize(9)
          .fontColor('#A9BDDA')
          .width('100%')
        Text(`List: ${this.listText}`)
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
