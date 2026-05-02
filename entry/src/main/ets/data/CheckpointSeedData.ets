import { CheckpointItem, CheckpointPriority, CheckpointSeed, CheckpointStatus } from '../models/CheckpointModels';

export function createCheckpointSeed(): CheckpointSeed {
  const items: CheckpointItem[] = [
    {
      id: 'CP-101',
      title: 'North Gate Sensor Drift',
      slot: 2,
      zone: 'North',
      status: CheckpointStatus.PENDING,
      priority: CheckpointPriority.HIGH
    },
    {
      id: 'CP-102',
      title: 'Bridge Cam Focus Check',
      slot: 7,
      zone: 'East',
      status: CheckpointStatus.IN_REVIEW,
      priority: CheckpointPriority.MEDIUM
    },
    {
      id: 'CP-103',
      title: 'Dock Access Log Match',
      slot: 11,
      zone: 'West',
      status: CheckpointStatus.RESOLVED,
      priority: CheckpointPriority.LOW
    },
    {
      id: 'CP-104',
      title: 'Roof Beacon Battery Swap',
      slot: 14,
      zone: 'South',
      status: CheckpointStatus.PENDING,
      priority: CheckpointPriority.HIGH
    }
  ];

  return {
    shiftId: 'SHIFT-A',
    shiftLabel: 'Night Shift A',
    items: items,
    occupiedSlots: [2, 7, 11, 14],
    activeZones: ['North', 'East', 'West', 'South'],
    watchTags: ['sensor', 'camera', 'access', 'power']
  };
}
