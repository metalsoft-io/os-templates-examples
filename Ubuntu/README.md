# Building a MetalSoft Ubuntu unattended install template

To create an unattended install based local template use the script provided:

```bash
bash ./create_ubuntu_template.sh ubuntu-18-04 18.04
```

or

```bash
bash ./create_ubuntu_template.sh ubuntu-20-04 20.04
```

The first param is the label of the template and the second must match the name of the directory under Ubuntu/ directory.

The script can be executed multiple times, the template will be deleted if it exists.

If you want to alter the installation we recommend starting by copying the `20.04` directory and editing the `ks.cfg`.  The variable glossary is available [in the documentation](https://docs.metalsoft.io/en/latest/guides/creating_a_local_install_template_from_scratch.html).
