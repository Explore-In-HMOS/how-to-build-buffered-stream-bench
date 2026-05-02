import { LightWeightMap } from '@kit.ArkTS';

@Component
export struct LightWeightMapSetPage {
  @Consume('pathStack') pathStack: NavPathStack;
  private map: LightWeightMap<number, string> = new LightWeightMap<number, string>();
  private nextKey: number = 1;
  @State mapText: string = 'empty';
  @State resultText: string = 'Ready';

  aboutToAppear(): void {
    this.resetMap();
  }

  private refreshMapText(): void {
    let joined = '';
    try {
      this.map.forEach((value: string, key?: number) => {
        const keyText = key === undefined ? '-' : `${key}`;
        joined = joined.length === 0 ? `${keyText}:${value}` : `${joined}, ${keyText}:${value}`;
      });
    } catch (err) {
      this.resultText = `Refresh failed: ${JSON.stringify(err)}`;
      this.mapText = 'error';
      return;
    }
    this.mapText = joined.length === 0 ? 'empty' : joined;
  }

  private setValue(): void {
    const key = this.nextKey;
    try {
      this.map.set(key, `Value ${key}`);
    } catch (err) {
      this.resultText = `Set failed: ${JSON.stringify(err)}`;
      return;
    }
    this.nextKey += 1;
    this.resultText = `Set ${key}:Value ${key}`;
    this.refreshMapText();
  }

  private getValue(): void {
    try {
      this.resultText = `Get 1: ${this.map.get(1)}`;
    } catch (err) {
      this.resultText = `Get failed: ${JSON.stringify(err)}`;
    }
  }

  private hasKey(): void {
    try {
      this.resultText = `Has 1: ${this.map.hasKey(1)}`;
    } catch (err) {
      this.resultText = `Has failed: ${JSON.stringify(err)}`;
    }
  }

  private deleteKey(): void {
    try {
      if (!this.map.hasKey(1)) {
        this.resultText = 'Key 1 not found';
        return;
      }
    } catch (err) {
      this.resultText = `Has failed: ${JSON.stringify(err)}`;
      return;
    }
    let removed: string | undefined;
    try {
      removed = this.map.remove(1);
    } catch (err) {
      this.resultText = `Delete failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = `Deleted 1:${removed}`;
    this.refreshMapText();
  }

  private resetMap(): void {
    this.map = new LightWeightMap<number, string>();
    this.nextKey = 1;
    this.resultText = 'LightWeightMap reset';
    this.refreshMapText();
  }

  private backToHome(): void {
    this.pathStack.pop();
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 10 }) {
      Text('LightWeightMap Core')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F4F8FF')

      Button('Set · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#F3F5FF')
        .backgroundColor('#4A3E73')
        .borderRadius(18)
        .onClick(() => this.setValue())

      Button('Get · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#E9FFF5')
        .backgroundColor('#235A67')
        .borderRadius(18)
        .onClick(() => this.getValue())

      Button('Has · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#EEF5FF')
        .backgroundColor('#2A4B7C')
        .borderRadius(18)
        .onClick(() => this.hasKey())

      Button('Delete · O(1)')
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
        .onClick(() => this.resetMap())

      Column({ space: 4 }) {
        Text(`Map: ${this.mapText}`)
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
