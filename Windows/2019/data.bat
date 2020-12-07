REM == Global ==

set windowsVersion=Windows-2019
REM Possible values (SambaDrive|VirtualDrive|IscsiDrive)
set sourceMethod=SambaDrive
set extraOptions=
REM Possible values: 'yes','no'. Defaults to 'no'.
set debugStop=
REM Possible values (LocalDrive|IscsiDrive)
set installType=LocalDrive
    REM If the "installType=IscsiDrive" the following parameters are required
    set iPortalIpAddr=
    set iPortalPort=
    set iTargetIqn=
    set initiatorIqn=
    set chapUser=
    set chapPass=
    set wwnDriveSerialNumber=
REM Unique URL to announce that we are changing from ipxe_config_install to ipxe_config_os_boot
set callbackNumber=

REM == SambaDrive ==

set smbSrvIp={{datacenter_samba_server_ip}}
set smbShareName={{datacenter_samba_server_windows_kit_share_name}}
set smbUser={{datacenter_samba_server_username}}
set smbPass={{datacenter_samba_server_password}}

REM == IscsiDrive ==

set portalIpAddr=
set portalPort=
set targetIqn=
set initiatorIqn=
set chapUser=
set chapPass=
