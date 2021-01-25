#
# == Class: dockerapp
#
#
class dockerapp (
	$manage_docker   = true,
	) {

  include 'stdlib'

  if !defined(Class['dockerapp::params']){class {'::dockerapp::params':}}
  if !defined(Class['dockerapp::basedirs']){class {'::dockerapp::basedirs':}}
  if $manage_docker {
  	if !defined(Class['docker']){class {'::docker':}}	
  }
  

}
