import { checkpointBoardService } from '../services/CheckpointBoardService';
import { QueuePage } from './QueuePage';
import { DequePage } from './DequePage';
import { StackPage } from './StackPage';
import { ArrayListAddPage } from './ArrayListAddPage';
import { LinkedListListSetPage } from './LinkedListListSetPage';
import { HashSetAddPage } from './HashSetAddPage';
import { LightWeightSetAddPage } from './LightWeightSetAddPage';
import { TreeSetAddPage } from './TreeSetAddPage';
import { LightWeightMapSetPage } from './LightWeightMapSetPage';
import { TreeMapSetPage } from './TreeMapSetPage';
import { PlainArraySetValueAtPage } from './PlainArraySetValueAtPage';
import { BitVectorSetAllBitsPage } from './BitVectorSetAllBitsPage';
import { Workflow } from './Workflow';
import { Registry } from './Registry';

@Entry
@Component
struct Index {
  @Provide('pathStack') pathStack: NavPathStack = new NavPathStack();
  private readonly boardService = checkpointBoardService;
  @State refreshToken: number = 0;

  private openPage(name: string): void {
    this.pathStack.pushPath({ name: name });
  }

  @Builder
  private navDestinationBuilder(name: string, _param: Object) {
    if (name === 'QueuePage') {
      QueuePage();
    } else if (name === 'DequePage') {
      DequePage();
    } else if (name === 'StackPage') {
      StackPage();
    } else if (name === 'ArrayListAddPage') {
      ArrayListAddPage();
    } else if (name === 'LinkedListListSetPage') {
      LinkedListListSetPage();
    } else if (name === 'HashSetAddPage') {
      HashSetAddPage();
    } else if (name === 'LightWeightSetAddPage') {
      LightWeightSetAddPage();
    } else if (name === 'TreeSetAddPage') {
      TreeSetAddPage();
    } else if (name === 'LightWeightMapSetPage') {
      LightWeightMapSetPage();
    } else if (name === 'TreeMapSetPage') {
      TreeMapSetPage();
    } else if (name === 'PlainArraySetValueAtPage') {
      PlainArraySetValueAtPage();
    } else if (name === 'BitVectorSetAllBitsPage') {
      BitVectorSetAllBitsPage();
    } else if (name === 'Workflow') {
      Workflow();
    } else if (name === 'Registry') {
      Registry();
    }
  }

  private resetShiftSeed(): void {
    this.boardService.reseed();
    this.refreshToken = this.boardService.getRevision();
  }

  private nextPendingText(): string {
    const nextItem = this.boardService.getNextPendingItem();
    if (!nextItem) {
      return 'All resolved';
    }
    return `${nextItem.id} • Slot ${nextItem.slot}`;
  }

  aboutToAppear(): void {
    this.refreshToken = this.boardService.getRevision();
  }

  build() {
    Navigation(this.pathStack) {
      Column() {
        Scroll() {
          Column({ space: 12 }) {
          Text('Collections Core Methods Lab')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#F4F8FF')
            .textAlign(TextAlign.Center)
            .width('100%')

          Text('Open one page and try compact core operations.')
            .fontSize(10)
            .fontColor('#B6C0CC')
            .textAlign(TextAlign.Center)
            .width('100%')

          Text(`Seed: ${this.boardService.getSummary().totalItems} items · next ${this.nextPendingText()}`)
            .fontSize(9)
            .fontColor('#9CB1CC')
            .textAlign(TextAlign.Center)
            .width('100%')

            Button('Queue Core')
            .width('100%')
            .height(36)
            .fontSize(11)
            .fontColor('#EAF3FF')
            .backgroundColor('#2A4B7C')
            .borderRadius(18)
              .onClick(() => this.openPage('QueuePage'))

            Button('Deque Core')
            .width('100%')
            .height(36)
            .fontSize(11)
            .fontColor('#E9FFF5')
            .backgroundColor('#235A67')
            .borderRadius(18)
              .onClick(() => this.openPage('DequePage'))

            Button('Stack Core')
            .width('100%')
            .height(36)
            .fontSize(11)
            .fontColor('#FDEDF0')
            .backgroundColor('#6A2C35')
            .borderRadius(18)
              .onClick(() => this.openPage('StackPage'))

            Button('ArrayList Core')
            .width('100%')
            .height(36)
            .fontSize(11)
            .fontColor('#EEF5FF')
            .backgroundColor('#4A3E73')
            .borderRadius(18)
              .onClick(() => this.openPage('ArrayListAddPage'))

            Button('LinkedList + List Core')
            .width('100%')
            .height(36)
            .fontSize(10)
            .fontColor('#FFF9EA')
            .backgroundColor('#6A4E1E')
            .borderRadius(18)
              .onClick(() => this.openPage('LinkedListListSetPage'))

            Button('HashSet.add page')
            .width('100%')
            .height(36)
            .fontSize(11)
            .fontColor('#EAF3FF')
            .backgroundColor('#2A4B7C')
            .borderRadius(18)
              .onClick(() => this.openPage('HashSetAddPage'))

            Button('LightWeightSet.add page')
            .width('100%')
            .height(36)
            .fontSize(10)
            .fontColor('#E9FFF5')
            .backgroundColor('#235A67')
            .borderRadius(18)
              .onClick(() => this.openPage('LightWeightSetAddPage'))

            Button('TreeSet.add page')
            .width('100%')
            .height(36)
            .fontSize(11)
            .fontColor('#FFF9EA')
            .backgroundColor('#6A4E1E')
            .borderRadius(18)
              .onClick(() => this.openPage('TreeSetAddPage'))

            Button('LightWeightMap.set page')
            .width('100%')
            .height(36)
            .fontSize(10)
            .fontColor('#F3F5FF')
            .backgroundColor('#4A3E73')
            .borderRadius(18)
              .onClick(() => this.openPage('LightWeightMapSetPage'))

            Button('TreeMap.set page')
            .width('100%')
            .height(36)
            .fontSize(11)
            .fontColor('#FFF9EA')
            .backgroundColor('#6A4E1E')
            .borderRadius(18)
              .onClick(() => this.openPage('TreeMapSetPage'))

            Button('PlainArray.setValueAt page')
            .width('100%')
            .height(36)
            .fontSize(10)
            .fontColor('#E9FFF5')
            .backgroundColor('#235A67')
            .borderRadius(18)
              .onClick(() => this.openPage('PlainArraySetValueAtPage'))

            Button('BitVector.setAllBits page')
            .width('100%')
            .height(36)
            .fontSize(10)
            .fontColor('#EEF5FF')
            .backgroundColor('#2A4B7C')
            .borderRadius(18)
              .onClick(() => this.openPage('BitVectorSetAllBitsPage'))

            Button('Reset Seed Data')
            .width('100%')
            .height(34)
            .fontSize(11)
            .fontColor('#FFF1F1')
            .backgroundColor('#6A2C35')
            .borderRadius(17)
              .onClick(() => this.resetShiftSeed())

            Text(`${this.boardService.getLastActionNote()} · r${this.refreshToken}`)
            .fontSize(10)
            .fontColor('#91A3BA')
            .width('100%')
            .textAlign(TextAlign.Center)
          }
          .padding({ left: 16, right: 16, top: 18, bottom: 20 })
          .width('100%')
        }
        .scrollBar(BarState.Off)
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#0B111B')
    }
    .navDestination(this.navDestinationBuilder)
    .hideTitleBar(true)
  }
}
