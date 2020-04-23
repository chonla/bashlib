# Bash Lib

Just a bash library for doing several bash-scripting for myself.

## Requirement

* git
* docker
* jq
  

## Usage

```
git clone https://github.com/chonla/bashlib.git ./lib
```

And source `./lib/all.sh` to main bash.

## Boilerplate

```
#!/usr/bin/env bash

APP_NAME=my-script # Your script name, whatever. This will be used in logging.
APP_VERSION="1.2.1" # Your script version.

parse_env # Parse .env file

for arg in "$@"
do
    case $arg in
        -v | --version) # Print app version
            log "`is_info $APP_NAME` version: `is_info $APP_VERSION`"
            exit 0
        ;;
    esac
    shift
done

```

