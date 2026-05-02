import { createCheckpointSeed } from '../data/CheckpointSeedData';
import { CheckpointItem, CheckpointSeed, CheckpointPriority, CheckpointStatus, RegistrySnapshot, ShiftSummary, WorkflowSnapshot } from '../models/CheckpointModels';
import { ArrayList, Deque, HashSet, LightWeightMap, LightWeightSet, LinkedList, List, PlainArray, Queue, Stack, TreeMap, TreeSet, collections } from '@kit.ArkTS';

export class CheckpointBoardService {
  private static instance?: CheckpointBoardService;

  private seed: CheckpointSeed = createCheckpointSeed();
  private items: CheckpointItem[] = [];
  private intakeQueue: Queue<string> = new Queue<string>();
  private reviewDeque: Deque<string> = new Deque<string>();
  private resolvedStack: Stack<string> = new Stack<string>();
  private intakeTimeline: ArrayList<string> = new ArrayList<string>();
  private linkedSequence: LinkedList<string> = new LinkedList<string>();
  private statusSequence: List<string> = new List<string>();
  private watchTagSet: HashSet<string> = new HashSet<string>();
  private watcherSet: LightWeightSet<string> = new LightWeightSet<string>();
  private sortedCheckpointSet: TreeSet<string> = new TreeSet<string>();
  private slotZoneMap: LightWeightMap<number, string> = new LightWeightMap<number, string>();
  private syncReviewTree: TreeMap<string, string> = new TreeMap<string, string>();
  private sparseSlotArray: PlainArray<string> = new PlainArray<string>();
  private occupiedFlags: collections.BitVector = new collections.BitVector(8);
  private occupiedFlagState: number = 0;
  private revision: number = 0;
  private lastActionNote: string = 'Seed loaded';

  private constructor() {
    this.reseed();
  }

  static getInstance(): CheckpointBoardService {
    if (!CheckpointBoardService.instance) {
      CheckpointBoardService.instance = new CheckpointBoardService();
    }
    return CheckpointBoardService.instance;
  }

  reseed(): void {
    this.seed = createCheckpointSeed();
    this.items = this.seed.items.slice();
    this.intakeQueue = new Queue<string>();
    this.reviewDeque = new Deque<string>();
    this.resolvedStack = new Stack<string>();
    this.intakeTimeline = new ArrayList<string>();
    this.linkedSequence = new LinkedList<string>();
    this.statusSequence = new List<string>();
    this.watchTagSet = new HashSet<string>();
    this.watcherSet = new LightWeightSet<string>();
    this.sortedCheckpointSet = new TreeSet<string>();
    this.slotZoneMap = new LightWeightMap<number, string>();
    this.syncReviewTree = new TreeMap<string, string>();
    this.sparseSlotArray = new PlainArray<string>();
    this.occupiedFlags = new collections.BitVector(8);
    this.occupiedFlagState = 0;

    this.seed.items.forEach((item: CheckpointItem) => {
      try {
        const card = this.formatItemCard(item);
        this.intakeQueue.add(card);
        this.reviewDeque.insertEnd(card);
        this.intakeTimeline.add(card);
        this.linkedSequence.add(card);
        this.statusSequence.add(`${item.id}:${item.status}`);
        if (item.status === CheckpointStatus.RESOLVED) {
          this.resolvedStack.push(item.id);
        }
      } catch (err) {
        console.error(`Failed to reseed workflow collections: ${JSON.stringify(err)}`);
      }
    });

    this.seedRegistryCollections();

    this.lastActionNote = 'Shift reseeded';
    this.bumpRevision();
  }

  getSummary(): ShiftSummary {
    const pending = this.items.filter((item: CheckpointItem) => item.status === CheckpointStatus.PENDING).length;
    const inReview = this.items.filter((item: CheckpointItem) => item.status === CheckpointStatus.IN_REVIEW).length;
    const resolved = this.items
      .filter((item: CheckpointItem) => item.status === CheckpointStatus.RESOLVED).length;

    return {
      shiftLabel: this.seed.shiftLabel,
      totalItems: this.items.length,
      pendingItems: pending,
      inReviewItems: inReview,
      resolvedItems: resolved,
      occupiedSlotCount: this.seed.occupiedSlots.length
    };
  }

