

# Simulating Disk Corruption Exercise Answers

- Create a RAIDZ Zpool with 3 disks, corrupt `disk0`, catch the error in ZFS, and repair the pool. Verify the files are unaffected.
   - Create the zpool:
      - `zpool create zfspool raidz /disks/disk0 /disks/disk1 /disks/disk2`
      - `populate-zfs-filesystem /zfspool/ 5 5`
      - `sha1-check-files /zfspool/` - Initial check
      - `zpool status` - Verify state is `ONLINE`
   - Break the disk:
      - `corrupt --offset 1000 --repeat 1000000 /disks/disk0`
      - `zpool scrub zfspool` - This completes quickly, and will catch the error
      - `zpool status` - `disk0` now shows as `DEGRADED` and `too many errors`
      - `sha1-check-files /zfspool/` - Confirm files aren't corrupted
   - Replace the disk (option 1, add in a new disk):
      - `zpool replace zfspool /disks/disk0 /disks/disk3`
      - `zpool status` - `disk0` has been removed from the pool, `disk2` is now online
      - `sha1-check-files /zfspool/` - Verify that the files are unharmed
   - Replace the disk (option 2, replace the existing disk):
      - `rm /disks/disk0` - Simulate removing a physical disk.
      - `zfs-add-disk-file disk0 1024` - Simulate adding a new physical disk
      - `zpool replace zfspool /disks/disk0`
      - `zpool status` - `disk0` is back!
      - `zpool scrub` - Just a good idea
      - `sha1-check-files /zfspool/` - Verify that the files are unharmed


