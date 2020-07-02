
# Basic Exercise Answers

- Create a single disk Zpool with disk `/disks/disk0`. Now destroy it.
   - `zpool create zfspool /disks/disk0`
   - `zpool list`
   - `zpool destroy zfspool`
   - `zpool list`
- Create a Zpool with disk `/disks/disk0` through `/disks/disk2`.
   - `zpool create zfspool /disks/disk0 /disks/disk1 /disks/disk2`
   - `zpool list`
- Craete a ZFS filesystem in the Zpool you just created.
   - `zfs set canmount=off zfspool`
   - `df -h`
   - `zfs create zfspool/lab1`
   - `df -h`