  getNextPendingItem(): CheckpointItem | undefined {
    return this.items.find((item: CheckpointItem) => item.status === CheckpointStatus.PENDING);
  }

  getItems(): CheckpointItem[] {
    return this.items.slice();
  }

  getActiveZones(): string[] {
    return this.seed.activeZones.slice();
  }

  getWatchTags(): string[] {
    return this.seed.watchTags.slice();
  }

  getLastActionNote(): string {
    return this.lastActionNote;
  }

  getLastActionNoteForLearner(): string {
    return this.formatForLearner(this.lastActionNote);
  }

  formatForLearner(value: string): string {
    return value
      .replace(/CP-\d+/g, 'item')
      .replace(/@S(\d+)/g, ' @slot-$1');
  }

  getRevision(): number {
    return this.revision;
  }

  getWorkflowSnapshot(): WorkflowSnapshot {
    return {
      intakeQueuePreview: this.joinQueue(this.intakeQueue),
      intakeQueueCount: this.intakeQueue.length,
      reviewTail: this.getReviewTail(),
      reviewDequeCount: this.reviewDeque.length,
      timelinePreview: this.joinArrayList(this.intakeTimeline),
      timelineCount: this.intakeTimeline.length,
      linkedSequencePreview: this.joinLinkedList(this.linkedSequence),
      linkedSequenceCount: this.linkedSequence.length,
      statusListPreview: this.joinList(this.statusSequence),
      statusListCount: this.statusSequence.length,
      resolvedStackEmpty: this.isResolvedStackEmpty(),
      resolvedStackCount: this.resolvedStack.length
    };
  }

  getWorkflowMethodNotes(): string[] {
    return [
      'Queue.add keeps intake FIFO as checkpoints arrive.',
      'Deque.getLast peeks the most recent review target.',
      'Stack.isEmpty quickly reports whether any resolutions are recorded.',
      'ArrayList.add appends an easy-to-read intake timeline.',
      'LinkedList.set edits a queued sequence step in place.',
      'List.set updates status labels in the singly linked timeline.'
    ];
  }

  runQueueAddDemo(): void {
    const marker = `Q-demo-${this.revision}`;
    try {
      this.intakeQueue.add(marker);
    } catch (err) {
      this.lastActionNote = `Queue.add failed: ${JSON.stringify(err)}`;
      this.bumpRevision();
      return;
    }
    this.lastActionNote = `Queue.add appended ${marker}`;
    this.bumpRevision();
  }

  getQueueCount(): number {
    return this.intakeQueue.length;
  }

  getQueuePreview(): string {
    return this.joinQueue(this.intakeQueue);
  }

  getQueueLastItem(): string {
    let lastItem = 'empty';
    try {
      this.intakeQueue.forEach((value: string) => {
        lastItem = value;
      });
    } catch (err) {
      return `error:${JSON.stringify(err)}`;
    }
    return lastItem;
  }

  addDequeDemoEntry(): void {
    const marker = `D-demo-${this.revision}`;
    try {
      this.reviewDeque.insertEnd(marker);
    } catch (err) {
      this.lastActionNote = `Deque.insertEnd failed: ${JSON.stringify(err)}`;
      this.bumpRevision();
      return;
    }
    this.lastActionNote = `Added ${marker} so Deque.getLast has a fresh tail`;
    this.bumpRevision();
  }

  inspectDequeTail(): void {
    if (this.reviewDeque.length === 0) {
      this.lastActionNote = 'Deque.getLast skipped: deque is empty';
      this.bumpRevision();
      return;
    }
    try {
      const tail = this.reviewDeque.getLast();
      this.lastActionNote = `Deque.getLast -> ${tail}`;
    } catch (err) {
      this.lastActionNote = `Deque.getLast failed: ${JSON.stringify(err)}`;
      this.bumpRevision();
      return;
    }
    this.bumpRevision();
  }

