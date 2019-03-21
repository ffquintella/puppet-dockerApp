#
# == Type: dockerapp::run
#
# Runs an instance of the docker app with the defined parameters
#
#
define dockerapp::run (
  $service_name = $title,
  $image = undef,
  $ports = undef,
  $hostname = $::fqdn,
  $extra_parameters = [],
  $restart_service = true,
  $volumes = [],
  $dir_owner = 1,
  $dir_group = 1
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

  file{ $conf_datadir:
    ensure  => directory,
    require => File[$data_dir],
    owner   => $dir_owner,
    group   => $dir_group,
  }

  file{ $conf_configdir:
    ensure  => directory,
    require => File[$config_dir],
    owner   => $dir_owner,
    group   => $dir_group,
  }

  file{ $conf_scriptsdir:
    ensure  => directory,
    require => File[$scripts_dir],
    owner   => $dir_owner,
    group   => $dir_group,
  }

  file{ $conf_logdir:
    ensure  => directory,
    require => File[$lib_dir],
    owner   => $dir_owner,
    group   => $dir_group,
  }

  file{ $conf_libdir:
    ensure  => directory,
    require => File[$log_dir],
    owner   => $dir_owner,
    group   => $dir_group,
  }

  ::docker::run { $service_name:
    image            => $image,
    ports            => $ports,
    hostname         => $hostname,
    extra_parameters => $extra_parameters,
    restart_service  => $restart_service,
    volumes          => $volumes,
  }


}
