#
# == Class: dockerapp::basedirs
#
#
class dockerapp::basedirs inherits dockerapp::params {
  include baseapp

  if !defined(File[$dockerapp::params::lib_dir]) {
    file { $dockerapp::params::lib_dir:
      ensure => directory,
    }
  }
  if !defined(File[$dockerapp::params::log_dir]) {
    file { $dockerapp::params::log_dir:
      ensure => directory,
    }
  }
}
