
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
   - _Hints:_
      - _Use `zfs set canmount=off ZPOOL_NAME` to disable the mountpoint on the Zpool itself._
      - _...and try `zfs create` to create a ZFS filesystem under the Zpool._
   - `zfs set canmount=off zfspool`
   - `df -h`
   - `zfs create zfspool/lab1`
   - `df -h`


