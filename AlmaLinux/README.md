# Building a MetalSoft AlmaLinux unattended install template

To create an unattended install based template use the script provided


```bash
bash ./create_almalinux_8_iscsi_uefi_boot_template.sh almalinux-8-iscsi-uefi 8
bash ./create_almalinux_8_iscsi_legacy_boot_template.sh almalinux-8-iscsi-legacy 8
```

The first param is the label of the template and the second must match the name of the directory under AlmaLinux/ directory.

The script can be executed multiple times, the template will be deleted or updated if it exists.
