## Modules vs Packages

    - https://stackoverflow.com/questions/7948494/whats-the-difference-between-a-module-and-package-in-python
    - Any Python file is a [*module*](http://docs.python.org/tutorial/modules.html), its name being the file's base name without the `.py` extension.
    - A [*package*](http://docs.python.org/tutorial/modules.html#packages) is a *collection* of Python modules: while a module is a single Python file, a package is a directory of Python modules containing an additional `__init__.py` file, to distinguish a package from a directory that just happens to contain a bunch of Python scripts. Packages can be nested to any depth, provided that the corresponding directories contain their own `__init__.py` file.
    - The distinction between *module* and *package* seems to hold just at the file system level. When you import a *module* or a *package*, the corresponding object created by Python is always of type `module`

- ## Python project example
  - Dir structure
    ```
    repo/
    	.git
        pkg/
        	__init__.py
            main.py
            tests/
            	test_xyz.py
        pyproject.toml


    ```
  - Manage project using `uv`

    ```
    # initialise project
    # this creates a venv as well
    uv init

    uv venv
    # install external pkg
    uv add <pkg>

    # checkin uv.lock


    # from a project containing uv.lock
    # run uv sync to install dependencies
    uv sync

    ```

  - run `uv pip install -e .` to install it in editable mode which means
    packages are available in python path and code can be edited -- this creates
    a `__editable__.xxx` file under `site_packages`
