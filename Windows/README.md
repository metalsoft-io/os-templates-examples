# Building a MetalSoft Windows unattended install template

To create an unattended install based local template use the script provided:

```bash
bash ./create_windows_bios_boot_template.sh w2019std-bios-boot 2019
```

```bash
bash ./create_windows_uefi_boot_template.sh w2019std-uefi-boot 2019
```

The first param is the label of the template and the second must match the name of the directory under Windows/ directory.

The script can be executed multiple times, the template will be deleted if it exists.

If you want to alter the installation we recommend starting by copying the `2019` directory and editing the `autounattend.xml`.  The variable glossary is available [in the documentation](https://docs.metalsoft.io/en/latest/guides/creating_a_local_install_template_from_scratch.html).
