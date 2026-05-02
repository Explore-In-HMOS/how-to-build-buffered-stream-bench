import { PlainArray } from '@kit.ArkTS';

@Component
export struct PlainArraySetValueAtPage {
  @Consume('pathStack') pathStack: NavPathStack;
  private plainArray: PlainArray<string> = new PlainArray<string>();
  @State arrayText: string = 'empty';
  @State resultText: string = 'Ready';

  aboutToAppear(): void {
    this.resetArray();
  }

  private refreshArrayText(): void {
    let joined = '';
    try {
      this.plainArray.forEach((value: string, index?: number) => {
        const idx = index === undefined ? '-' : `${index}`;
        joined = joined.length === 0 ? `${idx}:${value}` : `${joined}, ${idx}:${value}`;
      });
    } catch (err) {
      this.resultText = `Refresh failed: ${JSON.stringify(err)}`;
      this.arrayText = 'error';
      return;
    }
    this.arrayText = joined.length === 0 ? 'empty' : joined;
  }

  private setValueAt(): void {
    try {
      this.plainArray.setValueAt(0, 'Updated');
    } catch (err) {
      this.resultText = `Set failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = 'Set index 0 = Updated';
    this.refreshArrayText();
  }

  private getValue(): void {
    try {
      this.resultText = `Get key 1: ${this.plainArray.get(1)}`;
    } catch (err) {
      this.resultText = `Get failed: ${JSON.stringify(err)}`;
    }
  }

  private deleteKey(): void {
    try {
      if (!this.plainArray.has(1)) {
        this.resultText = 'Key 1 not found';
        return;
      }
    } catch (err) {
      this.resultText = `Has failed: ${JSON.stringify(err)}`;
      return;
    }
    let removed: string | undefined;
    try {
      removed = this.plainArray.remove(1);
    } catch (err) {
      this.resultText = `Delete failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = `Deleted key 1: ${removed}`;
    this.refreshArrayText();
  }

  private resetArray(): void {
    this.plainArray = new PlainArray<string>();
    try {
      this.plainArray.add(1, 'Alpha');
      this.plainArray.add(2, 'Beta');
    } catch (err) {
      this.resultText = `Reset failed: ${JSON.stringify(err)}`;
      this.arrayText = 'error';
      return;
    }
    this.resultText = 'PlainArray reset';
    this.refreshArrayText();
  }

  private backToHome(): void {
    this.pathStack.pop();
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 10 }) {
      Text('PlainArray Core')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F4F8FF')

      Button('Set · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#E9FFF5')
        .backgroundColor('#235A67')
        .borderRadius(18)
        .onClick(() => this.setValueAt())

      Button('Get · O(log n)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#EEF5FF')
        .backgroundColor('#2A4B7C')
        .borderRadius(18)
        .onClick(() => this.getValue())

      Button('Delete · O(n)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#FDEDF0')
        .backgroundColor('#6A2C35')
        .borderRadius(18)
        .onClick(() => this.deleteKey())

      Button('Reset · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#FDEDF0')
        .backgroundColor('#5A2A34')
        .borderRadius(18)
        .onClick(() => this.resetArray())

      Column({ space: 4 }) {
        Text(`Array: ${this.arrayText}`)
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
