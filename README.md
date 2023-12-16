# Project Toolkit

The 'Project Toolkit' represents a set of modules required to develop and build your projects.

Provides the following functionality to the projects:

- Software Toolkit: the set of tools and small utilities required to develop and build your projects
- Versioning: defining the project version parameters from one central place
- Installation and build recipes
- Dependency providing: project can pull required dependencies and install it.
- Multiple Git upstreams support (for example, GitHub and BitBucket at the same time)
- Project testing iterraction
- Project opening support with advanced feature (pre-opening recipes, etc.)
- Desktop icon launching support

## What is included?

- The [Software Toolkit](https://github.com/red-elf/Software-Toolkit) module
- The [Versionable](https://github.com/red-elf/Versionable) module
- The [Installable](https://github.com/red-elf/Installable) module
- The [Dependable](https://github.com/red-elf/Dependable) module
- The [Upstreamable](https://github.com/red-elf/Upstreamable) module
- The [Testable](https://github.com/red-elf/Testable) module
- The [Project](https://github.com/red-elf/Project) module
- The [Iconic](https://github.com/red-elf/Iconic) module

## How to install?

Execute the following:

```shell
(test -e ./clone || wget "https://raw.githubusercontent.com/red-elf/Project-Toolkit/main/clone?append="$(($(date +%s%N)/1000000)) -O clone) && \
    chmod +x ./clone && ./clone git@github.com:red-elf/Project-Toolkit.git ./Toolkit
```

or via one of the mirror repositories:

- [GitFlic](https://gitflic.ru/):

```shell
(test -e ./clone || \
    wget "https://raw.githubusercontent.com/red-elf/Project-Toolkit/main/clone?append="$(($(date +%s%N)/1000000)) -O clone) && \
    chmod +x ./clone && ./clone git@gitflic.ru:red-elf/project-toolkit.git ./Toolkit
```

- [Gitee](https://gitee.com/):

```shell
(test -e ./clone || wget "https://raw.githubusercontent.com/red-elf/Project-Toolkit/main/clone?append="$(($(date +%s%N)/1000000)) -O clone) && \
    chmod +x ./clone && ./clone git@gitee.com:Kvetch_Godspeed_b073/Project-Toolkit.git ./Toolkit
```

*Note:* It is required to execute the script from empty directory where you whish to clone the Project Toolkit utility.

### macOS

To install execute the following:

```shell
(test -e ./clone || wget "https://raw.githubusercontent.com/red-elf/Project-Toolkit/main/clone" -O clone) && chmod +x ./clone && ./clone git@github.com:red-elf/Project-Toolkit.git ./Toolkit
```

## Making the Project Toolkit features available to the system

- Setup the RS file: the `.bashr` or `.zshrc`:

```shell
export SUBMODULES_HOME=/Users/milosvasic/Projects/RedElf/Toolkit
export PATH=$PATH:$SUBMODULES_HOME
export PATH=$PATH:$SUBMODULES_HOME/Upstreamable
export PATH=$PATH:$SUBMODULES_HOME/Installable
```

Which will expose the access to the following commands (and many others as well which will be documented at some point):

- `install_upstreams.sh` Execute from the directory which contains the Upstreams directory and install Upstreams

*Note:* Find the details on setting up the Upstreams [here](https://github.com/red-elf/Upstreamable)

- `pull_all.sh` No arguments needed, pulls the code from all Upstreams
- `push_all.sh` Push to all remote upstreams
- `commit`      With our without commit message, commits and pushes to all remote upstreams

*Note:* You can export the paths for the other Project Toolkit modules as well to access their features on the system level!

## Development documentation

Documentation can be found [here](Documentation).
