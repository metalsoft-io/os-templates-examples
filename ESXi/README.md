# Building a MetalSoft ESXi unattended install template

To create an unattended install based local template use the script provided:

```bash
bash ./create_esxi_templates.sh esxi-700-uefi-v2 7.0.0
```

The first param is the label of the template and the second must match the name of the directory under ESXi/ directory.

The script can be executed multiple times, the template will be deleted if it exists.

If you want to alter the installation we recommend starting by copying the `7.0.0` directory and editing the `ks.cfg`.  The variable glossary is available [in the documentation](https://docs.metalsoft.io/en/latest/guides/creating_a_local_install_template_from_scratch.html).
