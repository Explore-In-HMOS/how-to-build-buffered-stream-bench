import { collections } from '@kit.ArkTS';

@Component
export struct BitVectorSetAllBitsPage {
  @Consume('pathStack') pathStack: NavPathStack;
  private bitVector: collections.BitVector = new collections.BitVector(8);
  @State stateText: string = '0/8 set';
  @State resultText: string = 'Ready';

  aboutToAppear(): void {
    this.resetVector();
  }

  private refreshStateText(): void {
    let setCount = 0;
    for (let index = 0; index < this.bitVector.length; index += 1) {
      if (this.bitVector[index] === 1) {
        setCount += 1;
      }
    }
    this.stateText = `${setCount}/${this.bitVector.length} set`;
  }

  private setAll(): void {
    try {
      this.bitVector.setAllBits(1);
    } catch (err) {
      this.resultText = `Set all failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = 'Set all bits to 1';
    this.refreshStateText();
  }

  private clearAll(): void {
    try {
      this.bitVector.setAllBits(0);
    } catch (err) {
      this.resultText = `Clear failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = 'Cleared all bits to 0';
    this.refreshStateText();
  }

  private inspect(): void {
    this.resultText = `State: ${this.stateText}`;
  }

  private resetVector(): void {
    this.bitVector = new collections.BitVector(8);
    try {
      this.bitVector.setAllBits(0);
    } catch (err) {
      this.resultText = `Reset failed: ${JSON.stringify(err)}`;
      return;
    }
    this.resultText = 'BitVector reset';
    this.refreshStateText();
  }

  private backToHome(): void {
    this.pathStack.pop();
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 10 }) {
      Text('BitVector Core')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F4F8FF')

      Button('Set All · O(n)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#EEF5FF')
        .backgroundColor('#2A4B7C')
        .borderRadius(17)
        .onClick(() => this.setAll())

      Button('Clear All · O(n)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#E9FFF5')
        .backgroundColor('#235A67')
        .borderRadius(17)
        .onClick(() => this.clearAll())

      Button('Inspect · O(n)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#F3F5FF')
        .backgroundColor('#4A3E73')
        .borderRadius(17)
        .onClick(() => this.inspect())

      Button('Reset · O(1)')
        .width('100%')
        .height(32)
        .fontSize(10)
        .fontColor('#FDEDF0')
        .backgroundColor('#5A2A34')
        .borderRadius(17)
        .onClick(() => this.resetVector())

      Column({ space: 4 }) {
        Text(`State: ${this.stateText}`)
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
