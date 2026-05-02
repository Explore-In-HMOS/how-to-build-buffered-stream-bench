export enum CheckpointPriority {
  HIGH = 'HIGH',
  MEDIUM = 'MEDIUM',
  LOW = 'LOW'
}

export enum CheckpointStatus {
  PENDING = 'PENDING',
  IN_REVIEW = 'IN_REVIEW',
  RESOLVED = 'RESOLVED'
}

export interface CheckpointItem {
  id: string
  title: string
  slot: number
  zone: string
  status: CheckpointStatus
  priority: CheckpointPriority
}

export interface ShiftSummary {
  shiftLabel: string
  totalItems: number
  pendingItems: number
  inReviewItems: number
  resolvedItems: number
  occupiedSlotCount: number
}

export interface CheckpointSeed {
  shiftId: string
  shiftLabel: string
  items: CheckpointItem[]
  occupiedSlots: number[]
  activeZones: string[]
  watchTags: string[]
}

export interface WorkflowSnapshot {
  intakeQueuePreview: string
  intakeQueueCount: number
  reviewTail: string
  reviewDequeCount: number
  timelinePreview: string
  timelineCount: number
  linkedSequencePreview: string
  linkedSequenceCount: number
  statusListPreview: string
  statusListCount: number
  resolvedStackEmpty: boolean
  resolvedStackCount: number
}

export interface RegistrySnapshot {
  hashTagCount: number
  hashTagPreview: string
  watcherCount: number
  watcherPreview: string
  treeCheckpointCount: number
  treeCheckpointPreview: string
  slotZoneCount: number
  slotZonePreview: string
  syncTreeCount: number
  syncTreePreview: string
  plainArrayCount: number
  plainArrayPreview: string
  occupiedFlagPreview: string
  occupiedFlagState: number
}
