
# Exercises


## Basic Exercises

- Create a single disk Zpool with disk `/disks/disk0`. Now destroy it.
- Create a Zpool with disk `/disks/disk0` through `/disks/disk2`.
- Craete a ZFS filesystem in the Zpool you just created.
   - _Hints:_
      - _Use `zfs set canmount=off ZPOOL_NAME` to disable the mountpoint on the Zpool itself._
      - _...and try `zfs create` to create a ZFS filesystem under the Zpool._
- <a href="exercise-answers/1_BASIC_EXERCISES.md">Answers</a>


## Less Basic Exercises

- Create a mirrored Zpool with disks `/disks/disk0` and `/disks/disk1`.
   - _Hint: You should only have two disks in a mirrored Zpool._
- Create a RAID5/RAIDZ Zpool with disks `/disks/disk0` through `/disks/disk2`.
   - _Hint: You should have at least 3 disks._
- Create a RAID6/RAIDZ2 Zpool with disks `/disks/disk0` through `/disks/disk3`.
   - _Hint: You should have at least 4 disks._
- Create a RAID7/RAIDZ3 Zpool with disks `/disks/disk0` through `/disks/disk4`.
   - _Hint: You should have at least 5 disks._
- <a href="exercise-answers/2_LESS_BASIC_EXERCISES.md">Answers</a>
  
 
## Simulating Hardware Failure

- Created a mirrored Zpool called `zfspool`, remove `/disks/disk0`, catch the error in ZFS and fix it.
   - _Hints_: 
     - _You can't `rm` a disk file because it won't unlink the innode. _
     - _Instead, truncate it to zero bytes with `echo > /disks/disk0`._
- Repeat the previous exercise, but test that files are unharmed
   - _Hints_: 
      - Run `populate-zfs-filesystem /zfspool/` to create sample files
      - Run `sha1-save-files /zfspool/` to save SHA1 hashes of those files before simulating failure
      - After recovery, run `sha1-check-files` to verify that file contents were unharmed


## Simulating Disk Corruption

- Create a RAIDZ Zpool with 3 disks, corrupt `disk0`, catch the error in ZFS, and repair the pool. Verify the files are unaffected.
   - _Hints:_
      - _Run `sha1-save-files /path/to/zfs/filesystem` to save the SHA1s of all files._
      - _Try corrupting a disk with: `corrupt --offset 1000 --num 1000000 /disks/disk0`.  This will swiss-cheese the disk in about 40 seconds._
      - _Run `sha1-check-files /path/to/zfs/filesystem` to catch corrupted files and verify the repairs were successful._


## Breaking RAIDZ

- Create a RAIDZ Zpool with 3 disks, corrupt `disk0` and `disk1`.  Verify the Zpool is unrecoverable.


## Future Exercise Ideas

- Disk quotas for ZFS filesystems
- Play with snapshots and rollbacks.
- Create a raw device in the Zpool and put ext4 on it.
- Create exercises involving RAIDZ2 and RAIDZ3
- Look into some more advanced features of ZFS and create exercises based on them.
- Stream one ZFS filessytem to another



