
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
- `zfs-lab-create` - Stand up a ZFS pool in `/zfs/`, a ZFS filesystem in `/zfs/lab1/`, and populate it with files with `populate-zfs-filesystem`.
- `zfs-lab-destroy` - Remove a ZFS pool and filesystem created wiht `zfs-lab-create`.
- Internal Utilities.  These are used by the playground itself but could be useful if you want to change the environment substantially:
   - `zfs-add-disk-file` - Creates a file in `/disks/` which can be added to ZFS as a disk.  Used during provisioning of the Vagrant instance.
   - `zfs-rm-disk-file` - Removes a file created by `zfs-add-disk-file`.
   - `zfs-create-pool` - Create a ZFS pool of disks.  Used by `zfs-lab-create`.
   - `zfs-destroy-pool` - Destroy a ZFS pool of disks.
   - `zfs-destroy-pool-if-exists` - Destory a ZFS pool only if it already exists.



## WORK IN PROGRESS

This is still very much a work in progress, and I don't recommend using it yet. :-)

Here are major things I want to build in to make this actually useful for playing around with ZFS:

- ✅ Helper script to add/remove virtual disks
- ✅ Helper script to create some Zpools
- ✅ Helper script to fill a ZFS filesytem with some test files
- ✅ Helper script to get a SHA1 on our Zpools
- ✅ Helper script to get a SHA1 on the filesystem CONTENTS of Zpools
- ✅ Helper script to check SHA1s and ensure that they match
- ✅ Helper script to corrupt specific bytes in virtual disks
- Sample exercises for the user to do, such as creating Zpools, recover from corruption, etc.
- Answers to the sample exercises


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