  getDequeCount(): number {
    return this.reviewDeque.length;
  }

  getDequeTail(): string {
    return this.getReviewTail();
  }

  checkResolvedStackIsEmpty(): void {
    const emptyNow = this.isResolvedStackEmpty();
    this.lastActionNote = `Stack.isEmpty -> ${emptyNow}`;
    this.bumpRevision();
  }

  pushResolvedStackDemoEntry(): void {
    const marker = `S-demo-${this.revision}`;
    try {
      this.resolvedStack.push(marker);
    } catch (err) {
      this.lastActionNote = `Stack.push failed: ${JSON.stringify(err)}`;
      this.bumpRevision();
      return;
    }
    this.lastActionNote = `Pushed ${marker}, Stack.isEmpty -> ${this.isResolvedStackEmpty()}`;
    this.bumpRevision();
  }

  getResolvedStackCount(): number {
    return this.resolvedStack.length;
  }

  getResolvedStackEmpty(): boolean {
    return this.isResolvedStackEmpty();
  }

  runArrayListAddDemo(): void {
    const marker = `A-demo-${this.revision}`;
    try {
      this.intakeTimeline.add(marker);
    } catch (err) {
      this.lastActionNote = `ArrayList.add failed: ${JSON.stringify(err)}`;
      this.bumpRevision();
      return;
    }
    this.lastActionNote = `ArrayList.add appended ${marker}`;
    this.bumpRevision();
  }

  getArrayListCount(): number {
    return this.intakeTimeline.length;
  }

  getArrayListPreview(): string {
    return this.joinArrayList(this.intakeTimeline);
  }

  getLinkedListCount(): number {
    return this.linkedSequence.length;
  }

  getLinkedListPreview(): string {
    return this.joinLinkedList(this.linkedSequence);
  }

  getListCount(): number {
    return this.statusSequence.length;
  }

  getListPreview(): string {
    return this.joinList(this.statusSequence);
  }

  runHashSetAddDemo(): void {
    this.registerCheckpointTag();
  }

  getHashSetCount(): number {
    return this.watchTagSet.length;
  }

  getHashSetPreview(): string {
    return this.joinHashSet(this.watchTagSet);
  }

  runLightWeightSetAddDemo(): void {
    this.registerWatcher();
  }

  getLightWeightSetCount(): number {
    return this.watcherSet.length;
  }

  getLightWeightSetPreview(): string {
    return this.joinLightWeightSet(this.watcherSet);
  }

  runTreeSetAddDemo(): void {
    this.rebuildSortedCheckpointIndex();
  }

  getTreeSetCount(): number {
    return this.sortedCheckpointSet.length;
  }

  getTreeSetPreview(): string {
    return this.joinTreeSet(this.sortedCheckpointSet);
  }

  runLightWeightMapSetDemo(): void {
    this.syncSlotZoneMap();
  }

  getLightWeightMapCount(): number {
    return this.slotZoneMap.length;
  }

  getLightWeightMapPreview(): string {
    return this.joinLightWeightMap(this.slotZoneMap);
  }

  runTreeMapSetDemo(): void {
    this.syncTreeReviewMap();
  }

  getTreeMapCount(): number {
    return this.syncReviewTree.length;
  }

  getTreeMapPreview(): string {
    return this.joinTreeMap(this.syncReviewTree);
  }

  runPlainArraySetValueAtDemo(): void {
    this.updateSparseSlotValue();
  }

  getPlainArrayCount(): number {
    return this.sparseSlotArray.length;
  }

  getPlainArrayPreview(): string {
    return this.joinPlainArray(this.sparseSlotArray);
  }

  runBitVectorSetAllBitsDemo(): void {
    this.markAllSlotsOccupied();
  }

  clearBitVectorSetAllBitsDemo(): void {
    this.clearAllSlotFlags();
  }

