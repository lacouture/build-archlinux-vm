Install ArchLinux in a VM for server usage
==========================================

Manual Steps
------------

Create a VM with:
- x86_64 processor
- A CD-ROM drive with the appropriate Archlinux Install CD image
- A virtual drive to be installed onto
- A network interface with access to Internet, and accessible from the controller machine.

Execute this VM.

In the VM console, make sure the VM has an IP address and note it down into the file `inventory.yaml`
in the "ansible_host" parameter.

Then type the following:

````bash
# passwd
<THE ROOT PASSWORD>
# systemctl start sshd
````

Execute the script `01-bootstrap-ssh.sh`.
It will ask for the target's root password entered in the previous step.

Verify that the operation was successful by connecting remotely using ssh from the 
controller machine:

````bash
$ ssh root@<TARGET IP ADDRESS>
````

Check the location of the hard disk drive:

````bash
# lsblk
NAME  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0   7:0    0 509.6M  1 loop /run/archiso/sfs/airootfs
sr0    11:0    1   623M  0 rom  /run/archiso/bootmnt
vda   254:0    0    20G  0 disk 
````

Look for `hda`, `sda` or `vda`... and configure the "target_drive" value in the inventory.

Also configure the other configuration parameters in the inventory file.

On the controller machine, execute the installation script:

````bash
$ ./02-install.sh
````

Power off the target machine and remove the installation medium to be sure that it will boot
on the hard drive from now on.

If it's a VM, it's a good idea to take a snapshot or a copy of the drive image, so you can start from
this base image to customize the later steps.
