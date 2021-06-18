# Building a MetalSoft Debian unattended install template

To create an unattended install based local template use the script provided:

```bash
bash ./create_debian_8_template.sh debian-8 8
```

The first param is the label of the template and the second must match the name of the directory under Debian/ directory.

The script can be executed multiple times, the template will be deleted if it exists.

If you want to alter the installation we recommend starting by copying the `8` directory and editing the `preseed.cfg`. The variable glossary is available [in the documentation](https://docs.metalsoft.io/en/latest/guides/creating_a_local_install_template_from_scratch.html).