  getBitVectorPreview(): string {
    return this.occupiedFlagState === 1
      ? `all occupied (${this.occupiedFlags.length}/${this.occupiedFlags.length})`
      : `all clear (0/${this.occupiedFlags.length})`;
  }

  getRegistrySnapshot(): RegistrySnapshot {
    return {
      hashTagCount: this.watchTagSet.length,
      hashTagPreview: this.joinHashSet(this.watchTagSet),
      watcherCount: this.watcherSet.length,
      watcherPreview: this.joinLightWeightSet(this.watcherSet),
      treeCheckpointCount: this.sortedCheckpointSet.length,
      treeCheckpointPreview: this.joinTreeSet(this.sortedCheckpointSet),
      slotZoneCount: this.slotZoneMap.length,
      slotZonePreview: this.joinLightWeightMap(this.slotZoneMap),
      syncTreeCount: this.syncReviewTree.length,
      syncTreePreview: this.joinTreeMap(this.syncReviewTree),
      plainArrayCount: this.sparseSlotArray.length,
      plainArrayPreview: this.joinPlainArray(this.sparseSlotArray),
      occupiedFlagPreview: this.occupiedFlagState === 1
        ? `all occupied (${this.occupiedFlags.length}/${this.occupiedFlags.length})`
        : `all clear (0/${this.occupiedFlags.length})`,
      occupiedFlagState: this.occupiedFlagState
    };
  }

  getRegistryMethodNotes(): string[] {
    return [
      'HashSet.add stores unique watch tags and rejects duplicates.',
      'LightWeightSet.add keeps a compact dedup set for active watchers.',
      'TreeSet.add builds an ordered checkpoint index for scan-friendly review.',
      'LightWeightMap.set maps numeric slot IDs to zone labels.',
      'TreeMap.set keeps sync records sorted by checkpoint key.',
      'PlainArray.setValueAt updates sparse slot value by position index.',
      'BitVector.setAllBits flips board occupancy flags in one operation.'
    ];
  }

  intakeNextPendingCheckpoint(): void {
    const nextPending = this.items.find((item: CheckpointItem) => item.status === CheckpointStatus.PENDING);
    if (!nextPending) {
      this.lastActionNote = 'No pending checkpoint available for intake';
      this.bumpRevision();
      return;
    }

    nextPending.status = CheckpointStatus.IN_REVIEW;
    const card = this.formatItemCard(nextPending);
    try {
      this.intakeQueue.add(card);
      this.reviewDeque.insertEnd(card);
      this.intakeTimeline.add(`${nextPending.id}:intake`);
    } catch (err) {
      this.lastActionNote = `Failed intake enqueue: ${JSON.stringify(err)}`;
      this.bumpRevision();
      return;
    }
    this.lastActionNote = `Queued ${nextPending.id} with Queue.add and ArrayList.add`;
    this.bumpRevision();
  }

  rotateReviewTailWithLinkedSet(): void {
    if (this.reviewDeque.length === 0 || this.linkedSequence.length === 0) {
      this.lastActionNote = 'Nothing in review deque for tail inspection';
      this.bumpRevision();
      return;
    }

    try {
      const tail = this.reviewDeque.getLast();
      const replacement = `${tail} • tail-check`;
      this.linkedSequence.set(this.linkedSequence.length - 1, replacement);
    } catch (err) {
      this.lastActionNote = `Tail inspection failed: ${JSON.stringify(err)}`;
      this.bumpRevision();
      return;
    }
    this.lastActionNote = 'Inspected Deque.getLast and updated LinkedList.set tail';
    this.bumpRevision();
  }

  relabelReviewStatusWithListSet(): void {
    if (this.statusSequence.length === 0) {
      this.lastActionNote = 'Status sequence is empty';
      this.bumpRevision();
      return;
    }

    try {
      const current = this.statusSequence.get(0);
      this.statusSequence.set(0, `${current} • list-set`);
    } catch (err) {
      this.lastActionNote = `List.set update failed: ${JSON.stringify(err)}`;
      this.bumpRevision();
      return;
    }
    this.lastActionNote = 'Updated first status with List.set';
    this.bumpRevision();
  }

