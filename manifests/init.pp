#
# == Class: dockerapp
#
# @param manage_docker Whether to manage Docker installation
# @param use_docker_ce Use official Docker CE repository instead of distribution packages
# @param remove_podman Remove podman packages before installing Docker CE
#
class dockerapp (
  Boolean $manage_docker = true,
  Boolean $use_docker_ce = true,
  Boolean $remove_podman = true,
) {
  include stdlib

  if !defined(Class['dockerapp::params']) {
    class { 'dockerapp::params': }
  }
  if !defined(Class['dockerapp::basedirs']) {
    class { 'dockerapp::basedirs': }
  }

  if $manage_docker {
    if $use_docker_ce {
      case $facts['os']['family'] {
        'RedHat': {
          if $remove_podman {
            package { ['podman-docker', 'podman']:
              ensure => absent,
              notify => [],
              before => Class['docker'],
            }
          }
          yumrepo { 'docker-ce':
            descr    => 'Docker CE Stable - $basearch',
            baseurl  => "https://download.docker.com/linux/centos/\$releasever/\$basearch/stable",
            gpgkey   => 'https://download.docker.com/linux/centos/gpg',
            gpgcheck => true,
            enabled  => true,
            notify   => [],
            before   => Class['docker'],
          }
        }
        'Debian': {
          apt::source { 'docker-ce':
            location => "https://download.docker.com/linux/${facts['os']['name'].downcase}",
            release  => $facts['os']['distro']['codename'],
            repos    => 'stable',
            key      => {
              'id'     => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
              'source' => 'https://download.docker.com/linux/ubuntu/gpg',
            },
            notify   => [],
            before   => Class['docker'],
          }
        }
        default: {
          fail("Unsupported OS family: ${facts['os']['family']}")
        }
      }
      if !defined(Class['docker']) {
        class { 'docker':
          use_upstream_package_source => false,
          service_overrides_template  => false,
          docker_ce_package_name      => 'docker-ce',
        }
      }
    } else {
      if !defined(Class['docker']) {
        class { 'docker':
          use_upstream_package_source => false,
          service_overrides_template  => false,
        }
      }
    }
  } else {
    if !defined(Class['docker']) {
      class { 'docker':
        manage_package         => false,
        docker_ce_package_name => 'docker-ce',
      }
    }
  }
}
