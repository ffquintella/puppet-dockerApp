#
# == Type: dockerapp::run
#
# Runs an instance of the docker app with the defined parameters
#
# @param service_name Used to determine the name of the app and the service installed
# @param image The docker image to be used
# @param ports The ports to be exposed
# @param hostname Hostname to be passed to the container
# @param extra_parameters Extra parameters to be passed to the container
# @param environments Environment variables
# @param restart_service If the service must be restarted in the case of a failure
# @param volumes Volumes to be mounted
# @param dir_owner The uid of the dir owner of the app dir
# @param dir_group The uid of the dir group of the app dir
# @param command Command to be executed on the docker-run
# @param links Docker links
# @param net Custom network to use
# @param require Resources to require
#
define dockerapp::run (
  String $service_name                    = $title,
  Optional[String] $image                 = undef,
  Optional[Variant[String,Array]] $ports  = undef,
  String $hostname                        = $facts['networking']['fqdn'],
  Array $extra_parameters                 = [],
  Array $environments                     = [],
  Boolean $restart_service                = true,
  Array $volumes                          = [],
  Variant[String,Integer] $dir_owner      = 1,
  Variant[String,Integer] $dir_group      = 1,
  Optional[String] $command               = undef,
  Optional[Variant[String,Array]] $links  = undef,
  Optional[String] $net                   = undef,
  Optional[Any] $require                  = undef,
) {
  if !defined(Class['dockerapp']) {
    class { 'dockerapp': }
  }

  $data_dir = $dockerapp::params::data_dir
  $config_dir = $dockerapp::params::config_dir
  $scripts_dir = $dockerapp::params::scripts_dir
  $lib_dir = $dockerapp::params::lib_dir
  $log_dir = $dockerapp::params::log_dir

  $conf_datadir = "${data_dir}/${service_name}"
  $conf_configdir = "${config_dir}/${service_name}"
  $conf_scriptsdir = "${scripts_dir}/${service_name}"
  $conf_libdir = "${lib_dir}/${service_name}"
  $conf_logdir = "${log_dir}/${service_name}"

  if !defined(File[$conf_datadir]) {
    file { $conf_datadir:
      ensure  => directory,
      require => File[$data_dir],
      owner   => $dir_owner,
      group   => $dir_group,
    }
  }

  if !defined(File[$conf_configdir]) {
    file { $conf_configdir:
      ensure  => directory,
      require => File[$config_dir],
      owner   => $dir_owner,
      group   => $dir_group,
    }
  }

  if !defined(File[$conf_scriptsdir]) {
    file { $conf_scriptsdir:
      ensure  => directory,
      require => File[$scripts_dir],
      owner   => $dir_owner,
      group   => $dir_group,
    }
  }

  if !defined(File[$conf_logdir]) {
    file { $conf_logdir:
      ensure  => directory,
      require => File[$lib_dir],
      owner   => $dir_owner,
      group   => $dir_group,
    }
  }

  if !defined(File[$conf_libdir]) {
    file { $conf_libdir:
      ensure  => directory,
      require => File[$log_dir],
      owner   => $dir_owner,
      group   => $dir_group,
    }
  }

  if ($links != undef) {
    if ($net != undef) {
      if (!defined(Docker_Network[$net])) {
        docker_network { $net:
          ensure => present,
        }
      }
    }

    docker::run { $service_name:
      image            => $image,
      ports            => $ports,
      hostname         => $hostname,
      extra_parameters => $extra_parameters,
      restart_service  => $restart_service,
      volumes          => $volumes,
      env              => $environments,
      command          => $command,
      net              => [$net],
      links            => $links,
      require          => $require,
    }
  } else {
    docker::run { $service_name:
      image            => $image,
      ports            => $ports,
      hostname         => $hostname,
      extra_parameters => $extra_parameters,
      restart_service  => $restart_service,
      volumes          => $volumes,
      env              => $environments,
      command          => $command,
      net              => [$net],
      require          => $require,
    }
  }
}
