import { TreeSet } from '@kit.ArkTS';

@Component
export struct TreeSetAddPage {
  @Consume('pathStack') pathStack: NavPathStack;
  private treeSet: TreeSet<string> = new TreeSet<string>();
  private nextSeed: number = 1;
  @State setText: string = 'empty';
  @State resultText: string = 'Ready';

  aboutToAppear(): void {
    this.resetSet();
  }

  private refreshSetText(): void {
    let joined = '';
    try {
      this.treeSet.forEach((value: string) => {
        joined = joined.length === 0 ? value : `${joined}, ${value}`;
      });
    } catch (err) {
      this.resultText = `Refresh failed: ${JSON.stringify(err)}`;
      this.setText = 'error';
      return;
    }
    this.setText = joined.length === 0 ? 'empty' : joined;
  }

  private addValue(): void {
    const value = `Item ${this.nextSeed}`;
    this.nextSeed += 1;
    let added: boolean;
    try {
      added = this.treeSet.add(value);
    } catch (err) {
      this.resultText = `Add failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = added ? `Added ${value}` : `Duplicate ${value}`;
    this.refreshSetText();
  }

  private hasValue(): void {
    try {
      this.resultText = `Has Item 1: ${this.treeSet.has('Item 1')}`;
    } catch (err) {
      this.resultText = `Has failed: ${JSON.stringify(err)}`;
    }
  }

  private deleteValue(): void {
    let deleted: boolean;
    try {
      deleted = this.treeSet.remove('Item 1');
    } catch (err) {
      this.resultText = `Delete failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = deleted ? 'Deleted Item 1' : 'Item 1 not found';
    this.refreshSetText();
  }

  private resetSet(): void {
    this.treeSet = new TreeSet<string>();
    this.nextSeed = 1;
    this.resultText = 'TreeSet reset';
    this.refreshSetText();
  }

  private backToHome(): void {
    this.pathStack.pop();
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 10 }) {
      Text('TreeSet Core')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F4F8FF')

      Button('Add · O(log n)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#FFF9EA')
        .backgroundColor('#6A4E1E')
        .borderRadius(18)
        .onClick(() => this.addValue())

      Button('Has · O(log n)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#EAF3FF')
        .backgroundColor('#2A4B7C')
        .borderRadius(18)
        .onClick(() => this.hasValue())

      Button('Delete · O(log n)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#FDEDF0')
        .backgroundColor('#6A2C35')
        .borderRadius(18)
        .onClick(() => this.deleteValue())

      Button('Reset · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#FDEDF0')
        .backgroundColor('#5A2A34')
        .borderRadius(18)
        .onClick(() => this.resetSet())

      Column({ space: 4 }) {
        Text(`Set: ${this.setText}`)
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
