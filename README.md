Install ArchLinux in a VM for server usage
==========================================

This project automates the deployment of an ArchLinux OS instance onto a VM, using Ansible.

It produces a very simple system, with:

- a single EXT4 partition,
- a Swap file,
- a SSH server
- a root user
- a regular user with passwordless sudo access

It can also be used to deploy Arch onto a bare-metal machine, but the simple configuration
makes it more suitable to cloud deployments.

The installation procedure is controlled remotely from a Linux host with a working Ansible installation.

The controller machine is NOT required to execute Arch.

Machine startup
---------------

A very minimal provisioning of the target machine is required prior to the installation:

Prepare a machine, or create a VM with:
- A x86_64 processor
- A CD-ROM drive with the Archlinux Install CD image
- A physical or virtual drive to be installed onto
- A network interface with access to Internet, and accessible from the controller machine.

Start the machine, up to the command line prompt.

In the machine console, make sure it has an IP address and note it down into the file `inventory.yaml`
in the `ansible_host` parameter.

Then type the following:

````bash
# passwd
<THE ROOT PASSWORD>
# systemctl start sshd
````

Installation procedure
----------------------

On the Ansible controller machine, execute the script `01-bootstrap-ssh.sh`.
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

Look for `hda`, `sda` or `vda`... and configure the `target_drive` value in the inventory.

Also configure the other configuration parameters in the inventory file.

On the controller machine, execute the installation script:

````bash
$ ./02-install.sh
````

Power off the target machine and remove the installation medium to be sure that it will boot
on the hard drive from now on.

If it's a VM, it's a good idea to take a snapshot or a copy of the drive image, so you can start from
this base image to customize the later steps.


Personalization stage
---------------------

Extra scripts allow to personalize the machine to fit its intended purpose.

- `03-cloud-init.sh`: Prepare the machine to be configurable using Cloud-init.
- `03-docker.sh`: Install docker.
- `03-arch-develop.sh`: prepare the system to allow the development of Arch packages.
- `03-libvirt.sh`: Install libvirt and QEMU-KVM virtualization solution.
- `03-kubernetes.sh`: Install a kubernetes platform.
- `03-jenkins-node.sh`: Setup the machine as a Jenkins slave node.