  resolveReviewTail(): void {
    if (this.reviewDeque.length === 0) {
      const emptyNow = this.isResolvedStackEmpty();
      this.lastActionNote = emptyNow
        ? 'No review tail and resolved stack is empty'
        : 'No review tail; Stack.isEmpty confirms resolved history remains';
      this.bumpRevision();
      return;
    }

    try {
      const tail = this.reviewDeque.popLast();
      this.markItemResolvedByCard(tail);
      this.resolvedStack.push(tail);
      this.intakeTimeline.add(`resolved:${tail}`);
      this.lastActionNote = `Resolved ${tail}; Stack.isEmpty=${this.isResolvedStackEmpty()}`;
    } catch (err) {
      this.lastActionNote = `Tail resolution failed: ${JSON.stringify(err)}`;
      this.bumpRevision();
      return;
    }
    this.bumpRevision();
  }

  private markItemResolvedByCard(card: string): void {
    const checkpointId = card.split('@')[0];
    const target = this.items.find((item: CheckpointItem) => item.id === checkpointId);
    if (!target) {
      return;
    }
    target.status = CheckpointStatus.RESOLVED;
  }

  runIntakeQueueDemo(): void {
    this.intakeNextPendingCheckpoint();
  }

  runRegistrySyncDemo(): void {
    this.registerCheckpointTag();
    this.registerWatcher();
    this.rebuildSortedCheckpointIndex();
    this.syncSlotZoneMap();
    this.syncTreeReviewMap();
    this.updateSparseSlotValue();
    this.markAllSlotsOccupied();
    this.lastActionNote = 'Registry sync demo ran all set/map/plain-array/bit-vector actions';
    this.bumpRevision();
  }

  registerCheckpointTag(): void {
    const duplicateTag = this.seed.watchTags.length > 0 ? this.seed.watchTags[0] : 'tag-seed';
    let result: boolean = false;
    try {
      result = this.watchTagSet.add(duplicateTag);
    } catch (err) {
      this.lastActionNote = `HashSet.add failed: ${JSON.stringify(err)}`;
      this.bumpRevision();
      return;
    }
    this.lastActionNote = result
      ? `HashSet.add inserted ${duplicateTag}`
      : `HashSet.add blocked duplicate ${duplicateTag}`;
    this.bumpRevision();
  }

  registerWatcher(): void {
    const watcherId = this.seed.activeZones.length > 1 ? `watch-${this.seed.activeZones[1]}` : 'watch-default';
    let result: boolean = false;
    try {
      result = this.watcherSet.add(watcherId);
    } catch (err) {
      this.lastActionNote = `LightWeightSet.add failed: ${JSON.stringify(err)}`;
      this.bumpRevision();
      return;
    }
    this.lastActionNote = result
      ? `LightWeightSet.add inserted ${watcherId}`
      : `LightWeightSet.add blocked duplicate ${watcherId}`;
    this.bumpRevision();
  }

  rebuildSortedCheckpointIndex(): void {
    const candidate = this.items.find((item: CheckpointItem) => item.priority === CheckpointPriority.HIGH);
    const key = candidate ? `${candidate.id}@S${candidate.slot}` : 'CP-000@S0';
    let result: boolean = false;
    try {
      result = this.sortedCheckpointSet.add(key);
    } catch (err) {
      this.lastActionNote = `TreeSet.add failed: ${JSON.stringify(err)}`;
      this.bumpRevision();
      return;
    }
    this.lastActionNote = result
      ? `TreeSet.add inserted ${key}`
      : `TreeSet.add kept sorted set unchanged for ${key}`;
    this.bumpRevision();
  }

