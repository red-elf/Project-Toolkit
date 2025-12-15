# Agent Instructions for Project Toolkit

## Project Overview
Project Toolkit is a modular development toolkit providing utilities for project management, versioning, installation, dependency management, and multi-upstream Git support.

## Essential Commands

### Project Management
- **Open project**: `./open` - Opens project with pre-open recipes
- **Prepare project**: `./prepare` - Prepares project for development
- **Test project**: `./test` - Runs all test configurations
- **Install toolkit**: `./install.sh` - Installs toolkit to SUBMODULES_HOME

### Git Operations
- **Pull all upstreams**: `./pull_all` - Pulls from all configured upstreams
- **Push all upstreams**: `./push_all` - Pushes to all configured upstreams
- **Commit and push**: `./commit [message]` - Commits and pushes to all upstreams
- **Clone project**: Use `./clone` script for initial setup

### Installation
- **Install upstreams**: `install_upstreams.sh` - Install from Upstreams directory
- **System setup**: Export paths in .bashrc/.zshrc for system-wide access

## Project Structure

### Core Modules
- **Software-Toolkit/**: Core utilities and tools
- **Versionable/**: Version management
- **Installable/**: Installation recipes
- **Dependable/**: Dependency management
- **Upstreamable/**: Multi-upstream Git support
- **Testable/**: Testing framework
- **Project/**: Project management
- **Iconic/**: Desktop icon support

### Key Directories
- **Recipes/**: Installation and build recipes
- **Run/**: Runtime configurations
- **Run/Test/**: Test run configurations
- **Documentation/**: Project documentation
- **Assets/**: Project assets
- **Docker-Definitions/**: Docker configurations

### Important Files
- **install.sh**: Main installation script
- **open**: Project opening script
- **test**: Test execution script
- **clone**: Project cloning utility

## Module Documentation

### Software-Toolkit Module
Provides core utilities:
- **Utils/**: Various utility scripts (curl, download, version management)
- **Templates/**: Recipe templates
- **Upstreams/**: Upstream repository configurations (GitHub, GitFlic, Gitee)

### Versionable Module
- **version.sh**: Version management utilities
- Handles version parameters from central location

### Installable Module
- Installation recipes and procedures
- Handles project installation and setup

### Dependable Module
- Dependency management
- Pulls and installs required dependencies

### Upstreamable Module
- Multiple Git upstreams support (GitHub, BitBucket, etc.)
- Synchronization across multiple repositories

### Testable Module
- Project testing interaction
- Test configuration management

### Project Module
- Project opening support with advanced features
- Pre-opening recipes and project management

### Iconic Module
- Desktop icon launching support
- Application icon management

## Development Patterns

### Script Structure
- All scripts use bash with proper error handling
- Use `HERE=$(pwd)` for current directory reference
- Check for required environment variables
- Use descriptive error messages

### Environment Setup
Required environment variables:
```bash
export SUBMODULES_HOME=/path/to/Toolkit
export PATH=$PATH:$SUBMODULES_HOME
export PATH=$PATH:$SUBMODULES_HOME/Upstreamable
export PATH=$PATH:$SUBMODULES_HOME/Installable
```

### Testing Approach
- Tests are organized in `Run/Test/` directory
- Each test is a separate script
- Test runner executes all test configurations
- Modular test structure for different components

## Installation and Setup

### Initial Installation
```bash
(test -e ./clone || wget "https://raw.githubusercontent.com/red-elf/Project-Toolkit/main/clone" -O clone) && \
    chmod +x ./clone && ./clone git@github.com:red-elf/Project-Toolkit.git ./Toolkit
```

### System Integration
Add to .bashrc or .zshrc:
```bash
export SUBMODULES_HOME=/path/to/Toolkit
export PATH=$PATH:$SUBMODULES_HOME
export PATH=$PATH:$SUBMODULES_HOME/Upstreamable
export PATH=$PATH:$SUBMODULES_HOME/Installable
```

### Available Commands After Setup
- `install_upstreams.sh` - Install from Upstreams directory
- `pull_all.sh` - Pull from all upstreams
- `push_all.sh` - Push to all upstreams
- `commit` - Commit and push to all upstreams

## Multi-Upstream Support

### Supported Upstreams
- **GitHub**: `git@github.com:red-elf/Project-Toolkit.git`
- **GitFlic**: `git@gitflic.ru:red-elf/project-toolkit.git`
- **Gitee**: `git@gitee.com:Kvetch_Godspeed_b073/Project-Toolkit.git`

### Upstream Management
- Clone from any upstream
- Synchronize across all configured upstreams
- Push/pull operations work across all upstreams

## Code Style and Conventions

### Script Conventions
- Use bash with proper shebang `#!/bin/bash`
- Include error handling and validation
- Use descriptive variable names
- Follow consistent indentation (spaces)

### Documentation
- Include README.md in each module
- Provide usage examples
- Document required environment variables
- Include installation instructions

## Important Gotchas

1. **SUBMODULES_HOME**: Must be set for installation and operation
2. **Empty Directory**: Installation requires empty target directory
3. **Git Upstreams**: Configure upstreams before using multi-upstream features
4. **Path Export**: Export paths in shell configuration for system-wide access
5. **Test Configurations**: Tests are modular and run from Run/Test/ directory

## Integration with Other Projects

### ATMOSphere Integration
- Toolkit provides utilities for ATMOSphere development
- Version management and dependency handling
- Multi-upstream Git support

### General Project Integration
- Can be integrated with any project
- Provides standardized project management utilities
- Modular design allows selective feature usage

## Security Notes
- Follow secure coding practices in scripts
- Validate all inputs and environment variables
- Use proper error handling and validation
- Follow Git security best practices for upstream management