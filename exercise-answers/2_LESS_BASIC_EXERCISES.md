
# Less Basic Exercise Answers

- Create a mirrored Zpool with disks `/disks/disk0` and `/disks/disk1`.
   - `zpool create zfspool mirror /disks/disk0 /disks/disk1`
   - `zpool status` should show a vdev called `mirror-0`
   - `zpool destroy zfspool`
- Create a RAID5/RAIDZ Zpool with disks `/disks/disk0` through `/disks/disk2`.
   - `zpool create zfspool raidz /disks/disk0 /disks/disk1 /disks/disk2`
   - `zpool status` should show a vdev called `raidz1-0`
- Create a RAID6/RAIDZ2 Zpool with disks `/disks/disk0` through `/disks/disk3`.
   - `zpool create zfspool raidz2 /disks/disk0 /disks/disk1 /disks/disk2 /disks/disk3`
   - `zpool status` should show a vdev called `raidz2-0`
   - `zpool destroy zfspool`
- Create a RAID7/RAIDZ3 Zpool with disks `/disks/disk0` through `/disks/disk4`.
   - `zpool create zfspool raidz3 /disks/disk0 /disks/disk1 /disks/disk2 /disks/disk3 /disks/disk4`
   - `zpool status` should show a vdev called `raidz3-0`
   - `zpool destroy zfspool`


