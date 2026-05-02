import { describe, beforeAll, beforeEach, it, expect } from '@ohos/hypium';
import { checkpointBoardService } from '../main/ets/services/CheckpointBoardService';

export default function localUnitTest() {
  describe('CheckpointBoardService transitions', () => {
    beforeAll(() => {
      checkpointBoardService.reseed();
    });

    beforeEach(() => {
      checkpointBoardService.reseed();
    });

    it('loads deterministic seed summary and workflow snapshots', 0, () => {
      const summary = checkpointBoardService.getSummary();
      const workflow = checkpointBoardService.getWorkflowSnapshot();
      const registry = checkpointBoardService.getRegistrySnapshot();

      expect(summary.shiftLabel).assertEqual('Night Shift A');
      expect(summary.totalItems).assertEqual(4);
      expect(summary.pendingItems).assertEqual(2);
      expect(summary.inReviewItems).assertEqual(1);
      expect(summary.resolvedItems).assertEqual(1);
      expect(workflow.intakeQueueCount).assertEqual(4);
      expect(workflow.resolvedStackEmpty).assertEqual(false);
      expect(registry.hashTagCount).assertEqual(4);
      expect(registry.watcherCount).assertEqual(4);
      expect(registry.occupiedFlagState).assertEqual(0);
    });

    it('moves one pending checkpoint into review intake', 0, () => {
      const beforeSummary = checkpointBoardService.getSummary();
      const beforeWorkflow = checkpointBoardService.getWorkflowSnapshot();

      checkpointBoardService.intakeNextPendingCheckpoint();

      const afterSummary = checkpointBoardService.getSummary();
      const afterWorkflow = checkpointBoardService.getWorkflowSnapshot();

      expect(afterSummary.pendingItems).assertEqual(beforeSummary.pendingItems - 1);
      expect(afterSummary.inReviewItems).assertEqual(beforeSummary.inReviewItems + 1);
      expect(afterWorkflow.intakeQueueCount).assertEqual(beforeWorkflow.intakeQueueCount + 1);
      expect(checkpointBoardService.getLastActionNote()).assertContain('Queue.add');
    });

    it('keeps HashSet and LightWeightSet deduped on duplicate inserts', 0, () => {
      const beforeRegistry = checkpointBoardService.getRegistrySnapshot();

      checkpointBoardService.registerCheckpointTag();
      checkpointBoardService.registerWatcher();

      const afterRegistry = checkpointBoardService.getRegistrySnapshot();
      expect(afterRegistry.hashTagCount).assertEqual(beforeRegistry.hashTagCount);
      expect(afterRegistry.watcherCount).assertEqual(beforeRegistry.watcherCount);
      expect(checkpointBoardService.getLastActionNote()).assertContain('blocked duplicate');
    });

    it('updates registry maps and flips bit flags', 0, () => {
      checkpointBoardService.syncSlotZoneMap();
      checkpointBoardService.syncTreeReviewMap();
      checkpointBoardService.updateSparseSlotValue();
      checkpointBoardService.markAllSlotsOccupied();

      const registry = checkpointBoardService.getRegistrySnapshot();
      expect(registry.slotZonePreview).assertContain('reviewed');
      expect(registry.syncTreePreview).assertContain('synced');
      expect(registry.plainArrayPreview).assertContain('slot-state:rechecked');
      expect(registry.occupiedFlagState).assertEqual(1);

      checkpointBoardService.clearAllSlotFlags();
      expect(checkpointBoardService.getRegistrySnapshot().occupiedFlagState).assertEqual(0);
    });

    it('tracks stack empty-state transitions after resolution operations', 0, () => {
      const beforeWorkflow = checkpointBoardService.getWorkflowSnapshot();
      checkpointBoardService.resolveReviewTail();
      const afterWorkflow = checkpointBoardService.getWorkflowSnapshot();

      expect(afterWorkflow.resolvedStackCount).assertEqual(beforeWorkflow.resolvedStackCount + 1);
      expect(afterWorkflow.resolvedStackEmpty).assertEqual(false);
      expect(checkpointBoardService.getLastActionNote()).assertContain('Stack.isEmpty=');
    });
  });
}
