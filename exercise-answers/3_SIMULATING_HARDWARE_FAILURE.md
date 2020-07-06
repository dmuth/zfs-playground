

## Simulating Hardware Failure

- Created a mirrored Zpool called `zfspool`, remove `/disks/disk0`, catch the error in ZFS, fix the pool, verify that files are unharmed.
   - _Hints_: 
      - Run `populate-zfs-filesystem /zfspool/ 5 5` to create sample files in the ZFS filesystem and save SHA1 hashes of those files.
     - _You can't `rm` a disk file because it won't unlink the inode. _Instead, truncate it to zero bytes with `echo "CORRUPT" > /disks/disk0`._
      - After recovery, run `sha1-check-files /zfspool/` to verify that file contents were unharmed
      - Run `zfs-add-disk-file disk0 1024` to (re)create the `disk0` file when done with this exercise
   - Create the zpool:
      - `zpool create zfspool mirror /disks/disk0 /disks/disk1`
      - `populate-zfs-filesystem /zfspool/ 5 5`
      - `sha1-check-files /zfspool/` - Initial check
      - `zpool status` - Verify state is `ONLINE`
   - Break the disk:
      - `echo "CORRUPT" > /disks/disk0` - Break `disk0`
      - `zpool scrub zfspool` - This completely quickly, and will catch the error
      - `zpool status` - `disk0` now shows as `DEGRADED`
      - `sha1-check-files /zfspool/` - Confirm files aren't corrupted
   - Replace the disk (option 1, add in a new disk):
      - `zpool replace zfspool /disks/disk0 /disks/disk2`
      - `zpool status` - `disk0` has been removed from the pool, `disk2` is now online
      - `sha1-check-files /zfspool/` - Verify that the files are unharmed
      - Run `zfs-add-disk-file disk0 1024` to (re)create the `disk0` file when done with this exercise
   - Replace the disk (option 2, replace the existing disk):
      - `zfs-add-disk-file disk0 1024` - Simulate replacing the physical disk
      - `zpool replace zfspool /disks/disk0`
      - `zpool status` - `disk0` is back!
      - `sha1-check-files /zfspool/` - Verify that the files are unharmed

