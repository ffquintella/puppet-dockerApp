#
# == Class: dockerapp
#
# @param manage_docker Whether to manage Docker installation
# @param use_dist_packages Use distribution packages instead of official Docker CE repository
#
class dockerapp (
  Boolean $manage_docker    = true,
  Boolean $use_dist_packages = false,
) {
  include stdlib

  if !defined(Class['dockerapp::params']) {
    class { 'dockerapp::params': }
  }
  if !defined(Class['dockerapp::basedirs']) {
    class { 'dockerapp::basedirs': }
  }

  if $manage_docker {
    if $use_dist_packages {
      if !defined(Class['docker']) {
        class { 'docker':
          use_upstream_package_source => false,
          service_overrides_template  => false,
        }
      }
    } else {
      case $facts['os']['family'] {
        'RedHat': {
          yumrepo { 'docker-ce':
            descr    => 'Docker CE Stable - $basearch',
            baseurl  => "https://download.docker.com/linux/centos/\$releasever/\$basearch/stable",
            gpgkey   => 'https://download.docker.com/linux/centos/gpg',
            gpgcheck => true,
            enabled  => true,
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
