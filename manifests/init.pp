#
# == Class: dockerapp
#
#
class dockerapp {

  include 'stdlib'

  if !defined(Class['dockerapp::params']){class {'::dockerapp::params':}}
  if !defined(Class['dockerapp::basedirs']){class {'::dockerapp::basedirs':}}
  if !defined(Class['docker']){class {'::docker':}}

}
