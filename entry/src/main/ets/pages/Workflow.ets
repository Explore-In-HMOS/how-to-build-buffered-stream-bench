import { StatCard } from '../components/StatCard';
import { checkpointBoardService } from '../services/CheckpointBoardService';
import { WorkflowSnapshot } from '../models/CheckpointModels';

@Component
export struct Workflow {
  @Consume('pathStack') pathStack: NavPathStack;
  private readonly boardService = checkpointBoardService;
  @State refreshToken: number = 0;

  aboutToAppear(): void {
    this.refreshToken = this.boardService.getRevision();
  }

  private goBack(): void {
    this.pathStack.pop();
  }

  private goRegistry(): void {
    this.pathStack.pushPath({ name: 'Registry' });
  }

  private resetShift(): void {
    this.boardService.reseed();
    this.refreshToken = this.boardService.getRevision();
  }

  private runIntakeAction(): void {
    this.boardService.intakeNextPendingCheckpoint();
    this.refreshToken = this.boardService.getRevision();
  }

  private runTailInspection(): void {
    this.boardService.rotateReviewTailWithLinkedSet();
    this.refreshToken = this.boardService.getRevision();
  }

  private runStatusRelabel(): void {
    this.boardService.relabelReviewStatusWithListSet();
    this.refreshToken = this.boardService.getRevision();
  }

  private resolveLatestReview(): void {
    this.boardService.resolveReviewTail();
    this.refreshToken = this.boardService.getRevision();
  }

  private nextCheckpointText(): string {
    const nextItem = this.boardService.getNextPendingItem();
    return nextItem ? nextItem.title : 'None pending';
  }

  private workflowSnapshot(): WorkflowSnapshot {
    return this.boardService.getWorkflowSnapshot();
  }

  private workflowNotes(): string[] {
    return this.boardService.getWorkflowMethodNotes();
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 12 }) {
          Text('Linear Collections')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#F4F8FF')
            .textAlign(TextAlign.Center)
            .width('100%')

          Text('Action-first: run one call, read the result below.')
            .fontSize(10)
            .fontColor('#B6C0CC')
            .textAlign(TextAlign.Center)
            .width('100%')

          StatCard({ title: 'Family', value: 'Queue / Deque / Stack / List' })
          StatCard({ title: 'Pending items', value: `${this.boardService.getSummary().pendingItems}` })
          StatCard({ title: 'Next item', value: this.nextCheckpointText() })
          StatCard({
            title: 'Stack state',
            value: `${this.workflowSnapshot().resolvedStackCount} entries · isEmpty=${this.workflowSnapshot().resolvedStackEmpty}`
          })

          Button('Queue.add + ArrayList.add')
            .width('100%')
            .height(36)
            .fontSize(10)
            .fontColor('#EEF5FF')
            .backgroundColor('#2A4B7C')
            .borderRadius(18)
            .onClick(() => this.runIntakeAction())

          Button('Deque.getLast + LinkedList.set')
            .width('100%')
            .height(34)
            .fontSize(10)
            .fontColor('#E9FFF5')
            .backgroundColor('#235A67')
            .borderRadius(17)
            .onClick(() => this.runTailInspection())

          Button('List.set')
            .width('100%')
            .height(34)
            .fontSize(10)
            .fontColor('#F3F5FF')
            .backgroundColor('#4A3E73')
            .borderRadius(17)
            .onClick(() => this.runStatusRelabel())

          Button('Resolve tail + Stack.isEmpty')
            .width('100%')
            .height(34)
            .fontSize(10)
            .fontColor('#FDEDF0')
            .backgroundColor('#6A2C35')
            .borderRadius(17)
            .onClick(() => this.resolveLatestReview())

          Column({ space: 6 }) {
              Text('Results')
                .fontSize(10)
                .fontColor('#D4E2F5')
                .fontWeight(FontWeight.Medium)
                .width('100%')
            Text(`Queue(${this.workflowSnapshot().intakeQueueCount}): ${this.workflowSnapshot().intakeQueuePreview}`)
              .fontSize(9)
              .fontColor('#A9BDDA')
              .width('100%')
            Text(`Deque tail: ${this.workflowSnapshot().reviewTail}`)
              .fontSize(9)
              .fontColor('#A9BDDA')
              .width('100%')
            Text(`ArrayList(${this.workflowSnapshot().timelineCount}): ${this.workflowSnapshot().timelinePreview}`)
              .fontSize(9)
              .fontColor('#A9BDDA')
              .width('100%')
            Text(`LinkedList(${this.workflowSnapshot().linkedSequenceCount}): ${this.workflowSnapshot().linkedSequencePreview}`)
              .fontSize(9)
              .fontColor('#A9BDDA')
              .width('100%')
            Text(`List(${this.workflowSnapshot().statusListCount}): ${this.workflowSnapshot().statusListPreview}`)
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
            ForEach(this.workflowNotes(), (note: string) => {
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

          Button('Go to Set/Map/Indexed/Flag')
            .width('100%')
            .height(34)
            .fontSize(11)
            .fontColor('#E9FFF5')
            .backgroundColor('#1F5A4A')
            .borderRadius(17)
            .onClick(() => this.goRegistry())

          Button('Reset + reseed')
            .width('100%')
            .height(34)
            .fontSize(11)
            .fontColor('#EEF5FF')
            .backgroundColor('#2A4B7C')
            .borderRadius(17)
            .onClick(() => this.resetShift())

          Button('Back to Home')
            .width('100%')
            .height(34)
            .fontSize(11)
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
