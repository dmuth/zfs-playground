

# Simulating Hardware Failure Exercise Answers


- Create an unmirroed Zpool called `zfspool`, remove `/disks/disk0`, catch the error in ZFS, confirm that the pool is utterly broken and that your files are unrecoverable.
   - Create the zpool:
      - `zpool create zfspool /disks/disk0 /disks/disk1`
      - `populate-zfs-filesystem /zfspool/ 5 5`
      - `sha1-check-files /zfspool/` - Initial check
      - `zpool status` - Verify state is `ONLINE`
   - Break the disk:
      - Simulate breaking the disk with the command `break-disk disk0`
      - `zpool scrub zfspool` - Watch this hang so hard that even `ctrl-C` can't break out of it.
      - `zpool status` - Run this in another SSH session, watch it too hang and be immune to `ctrl-C`.
      - Run `vagrant halt -f && vagrant up` in another shell to kill and restart the VM, then `vagrant ssh` back in.
      - Run `zpool status` and see that no pools are available.
      - Enjoy this valuable learning experience about just how quickly you can lose all of your files on a Zpool with no redundancy.
   - Run `zfs-add-disk-file disk0 1024` to re-create the corrupted disk for the next exercise.


- Created a mirrored Zpool called `zfspool`, remove `/disks/disk0`, catch the error in ZFS, fix the pool, verify that files are unharmed.
   - Create the zpool:
      - `zpool create zfspool mirror /disks/disk0 /disks/disk1`
      - `populate-zfs-filesystem /zfspool/ 5 5`
      - `sha1-check-files /zfspool/` - Initial check
      - `zpool status` - Verify state is `ONLINE`
   - Break the disk:
      - Simulate breaking the disk with the command `break-disk disk0`
      - `zpool scrub zfspool` - This completes quickly, and will catch the error
      - `zpool status` - `disk0` now shows as `DEGRADED`
      - `sha1-check-files /zfspool/` - Confirm files aren't corrupted
   - Replace the disk (option 1, add in a new disk):
      - `zpool replace zfspool /disks/disk0 /disks/disk2`
      - `zpool status` - `disk0` has been removed from the pool, `disk2` is now online
      - `sha1-check-files /zfspool/` - Verify that the files are unharmed
   - Replace the disk (option 2, replace the existing disk):
      - `zfs-add-disk-file disk0 1024` - Simulate replacing the physical disk
      - `zpool replace zfspool /disks/disk0`
      - `zpool status` - `disk0` is back!
      - `sha1-check-files /zfspool/` - Verify that the files are unharmed
   - Run `zfs-add-disk-file disk0 1024` to (re)create the `disk0` file when done with this exercise