  syncSlotZoneMap(): void {
    const nextItem = this.items[0];
    if (!nextItem) {
      this.lastActionNote = 'LightWeightMap.set skipped: no checkpoint item';
      this.bumpRevision();
      return;
    }
    try {
      this.slotZoneMap.set(nextItem.slot, `${nextItem.zone} • reviewed`);
    } catch (err) {
      this.lastActionNote = `LightWeightMap.set failed: ${JSON.stringify(err)}`;
      this.bumpRevision();
      return;
    }
    this.lastActionNote = `LightWeightMap.set stored slot ${nextItem.slot}`;
    this.bumpRevision();
  }

  syncTreeReviewMap(): void {
    const firstItem = this.items[0];
    if (!firstItem) {
      this.lastActionNote = 'TreeMap.set skipped: no checkpoint item';
      this.bumpRevision();
      return;
    }
    try {
      this.syncReviewTree.set(firstItem.id, `${firstItem.status} • synced`);
    } catch (err) {
      this.lastActionNote = `TreeMap.set failed: ${JSON.stringify(err)}`;
      this.bumpRevision();
      return;
    }
    this.lastActionNote = `TreeMap.set wrote sorted sync key ${firstItem.id}`;
    this.bumpRevision();
  }

  updateSparseSlotValue(): void {
    if (this.sparseSlotArray.length === 0) {
      this.lastActionNote = 'PlainArray.setValueAt skipped: sparse array empty';
      this.bumpRevision();
      return;
    }
    try {
      this.sparseSlotArray.setValueAt(0, 'slot-state:rechecked');
    } catch (err) {
      this.lastActionNote = `PlainArray.setValueAt failed: ${JSON.stringify(err)}`;
      this.bumpRevision();
      return;
    }
    this.lastActionNote = 'PlainArray.setValueAt updated sparse index 0';
    this.bumpRevision();
  }

  markAllSlotsOccupied(): void {
    try {
      this.occupiedFlags.setAllBits(1);
      this.occupiedFlagState = 1;
    } catch (err) {
      this.lastActionNote = `BitVector.setAllBits failed: ${JSON.stringify(err)}`;
      this.bumpRevision();
      return;
    }
    this.lastActionNote = 'BitVector.setAllBits marked all board slots occupied';
    this.bumpRevision();
  }

  clearAllSlotFlags(): void {
    try {
      this.occupiedFlags.setAllBits(0);
      this.occupiedFlagState = 0;
    } catch (err) {
      this.lastActionNote = `BitVector.setAllBits clear failed: ${JSON.stringify(err)}`;
      this.bumpRevision();
      return;
    }
    this.lastActionNote = 'BitVector.setAllBits cleared all board slots';
    this.bumpRevision();
  }

  private bumpRevision(): void {
    this.revision += 1;
  }

  private formatItemCard(item: CheckpointItem): string {
    return `${item.id}@S${item.slot}`;
  }

  private getReviewTail(): string {
    if (this.reviewDeque.length === 0) {
      return 'empty';
    }
    try {
      return this.reviewDeque.getLast();
    } catch (err) {
      return `error:${JSON.stringify(err)}`;
    }
  }

  private joinQueue(queue: Queue<string>): string {
    const values: string[] = [];
    try {
      queue.forEach((value: string) => {
        values.push(value);
      });
    } catch (err) {
      return `error:${JSON.stringify(err)}`;
    }
    return this.joinValues(values);
  }

  private joinArrayList(list: ArrayList<string>): string {
    const values: string[] = [];
    try {
      list.forEach((value: string) => {
        values.push(value);
      });
    } catch (err) {
      return `error:${JSON.stringify(err)}`;
    }
    return this.joinValues(values);
  }

  private joinLinkedList(list: LinkedList<string>): string {
    const values: string[] = [];
    try {
      list.forEach((value: string) => {
        values.push(value);
      });
    } catch (err) {
      return `error:${JSON.stringify(err)}`;
    }
    return this.joinValues(values);
  }

  private joinList(list: List<string>): string {
    const values: string[] = [];
    try {
      list.forEach((value: string) => {
        values.push(value);
      });
    } catch (err) {
      return `error:${JSON.stringify(err)}`;
    }
    return this.joinValues(values);
  }

