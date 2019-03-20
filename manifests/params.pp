#
# == Class: dockerapp::basedirs
#
#  Default parameters to the class
#
class dockerapp::params {
  $data_dir = '/srv/application-data'
  $config_dir = '/srv/application-config'
  $lib_dir = '/srv/application-lib'
  $log_dir = '/srv/application-log'
  $scripts_dir = '/srv/scripts'
}
