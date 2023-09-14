#
# == Type: dockerapp::run
#
# Runs an instance of the docker app with the defined parameters
#
# === Parameters
# [*service_name*]
#   Used to determine the name of the app and the service installed. Usually it uses the title of the resource.
#
# [*image*]
#   The docker image to be used.
#
# [*ports*]
#   The ports to be exposed
#
# [*hostname*]
#   Hostname of to be passed to the container. Defaults to the fqdn of the local machine
#
# [*extra_parameters*]
#   Extra parameters to be passed to the container
#
# [*environments*]
#   Environments variables
#
# [*restart_service*]
#   If the service must be restarted in the case of a failure
#
# [*volumes*]
#   Volumes to be mounted
#
# [*dir_owner*]
#   The uid of the dir owner of the app dir
#
# [*dir_group*]
#   The uid of the dir group of the app dir
#
# [*command*]
#   Command to be executed on the docker-run
#
# [*links*]
#   Docker links
#
# [*links*]
#   Custom network to use
#
define dockerapp::run (
  String $service_name = $title,
  $image = undef,
  $ports = undef,
  $hostname = $::fqdn,
  $extra_parameters = [],
  $environments = [],
  $restart_service = true,
  $volumes = [],
  $dir_owner = 1,
  $dir_group = 1,
  $command = undef,
  $links = undef,
  $net = undef,
  $require = undef,
)
{
  if !defined(Class['::dockerapp']){
    class{'::dockerapp':}
  }

  $data_dir = $::dockerapp::params::data_dir
  $config_dir = $::dockerapp::params::config_dir
  $scripts_dir = $::dockerapp::params::scripts_dir
  $lib_dir = $::dockerapp::params::lib_dir
  $log_dir = $::dockerapp::params::log_dir

  $conf_datadir = "${data_dir}/${service_name}"
  $conf_configdir = "${config_dir}/${service_name}"
  $conf_scriptsdir = "${scripts_dir}/${service_name}"
  $conf_libdir = "${lib_dir}/${service_name}"
  $conf_logdir = "${log_dir}/${service_name}"

  if !defined(File[$conf_datadir]){
    file{ $conf_datadir:
      ensure  => directory,
      require => File[$data_dir],
      owner   => $dir_owner,
      group   => $dir_group,
    }
  }

  if !defined(File[$conf_configdir]){
    file{ $conf_configdir:
      ensure  => directory,
      require => File[$config_dir],
      owner   => $dir_owner,
      group   => $dir_group,
    }
  }

  if !defined(File[$conf_scriptsdir]){
    file{ $conf_scriptsdir:
      ensure  => directory,
      require => File[$scripts_dir],
      owner   => $dir_owner,
      group   => $dir_group,
    }
  }
  if !defined(File[$conf_logdir]){
    file{ $conf_logdir:
      ensure  => directory,
      require => File[$lib_dir],
      owner   => $dir_owner,
      group   => $dir_group,
    }
  }
  if !defined(File[$conf_libdir]){
    file{ $conf_libdir:
      ensure  => directory,
      require => File[$log_dir],
      owner   => $dir_owner,
      group   => $dir_group,
    }
  }

  if($links != undef){
    if( $net != undef ){
      if( !defined( Docker_Network[$net] )) {
        docker_network { $net:
          ensure => present,
        }
      }
    }

    ::docker::run { $service_name:
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
  }else {

    ::docker::run { $service_name:
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
