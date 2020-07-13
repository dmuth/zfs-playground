
<img src="./img/zfs-playground-logo.png" align="right" />

# ZFS Playground

ZFS testing environment where disk failures and data corruption can be simulated

## Quick Start

- Clone this repo
- `vagrant up` - This will create a VM with 2 cores and 1 GB of RAM.
	- 10 1 GB virtual disks will be created in the directory `/disks/`.
- `vagrant ssh` - All scripts are in `/vagrant/bin/` which is in the $PATH.
- Optionally run `zfs-lab-create` to create a ZFS pool and filesystem in `/zfs/lab1/`.


## Utilities

This repo ships with a number of utilities to automate and semi-automate work related to playing
around with ZFS.  All scripts are in `/vagrant/bin/` in the VM which is also in your path:

- `create` - Create a sample file full of X's.  Useful for testing file corruption as the corruption will be obvious when viewing it with `less`.
- `corrupt` - Corrupt a file at a certain offset with a certain character for a certain length, optionally repeated a certain number of times.  Useful for running against disks in `/disks/` to simulate disk corruption.
- `populate-zfs-filesystem` - Uses `create` to populate a target directory with a series of files and directories with 1 MB files.  Useful for testing files for corrption when corrupting a ZFS disk.
- `sha1-save-files` - Compute SHA1 hashes recursively of a directory and its files and save the files in `/data/`.
- `sha1-check-files` - Check against previously computed hashes recursively and look for corruption. Output is written in `diff` format.
- `truncate-disk` - Used to truncate a specific disk image to a specific number of bytes.  Useful to simulate disk failures.
- `zfs-lab-create` - Stand up a ZFS pool in `/zfs/`, a ZFS filesystem in `/zfs/lab1/`, and populate it with files with `populate-zfs-filesystem`.
- `zfs-lab-destroy` - Remove a ZFS pool and filesystem created wiht `zfs-lab-create`.
- Internal Utilities.  These are used by the playground itself but could be useful if you want to change the environment substantially:
   - `zfs-add-disk-file` - Creates a file in `/disks/` which can be added to ZFS as a disk.  Used during provisioning of the Vagrant instance.
   - `zfs-rm-disk-file` - Removes a file created by `zfs-add-disk-file`.
   - `zfs-create-pool` - Create a ZFS pool of disks.  Used by `zfs-lab-create`.
   - `zfs-destroy-pool` - Destroy a ZFS pool of disks.
   - `zfs-destroy-pool-if-exists` - Destory a ZFS pool only if it already exists.


## Exercises to Better Learn ZFS


For all exercises, the Zpool should be called `zfspool`. When the pool is created, a ZFS filesystem will be created mounted to `/zfspool/` by default.


### Basic Exercises

- Create a single disk Zpool with disk `/disks/disk0`. Now destroy it.
- Create a Zpool with disk `/disks/disk0` through `/disks/disk2`.
- Craete a ZFS filesystem in the Zpool you just created.
   - _Hints:_
      - _Use `zfs set canmount=off ZPOOL_NAME` to disable the mountpoint on the Zpool itself._
      - _...and try `zfs create` to create a ZFS filesystem under the Zpool._
- <a href="exercise-answers/1_BASIC_EXERCISES.md">Answers</a>


### Less Basic Exercises

- Create a mirrored Zpool with disks `/disks/disk0` and `/disks/disk1`.
   - _Hint: You should only have two disks in a mirrored Zpool._
- Create a RAID5/RAIDZ Zpool with disks `/disks/disk0` through `/disks/disk2`.
   - _Hint: You should have at least 3 disks._
- Create a RAID6/RAIDZ2 Zpool with disks `/disks/disk0` through `/disks/disk3`.
   - _Hint: You should have at least 4 disks._
- Create a RAID7/RAIDZ3 Zpool with disks `/disks/disk0` through `/disks/disk4`.
   - _Hint: You should have at least 5 disks._
- <a href="exercise-answers/2_LESS_BASIC_EXERCISES.md">Answers</a>
  
 
### Simulating Hardware Failure

