# dockerapp

## Description

`dockerapp` is a base module for the dockerApp family. It creates a predictable
directory layout for application data/config/logs and optionally manages Docker
installation via the official Docker CE repositories.

## Setup

Add the module to your Puppetfile or install it from the Forge, then include
the class:

```puppet
include dockerapp
```

By default this will:
- Create base directories under `/srv`.
- Configure Docker CE repositories (apt/yumrepo).
- Install and manage Docker via `puppetlabs/docker`.

## Usage

### Basic install (Docker CE + base dirs)

```puppet
include dockerapp
```

### Use distribution packages (skip Docker CE repo)

```puppet
class { 'dockerapp':
  use_docker_ce => false,
}
```

### Do not manage Docker at all

```puppet
class { 'dockerapp':
  manage_docker => false,
}
```

### Run a container with managed directories

```puppet
dockerapp::run { 'myapp':
  image            => 'ghcr.io/example/myapp:1.2.3',
  ports            => ['8080:8080'],
  environments     => ['APP_ENV=production', 'LOG_LEVEL=info'],
  volumes          => [
    '/srv/application-data/myapp:/var/lib/myapp',
    '/srv/application-config/myapp:/etc/myapp',
    '/srv/application-log/myapp:/var/log/myapp',
  ],
  extra_parameters => ['--restart=unless-stopped'],
}
```

### Connect to an existing container via Docker links

```puppet
dockerapp::run { 'web':
  image => 'nginx:1.25',
  links => ['db:db'],
  net   => 'appnet',
}
```

## Directory layout

`dockerapp` creates these base directories by default:
- `/srv/application-data`
- `/srv/application-config`
- `/srv/application-lib`
- `/srv/application-log`
- `/srv/scripts`

`dockerapp::run` creates per-service subdirectories under each base directory.
For example, `dockerapp::run { 'myapp': }` creates:
- `/srv/application-data/myapp`
- `/srv/application-config/myapp`
- `/srv/application-lib/myapp`
- `/srv/application-log/myapp`
- `/srv/scripts/myapp`

## Parameters

### Class `dockerapp`

- `manage_docker` (Boolean): Manage Docker installation and service.
- `use_docker_ce` (Boolean): Configure Docker CE repositories and package name.
- `remove_podman` (Boolean): Remove podman packages on RedHat before Docker CE.

### Defined type `dockerapp::run`

- `service_name` (String): Service/container name (defaults to title).
- `image` (String): Docker image to run.
- `ports` (String or Array): Port mappings.
- `hostname` (String): Container hostname (defaults to node FQDN).
- `extra_parameters` (Array): Additional docker run arguments.
- `environments` (Array): Environment variables (`KEY=value`).
- `restart_service` (Boolean): Restart policy management.
- `volumes` (Array): Volume mappings.
- `dir_owner` / `dir_group` (String/Integer): Ownership for created dirs.
- `command` (String): Command passed to the container.
- `links` (String or Array): Docker link entries.
- `net` (String): Custom Docker network name.
- `require` (Any): Resource dependencies.

## Limitations

- Puppet `>= 7.0.0 < 9.0.0`.
- Supported OS versions are listed in `metadata.json`.
- Requires `puppetlabs/docker`, `puppetlabs/apt`, and `puppetlabs/yumrepo_core`.

## Development

Run PDK validations before submitting changes:

```sh
pdk validate
```
