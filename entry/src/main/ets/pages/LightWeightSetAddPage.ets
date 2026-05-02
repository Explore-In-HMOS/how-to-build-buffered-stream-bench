import { LightWeightSet } from '@kit.ArkTS';

@Component
export struct LightWeightSetAddPage {
  @Consume('pathStack') pathStack: NavPathStack;
  private set: LightWeightSet<string> = new LightWeightSet<string>();
  private nextSeed: number = 1;
  @State setText: string = 'empty';
  @State resultText: string = 'Ready';

  aboutToAppear(): void {
    this.resetSet();
  }

  private refreshSetText(): void {
    let text = '';
    try {
      text = `${this.set.toString()}`;
    } catch (err) {
      this.resultText = `Refresh failed: ${JSON.stringify(err)}`;
      this.setText = 'error';
      return;
    }
    this.setText = text.length === 0 ? 'empty' : text;
  }

  private addValue(): void {
    const value = `Item ${this.nextSeed}`;
    this.nextSeed += 1;
    let added: boolean;
    try {
      added = this.set.add(value);
    } catch (err) {
      this.resultText = `Add failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = added ? `Added ${value}` : `Duplicate ${value}`;
    this.refreshSetText();
  }

  private hasValue(): void {
    try {
      this.resultText = `Has Item 1: ${this.set.has('Item 1')}`;
    } catch (err) {
      this.resultText = `Has failed: ${JSON.stringify(err)}`;
    }
  }

  private deleteValue(): void {
    let removed: string | undefined;
    try {
      removed = this.set.remove('Item 1');
    } catch (err) {
      this.resultText = `Delete failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = removed !== undefined ? 'Deleted Item 1' : 'Item 1 not found';
    this.refreshSetText();
  }

  private resetSet(): void {
    this.set = new LightWeightSet<string>();
    this.nextSeed = 1;
    this.resultText = 'LightWeightSet reset';
    this.refreshSetText();
  }

  private backToHome(): void {
    this.pathStack.pop();
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 10 }) {
      Text('LightWeightSet Core')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F4F8FF')

      Button('Add · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#E9FFF5')
        .backgroundColor('#235A67')
        .borderRadius(18)
        .onClick(() => this.addValue())

      Button('Has · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#EEF5FF')
        .backgroundColor('#2A4B7C')
        .borderRadius(18)
        .onClick(() => this.hasValue())

      Button('Delete · O(n)')
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
