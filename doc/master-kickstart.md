# Selinux is a pre-requisite
selinux --enforcing

# System authorization information
auth --enableshadow --passalgo=sha512

# Installation media
cdrom

# Use text install
text

# Keyboard layouts
keyboard --vckeymap=it --xlayouts='it'

# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=eno16780032 --onboot=off --ipv6=auto
network  --hostname=localhost.localdomain

# Root password
rootpw --iscrypted $6$BQGRmO8Nhi6QAzCF$Z9g5AujasPiY4Pm1nBMW9uYYu4f9SHYKihYij5Qs8c0flNY1JXHnzhYWkiNe5w9tbACm/Vw3L2bkxUJN62SIa0

# System timezone
timezone Europe/Rome --isUtc --nontp

# Force use sda
ignoredisk --only-use=sda

# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda

# Partition clearing information
clearpart --none --initlabel

# Disk partitioning information
# Example disk suggested for node is 150G (used 143G based on that partitioning)
part pv.1 --fstype="lvmpv" --ondisk=sda --size=61440
part pv.2 --fstype="lvmpv" --ondisk=sda --size=81920
part /boot --fstype="xfs" --ondisk=sda --size=512

volgroup vg00 --pesize=4096 pv.1
volgroup vg01 --pesize=4096 pv.2

logvol /var/crash  --fstype="xfs" --size=4096 --name=lv_kdump --vgname=vg00
logvol /  --fstype="xfs" --size=8192 --name=lv_root --vgname=vg00
logvol /var  --fstype="xfs" --size=10240 --name=lv_var --vgname=vg00
logvol /var/log --fstype="xfs" --size=20480 --name=lv_var_log --vgname=vg00
logvol /opt  --fstype="xfs" --size=1024 --name=lv_opt --vgname=vg00
logvol /usr  --fstype="xfs" --size=10240 --name=lv_usr --vgname=vg00
logvol /home  --fstype="xfs" --size=1024 --name=lv_home --vgname=vg00
logvol /tmp  --fstype="xfs" --size=6144 --name=lv_tmp --vgname=vg00
logvol /var/lib/docker --fstype="xfs" --size=61440 --name=lv_lib_docker --vgname=vg01
logvol /var/lib/origin/openshift.local.volumes --fstype="xfs" --size=20480 --name=lv_lib_ocp_vol --vgname=vg01 --fsoptions=defaults,grpquota

%packages
@^minimal
@compat-libraries
@core
@development
NetworkManager
wget
git
net-tools
bind-utils
yum-utils
iptables-services
bridge-utils
bash-completion
kexec-tools
sos
psacct

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end
