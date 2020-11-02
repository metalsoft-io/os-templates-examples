# CentOS releases
 - 8.0-1905
 - 8.1-1911
 - 8.2-2004

## development
inst.repo=http://ro-bucharest-repo.bigstepcloud.com/centos/8.0.1905/AppStream/x86_64/kickstart/
inst.stage2=http://ro-bucharest-repo.bigstepcloud.com/centos/8.0.1905/BaseOS/x86_64/kickstart/
inst.ks=http://repo.vmware.local/.tftp/boot/images/CentOS-8.0.1905/ks-minimal-standard-noFirewalld-pre_and_post_scripts.cfg
--url="http://ro-bucharest-repo.bigstepcloud.com/centos/8.0.1905/BaseOS/x86_64/os/"
--baseurl=http://ro-bucharest-repo.bigstepcloud.com/centos/8.0.1905/BaseOS/x86_64/kickstart/../../../AppStream/x86_64/kickstart/
--url="http://ro-bucharest-repo.bigstepcloud.com/centos/8.0.1905/BaseOS/x86_64/kickstart/"

## integration
inst.repo=http://ro-bucharest-repo.bigstepcloud.com/centos/8.0.1905/AppStream/x86_64/kickstart/
inst.stage2=http://ro-bucharest-repo.bigstepcloud.com/centos/8.0.1905/BaseOS/x86_64/kickstart/
--url="http://ro-bucharest-repo.bigstepcloud.com/centos/8.0.1905/BaseOS/x86_64/os/"
--baseurl=http://ro-bucharest-repo.bigstepcloud.com/centos/8.0.1905/BaseOS/x86_64/kickstart/../../../AppStream/x86_64/kickstart/
--url="http://ro-bucharest-repo.bigstepcloud.com/centos/8.0.1905/BaseOS/x86_64/kickstart/"


## dell-poc -> us-santaclara
inst.repo=http://mirrors.edge.kernel.org/centos/8.0.1905/AppStream/x86_64/kickstart/
inst.stage2=http://mirrors.edge.kernel.org/centos/8.0.1905/BaseOS/x86_64/kickstart/
--baseurl=http://mirrors.edge.kernel.org/centos/8.0.1905/BaseOS/x86_64/kickstart/../../../AppStream/x86_64/kickstart/
--url="http://mirrors.edge.kernel.org/centos/8.0.1905/BaseOS/x86_64/kickstart/"