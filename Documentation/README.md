# Project Toolkit documentation

## Main documentation

- Tbd.

## SonarQube

- [Tryout SonarQube](https://docs.sonarqube.org/latest/try-out-sonarqube/)
- [Server setup](https://docs.sonarqube.org/latest/setup-and-upgrade/install-the-server/)
- [Docker image](https://hub.docker.com/_/sonarqube)
- [C++ support](https://docs.sonarqube.org/latest/analyzing-source-code/languages/c-family/)

## Additional material

- Tbd

## TODO

- `sh run nameOfConfiguration` instead of `sh Run/Some/Path/script.sh`
- The Project Toolkit includes mechanism:

```shell
IMPORT "Utils/VSCode/Something" # Where Something corresponds to `Soemthing` or `Soemthing.sh`
```

```shell
USE "Utils/VSCode/Something" # Where Something corresponds to `Soemthing` or `Soemthing.sh`
```

Where `IMPORT` will just include the script (reference its path), and `USE` will do the same and `source` it.

- The `IMPORT` and `USE` will be exported and avaialbe through the Project Toolkit installation procedure.
