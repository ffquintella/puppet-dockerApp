#
# == Type: dockerapp::run
#
# Runs an instance of the docker app with the defined parameters
#
#
define dockerapp::run (
  $service_name = $name,
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

  $conf_datadir = "${dockerapp::params::data_dir}/${service_name}"
  $conf_configdir = "${dockerapp::params::config_dir}/${service_name}"
  $conf_scriptsdir = "${dockerapp::params::scripts_dir}/${service_name}"
  $conf_libdir = "${dockerapp::params::lib_dir}/${service_name}"
  $conf_logdir = "${dockerapp::params::log_dir}/${service_name}"

  file{ $conf_datadir:
    ensure  => directory,
    require => File[dockerapp::params::data_dir],
    owner   => $dir_owner,
    group   => $dir_group,
  }

  file{ $conf_configdir:
    ensure  => directory,
    require => File[dockerapp::params::config_dir],
    owner   => $dir_owner,
    group   => $dir_group,
  }

  file{ $conf_scriptsdir:
    ensure  => directory,
    require => File[dockerapp::params::scripts_dir],
    owner   => $dir_owner,
    group   => $dir_group,
  }

  file{ $conf_logdir:
    ensure  => directory,
    require => File[dockerapp::params::log_dir],
    owner   => $dir_owner,
    group   => $dir_group,
  }

  file{ $conf_libdir:
    ensure  => directory,
    require => File[dockerapp::params::lib_dir],
    owner   => $dir_owner,
    group   => $dir_group,
  }

  ::docker::run { $service_name:
    image            => $image,
    ports            => $ports,
    hostname         => $hostname,
    extra_parameters => $extra_parameters ,
    restart_service  => $restart_service,
    volumes          => $volumes,
  }


}