- Create an unmirroed Zpool called `zfspool`, remove `/disks/disk0`, catch the error in ZFS, confirm that the pool is utterly broken and that your files are unrecoverable.
   - _Hints_: 
      - Run `populate-zfs-filesystem /zfspool/ 5 5` to create sample files in the ZFS filesystem and save SHA1 hashes of those files.
      - Simulate breaking the disk with the command `break-disk disk0`
      - Run `sha1-check-files` to verify that files are corrupted
      - Run `zfs-add-disk-file disk0 1024` to (re)create the `disk0` file when done with this exercise

- Created a mirrored Zpool called `zfspool`, remove `/disks/disk0`, catch the error in ZFS, fix the pool, verify that files are unharmed.
   - _Hints_: 
      - Run `populate-zfs-filesystem /zfspool/ 5 5` to create sample files in the ZFS filesystem and save SHA1 hashes of those files.
      - Simulate breaking the disk with the command `break-disk disk0`
      - After recovery, run `sha1-check-files` to verify that file contents were unharmed
      - Run `zfs-add-disk-file disk0 1024` to (re)create the `disk0` file when done with this exercise
- <a href="exercise-answers/3_SIMULATING_HARDWARE_FAILURE.md">Answers</a>


### Simulating Disk Corruption

- Create a RAIDZ Zpool with 3 disks, corrupt `disk0`, catch the error in ZFS, and repair the pool. Verify the files are unaffected.
   - _Hints:_
      - Run `populate-zfs-filesystem /zfspool/ 5 5` to create sample files in the ZFS filesystem and save SHA1 hashes of those files.
      - Try corrupting a disk with: `corrupt --offset 1000 --repeat 1000000 /disks/disk0`.  This will swiss-cheese the disk in about a few 10s of seconds.
      - Run `sha1-check-files /path/to/zfs/filesystem` to catch corrupted files and verify the repairs were successful.
- Create a RAIDZ Zpool with 3 disks, corrupt `disk0` and `disk1`.  Verify the Zpool is unrecoverable.
   - _Hints:_
      - Run `populate-zfs-filesystem /zfspool/ 5 5` to create sample files in the ZFS filesystem and save SHA1 hashes of those files.
      - Try corrupting a disk with: `corrupt --offset 1000 --repeat 1000000 /disks/disk0`.  This will swiss-cheese the disk in about a few 10s of seconds.
      - Run `sha1-check-files /path/to/zfs/filesystem` to catch corrupted files and verify that will need to restore from a backup.
- <a href="exercise-answers/4_SIMULATING_DISK_CORRUPTION.md">Answers</a>


### Future Exercise Ideas

- Play with snapshots and rollbacks.
- Disk quotas for ZFS filesystems
- Create a raw device in the Zpool and put ext4 on it. (rollback from a snapshot)
- Stream one ZFS filessytem to another


## FAQ

### Q: Why SHA1 and now SHA512?

A: It's a UI consideration--I want checksums a little smaller, which will be easier to read.  Keep in mind that the context is "simulating a filesystem", versus "code that is being run in production".  But hey--if this is useful enough that you're looking at using this in production(!), come talk to me and I'll see what I can do. :-)


## Credits

- The logo was made over at https://www.freelogodesign.org/
- <a href="http://patorjk.com/software/taag/#p=display&h=0&v=0&f=Big&t=ZFS%0APlayground">This text to ASCII art generator</a>, for the logo I used in the MOTD message.



## Who built this? / Contact

My name is Douglas Muth, and I am a software engineer in Philadelphia, PA.

There are several ways to get in touch with me:
- Email to doug.muth AT gmail DOT com or dmuth AT dmuth DOT org
- [Facebook](https://facebook.com/dmuth) and [Twitter](http://twitter.com/dmuth)
- [LinkedIn](http://localhost:8080/www.linkedin.com/in/dmuth)

Feel free to reach out to me if you have any comments, suggestions, or bug reports.



