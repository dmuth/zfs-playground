
# Exercises


- Basic exercises:
   - Create a single disk Zpool
      - _Hint: Disks are in `/disks/`._
   - Create a Zpool with multiple disks
   - Craete a ZFS filesystem in the Zpool
      - _Hints:_
         - _Use `zfs set canmount=off ZPOOL_NAME` to disable the mountpoint on the Zpool itself._
         - _...and try `zfs create` to create a ZFS filesystem under the Zpool._

- Less basic exercises:
   - Create a mirrored Zpool
     - _Hint: You should only have two disks in a mirrored Zpool._
   - Create a RAID5/RAIDZ Zpool
     - _Hint: You should have at least 3 disks._
   - Create a RAID6/RAIDZ2 Zpool
     - _Hint: You should have at least 4 disks._
   - Create a RAID7/RAIDZ3 Zpool
     - _Hint: You should have at least 5 disks._
   
- Simulating hardware failure:
   - Created a mirrored Zpool, remove `/disks/disk0`, catch the error in ZFS and fix it.
      - _Hints_: 
        - _You can't `rm` a disk file because it won't unlink the innode. _
        - _Instead, truncate it to zero bytes with `echo > /disks/diskNUM`._

- Simulating Disk Corruption
   - Create a RAIDZ Zpool with 3 disks, corrupt `disk0`, catch the error in ZFS, and repair the pool. Verify the files are unaffected.
      - _Hints:_
         - _Run `sha1-save-files /path/to/zfs/filesystem` to save the SHA1s of all files._
         - _Try corrupting a disk with: `corrupt --offset 1000 --num 1000000 /disks/disk0`.  This will swiss-cheese the disk in about 40 seconds._
         - _Run `sha1-check-files /path/to/zfs/filesystem` to catch corrupted files and verify the repairs were successful._

- Breaking RAIDZ
   - Create a RAIDZ Zpool with 3 disks, corrupt `disk0` and `disk1`.  Verify the Zpool is unrecoverable.


## Future Exercise Ideas

- Create a raw device in the Zpool and put ext4 on it.
- Play with snapshots and rollbacks.
- Create exercises involving RAIDZ2 and RAIDZ3
- Look into some more advanced features of ZFS and create exercises based on them.



