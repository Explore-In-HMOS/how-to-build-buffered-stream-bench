import { StatCard } from '../components/StatCard';
import { RegistrySnapshot } from '../models/CheckpointModels';
import { checkpointBoardService } from '../services/CheckpointBoardService';

@Component
export struct Registry {
  @Consume('pathStack') pathStack: NavPathStack;
  private readonly boardService = checkpointBoardService;
  @State refreshToken: number = 0;

  aboutToAppear(): void {
    this.refreshToken = this.boardService.getRevision();
  }

  private goBack(): void {
    this.pathStack.pop();
  }

  private goHome(): void {
    this.pathStack.clear();
  }

  private runFullRegistrySync(): void {
    this.boardService.runRegistrySyncDemo();
    this.refreshToken = this.boardService.getRevision();
  }

  private runHashSetAdd(): void {
    this.boardService.registerCheckpointTag();
    this.refreshToken = this.boardService.getRevision();
  }

  private runLightWeightSetAdd(): void {
    this.boardService.registerWatcher();
    this.refreshToken = this.boardService.getRevision();
  }

  private runTreeSetAdd(): void {
    this.boardService.rebuildSortedCheckpointIndex();
    this.refreshToken = this.boardService.getRevision();
  }

  private runMapSync(): void {
    this.boardService.syncSlotZoneMap();
    this.boardService.syncTreeReviewMap();
    this.refreshToken = this.boardService.getRevision();
  }

  private runPlainArrayAndFlags(): void {
    this.boardService.updateSparseSlotValue();
    this.boardService.markAllSlotsOccupied();
    this.refreshToken = this.boardService.getRevision();
  }

  private clearFlags(): void {
    this.boardService.clearAllSlotFlags();
    this.refreshToken = this.boardService.getRevision();
  }

  private resetSeed(): void {
    this.boardService.reseed();
    this.refreshToken = this.boardService.getRevision();
  }

  private registrySnapshot(): RegistrySnapshot {
    return this.boardService.getRegistrySnapshot();
  }

  private registryNotes(): string[] {
    return this.boardService.getRegistryMethodNotes();
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 12 }) {
          Text('Grouped Registry APIs')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#F4F8FF')
            .textAlign(TextAlign.Center)
            .width('100%')

          Text('Grouped demos: set/map/indexed/flag APIs.')
            .fontSize(10)
            .fontColor('#B6C0CC')
            .textAlign(TextAlign.Center)
            .width('100%')

          StatCard({ title: 'Set family', value: 'HashSet / LightWeightSet / TreeSet' })
          StatCard({ title: 'Map family', value: 'LightWeightMap / TreeMap' })
          StatCard({ title: 'Indexed + flags', value: 'PlainArray / BitVector' })
          StatCard({ title: 'Bit flags', value: this.registrySnapshot().occupiedFlagPreview })

          Button('HashSet.add')
            .width('100%')
            .height(34)
            .fontSize(10)
            .fontColor('#EEF5FF')
            .backgroundColor('#2A4B7C')
            .borderRadius(17)
            .onClick(() => this.runHashSetAdd())

          Button('LightWeightSet.add')
            .width('100%')
            .height(34)
            .fontSize(10)
            .fontColor('#E9FFF5')
            .backgroundColor('#235A67')
            .borderRadius(17)
            .onClick(() => this.runLightWeightSetAdd())

          Button('TreeSet.add')
            .width('100%')
            .height(34)
            .fontSize(10)
            .fontColor('#F3F5FF')
            .backgroundColor('#4A3E73')
            .borderRadius(17)
            .onClick(() => this.runTreeSetAdd())

          Button('LightWeightMap.set + TreeMap.set')
            .width('100%')
            .height(34)
            .fontSize(10)
            .fontColor('#FFF9EA')
            .backgroundColor('#6A4E1E')
            .borderRadius(17)
            .onClick(() => this.runMapSync())

          Button('PlainArray.setValueAt + BitVector.setAllBits')
            .width('100%')
            .height(34)
            .fontSize(9)
            .fontColor('#FDEDF0')
            .backgroundColor('#6A2C35')
            .borderRadius(17)
            .onClick(() => this.runPlainArrayAndFlags())

          Column({ space: 6 }) {
              Text('Results')
                .fontSize(10)
                .fontColor('#D4E2F5')
                .fontWeight(FontWeight.Medium)
                .width('100%')
              Text(`HashSet(${this.registrySnapshot().hashTagCount}): ${this.registrySnapshot().hashTagPreview}`)
                .fontSize(9)
                .fontColor('#A9BDDA')
                .width('100%')
              Text(`LightWeightSet(${this.registrySnapshot().watcherCount}): ${this.registrySnapshot().watcherPreview}`)
                .fontSize(9)
                .fontColor('#A9BDDA')
                .width('100%')
              Text(`TreeSet(${this.registrySnapshot().treeCheckpointCount}): ${this.registrySnapshot().treeCheckpointPreview}`)
                .fontSize(9)
                .fontColor('#A9BDDA')
                .width('100%')
              Text(`LightWeightMap(${this.registrySnapshot().slotZoneCount}): ${this.registrySnapshot().slotZonePreview}`)
                .fontSize(9)
                .fontColor('#A9BDDA')
              .width('100%')
            Text(`TreeMap(${this.registrySnapshot().syncTreeCount}): ${this.registrySnapshot().syncTreePreview}`)
              .fontSize(9)
              .fontColor('#A9BDDA')
              .width('100%')
            Text(`PlainArray(${this.registrySnapshot().plainArrayCount}): ${this.registrySnapshot().plainArrayPreview}`)
              .fontSize(9)
              .fontColor('#A9BDDA')
              .width('100%')
            Text(`Flag state: ${this.registrySnapshot().occupiedFlagState}`)
              .fontSize(9)
              .fontColor('#A9BDDA')
              .width('100%')
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#18293F')
          .borderRadius(10)

          Column({ space: 6 }) {
              Text('Why these APIs')
                .fontSize(10)
                .fontColor('#D8E7FF')
                .fontWeight(FontWeight.Medium)
                .width('100%')
            ForEach(this.registryNotes(), (note: string) => {
              Text(`• ${note}`)
                .fontSize(9)
                .fontColor('#9CB1CC')
                .width('100%')
            }, (note: string) => note)
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#121E30')
          .borderRadius(10)

          Button('Run all grouped APIs')
            .width('100%')
            .height(34)
            .fontSize(10)
            .fontColor('#E9FFF5')
            .backgroundColor('#1F5A4A')
            .borderRadius(17)
            .onClick(() => this.runFullRegistrySync())

          Button('Clear bit flags (setAllBits=0)')
            .width('100%')
            .height(34)
            .fontSize(10)
            .fontColor('#EEF5FF')
            .backgroundColor('#2A4B7C')
            .borderRadius(17)
            .onClick(() => this.clearFlags())

          Button('Reset + reseed')
            .width('100%')
            .height(34)
            .fontSize(10)
            .fontColor('#FFF1F1')
            .backgroundColor('#6A2C35')
            .borderRadius(17)
            .onClick(() => this.resetSeed())

          Button('Return to Home')
            .width('100%')
            .height(34)
            .fontSize(10)
            .fontColor('#EAF3FF')
            .backgroundColor('#2A4B7C')
            .borderRadius(17)
            .onClick(() => this.goHome())

          Button('Back')
            .width('100%')
            .height(34)
            .fontSize(10)
            .fontColor('#FFF1F1')
            .backgroundColor('#6A2C35')
            .borderRadius(17)
            .onClick(() => this.goBack())

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
}
