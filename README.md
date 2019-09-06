Install ArchLinux in a VM for server usage
==========================================

This project automates the deployment of an ArchLinux OS instance onto a VM, using Ansible.

It is inspired by Van Nguyen's blog post: https://shirotech.com/linux/how-to-automate-arch-linux-installation/

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
in the `ansible_host` parameter of the section `liveinstall_run`.

Then type the following:

```bash
# passwd
<THE ROOT PASSWORD>
# systemctl start sshd
```

Installation from the live install drive
----------------------------------------

On the Ansible controller machine, execute the script `01-bootstrap-liveinstall-ssh`.
It will ask for the target's root password entered in the previous step.

Verify that the operation was successful by connecting remotely using ssh from the 
controller machine:

```bash
$ ssh root@<TARGET IP ADDRESS>
```

Check the location of the hard disk drive:

```bash
# lsblk
NAME  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0   7:0    0 509.6M  1 loop /run/archiso/sfs/airootfs
sr0    11:0    1   623M  0 rom  /run/archiso/bootmnt
vda   254:0    0    20G  0 disk 
```

Look for `hda`, `sda` or `vda`... and configure the `target_drive` value in the inventory.

Also configure the other configuration parameters in the inventory file.

Be careful to choose at least:
- a network address mode (`network_mode` parameter).
- network addresses configuration (other `network_...` parameters)

On the controller machine, execute the installation script:

```bash
$ ./02-install
```

Power off the target machine and remove the installation medium to be sure that it will boot
on the hard drive from now on.

After reboot, the machine starts on the target drive, with the configured network settings,
and with a new SSH key.

To make sure the controller machine can SSH to it, run:

```bash
$ ./03-bootstrap-target-ssh
```

Configuration steps on the production machine
---------------------------------------------

Before any other steps, we recommend to reclaim some space by running `04-cleanup`.
It will remove the Pacman package cache, and trim/discard the unused filesystem space.

If it's a QEMU-KVM virtual machine with a QCOW2 volume file, the discarded space can be actually reclaimed
from the QCOW2 file using this command (the machine must be shut down first):

```bash
$ mv IMAGE-FILE.qcow2 IMAGE-FILE-backup.qcow2
$ qemu-img convert -O qcow2 IMAGE-FILE-backup.qcow2 IMAGE-FILE.qcow2
```

If it's a VM, it's a good idea to take a snapshot or a copy of the drive image, so you can start from
this base image to customize the later steps.

Extra scripts allow to personalize the machine to fit its intended purpose.

- `04-cleanup`: Cleanup pacman cache and trim filesystem. This can be executed anytime.
- `04-docker`: Install docker.
- `04-yocto`: Setup Yocto development platform.

Future scripts (not implemented yet):

- `04-cloud-init`: Prepare the machine to be configurable using Cloud-init.
- `04-arch-develop`: prepare the system to allow the development of Arch packages.
- `04-libvirt`: Install libvirt and QEMU-KVM virtualization solution.
- `04-kubernetes`: Install a kubernetes platform.
- `04-jenkins-node`: Setup the machine as a Jenkins slave node.

The scripts above may be combined. For instance if I need a Jenkins node to produce Docker images,
I may run both `04-docker` and `04-jenkins-node`.
