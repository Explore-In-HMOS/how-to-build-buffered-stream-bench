import { TreeMap } from '@kit.ArkTS';

@Component
export struct TreeMapSetPage {
  @Consume('pathStack') pathStack: NavPathStack;
  private map: TreeMap<string, string> = new TreeMap<string, string>();
  private nextSeed: number = 1;
  @State mapText: string = 'empty';
  @State resultText: string = 'Ready';

  aboutToAppear(): void {
    this.resetMap();
  }

  private refreshMapText(): void {
    let joined = '';
    try {
      this.map.forEach((value: string, key?: string) => {
        const keyText = key === undefined ? '-' : key;
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
    const key = `K${this.nextSeed}`;
    try {
      this.map.set(key, `Value ${this.nextSeed}`);
    } catch (err) {
      this.resultText = `Set failed: ${JSON.stringify(err)}`;
      return;
    }
    this.nextSeed += 1;
    this.resultText = `Set ${key}`;
    this.refreshMapText();
  }

  private getValue(): void {
    try {
      this.resultText = `Get K1: ${this.map.get('K1')}`;
    } catch (err) {
      this.resultText = `Get failed: ${JSON.stringify(err)}`;
    }
  }

  private hasKey(): void {
    try {
      this.resultText = `Has K1: ${this.map.hasKey('K1')}`;
    } catch (err) {
      this.resultText = `Has failed: ${JSON.stringify(err)}`;
    }
  }

  private deleteKey(): void {
    try {
      if (!this.map.hasKey('K1')) {
        this.resultText = 'K1 not found';
        return;
      }
    } catch (err) {
      this.resultText = `Has failed: ${JSON.stringify(err)}`;
      return;
    }
    let removed: string | undefined;
    try {
      removed = this.map.remove('K1');
    } catch (err) {
      this.resultText = `Delete failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = `Deleted K1:${removed}`;
    this.refreshMapText();
  }

  private resetMap(): void {
    this.map = new TreeMap<string, string>();
    this.nextSeed = 1;
    this.resultText = 'TreeMap reset';
    this.refreshMapText();
  }

  private backToHome(): void {
    this.pathStack.pop();
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 10 }) {
      Text('TreeMap Core')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F4F8FF')

      Button('Set · O(log n)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#FFF9EA')
        .backgroundColor('#6A4E1E')
        .borderRadius(18)
        .onClick(() => this.setValue())

      Button('Get · O(log n)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#E9FFF5')
        .backgroundColor('#235A67')
        .borderRadius(18)
        .onClick(() => this.getValue())

      Button('Has · O(log n)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#EEF5FF')
        .backgroundColor('#2A4B7C')
        .borderRadius(18)
        .onClick(() => this.hasKey())

      Button('Delete · O(log n)')
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