  private isResolvedStackEmpty(): boolean {
    try {
      return this.resolvedStack.isEmpty();
    } catch (err) {
      console.error(`Failed Stack.isEmpty check: ${JSON.stringify(err)}`);
      return true;
    }
  }

  private seedRegistryCollections(): void {
    this.seed.watchTags.forEach((tag: string) => {
      try {
        this.watchTagSet.add(tag);
      } catch (err) {
        console.error(`Failed to seed HashSet.add: ${JSON.stringify(err)}`);
      }
    });

    this.seed.activeZones.forEach((zone: string) => {
      try {
        this.watcherSet.add(`watch-${zone}`);
      } catch (err) {
        console.error(`Failed to seed LightWeightSet.add: ${JSON.stringify(err)}`);
      }
    });

    this.items.forEach((item: CheckpointItem) => {
      try {
        const sortedLabel = `${item.id}@S${item.slot}`;
        this.sortedCheckpointSet.add(sortedLabel);
        this.slotZoneMap.set(item.slot, item.zone);
        this.syncReviewTree.set(item.id, `${item.priority}/${item.status}`);
      } catch (err) {
        console.error(`Failed to seed tree/map collections: ${JSON.stringify(err)}`);
      }
    });

    this.seed.occupiedSlots.forEach((slot: number) => {
      try {
        this.sparseSlotArray.add(slot, `slot-${slot}:occupied`);
      } catch (err) {
        console.error(`Failed to seed PlainArray: ${JSON.stringify(err)}`);
      }
    });

    try {
      this.occupiedFlags.setAllBits(0);
      this.occupiedFlagState = 0;
    } catch (err) {
      console.error(`Failed to reset BitVector flags: ${JSON.stringify(err)}`);
    }
  }

  private joinHashSet(set: HashSet<string>): string {
    const values: string[] = [];
    try {
      set.forEach((value: string) => {
        values.push(value);
      });
    } catch (err) {
      return `error:${JSON.stringify(err)}`;
    }
    return this.joinValues(values);
  }

  private joinLightWeightSet(set: LightWeightSet<string>): string {
    const values: string[] = [];
    try {
      set.forEach((value: string) => {
        values.push(value);
      });
    } catch (err) {
      return `error:${JSON.stringify(err)}`;
    }
    return this.joinValues(values);
  }

  private joinTreeSet(set: TreeSet<string>): string {
    const values: string[] = [];
    try {
      set.forEach((value: string) => {
        values.push(value);
      });
    } catch (err) {
      return `error:${JSON.stringify(err)}`;
    }
    return this.joinValues(values);
  }

  private joinLightWeightMap(map: LightWeightMap<number, string>): string {
    const values: string[] = [];
    try {
      map.forEach((value: string, key: number) => {
        values.push(`S${key}:${value}`);
      });
    } catch (err) {
      return `error:${JSON.stringify(err)}`;
    }
    return this.joinValues(values);
  }

  private joinTreeMap(map: TreeMap<string, string>): string {
    const values: string[] = [];
    try {
      map.forEach((value: string, key: string) => {
        values.push(`${key}:${value}`);
      });
    } catch (err) {
      return `error:${JSON.stringify(err)}`;
    }
    return this.joinValues(values);
  }

  private joinPlainArray(array: PlainArray<string>): string {
    const values: string[] = [];
    try {
      for (let i = 0; i < array.length; i += 1) {
        values.push(`S${array.getKeyAt(i)}:${array.getValueAt(i)}`);
      }
    } catch (err) {
      return `error:${JSON.stringify(err)}`;
    }
    return this.joinValues(values);
  }

  private joinValues(values: string[]): string {
    if (values.length === 0) {
      return 'empty';
    }
    if (values.length <= 3) {
      return values.join(' · ');
    }
    return `${values[0]} · ${values[1]} · +${values.length - 2}`;
  }
}

export const checkpointBoardService = CheckpointBoardService.getInstance();
