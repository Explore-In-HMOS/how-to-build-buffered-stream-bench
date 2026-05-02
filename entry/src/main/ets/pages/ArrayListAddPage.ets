import { ArrayList } from '@kit.ArkTS';

@Component
export struct ArrayListAddPage {
  @Consume('pathStack') pathStack: NavPathStack;
  private arrayList: ArrayList<string> = new ArrayList<string>();
  private nextSeed: number = 1;
  @State listText: string = 'empty';
  @State resultText: string = 'Ready';

  aboutToAppear(): void {
    this.resetList();
  }

  private refreshListText(): void {
    let joined = '';
    try {
      this.arrayList.forEach((value: string) => {
        joined = joined.length === 0 ? value : `${joined}, ${value}`;
      });
    } catch (err) {
      this.resultText = `Refresh failed: ${JSON.stringify(err)}`;
      this.listText = 'error';
      return;
    }
    this.listText = joined.length === 0 ? 'empty' : joined;
  }

  private addItem(): void {
    const value = `Item ${this.nextSeed}`;
    this.nextSeed += 1;
    try {
      this.arrayList.add(value);
    } catch (err) {
      this.resultText = `Add failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = `Added ${value}`;
    this.refreshListText();
  }

  private getSecond(): void {
    if (this.arrayList.length < 2) {
      this.resultText = 'Need 2+ items';
      return;
    }
    this.resultText = `Get[1]: ${this.arrayList[1]}`;
  }

  private updateSecond(): void {
    if (this.arrayList.length < 2) {
      this.resultText = 'Need 2+ items';
      return;
    }
    this.arrayList[1] = 'Updated';
    this.resultText = 'Set[1] = Updated';
    this.refreshListText();
  }

  private removeLast(): void {
    if (this.arrayList.length === 0) {
      this.resultText = 'Nothing to remove';
      return;
    }
    let removed: string;
    try {
      removed = this.arrayList.removeByIndex(this.arrayList.length - 1);
    } catch (err) {
      this.resultText = `Delete failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = `Removed ${removed}`;
    this.refreshListText();
  }

  private resetList(): void {
    this.arrayList = new ArrayList<string>();
    this.nextSeed = 1;
    this.resultText = 'ArrayList reset';
    this.refreshListText();
  }

  private backToHome(): void {
    this.pathStack.pop();
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 10 }) {
      Text('ArrayList Core')
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

      Button('Get · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#E9FFF5')
        .backgroundColor('#235A67')
        .borderRadius(18)
        .onClick(() => this.getSecond())

      Button('Update · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#EEF5FF')
        .backgroundColor('#4A3E73')
        .borderRadius(18)
        .onClick(() => this.updateSecond())

      Button('Delete · O(n)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#FDEDF0')
        .backgroundColor('#6A2C35')
        .borderRadius(18)
        .onClick(() => this.removeLast())

      Button('Reset · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#FDEDF0')
        .backgroundColor('#5A2A34')
        .borderRadius(18)
        .onClick(() => this.resetList())

      Column({ space: 4 }) {
        Text(`ArrayList: ${this.listText}`)
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
