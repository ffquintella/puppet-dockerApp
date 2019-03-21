#
# == Class: dockerapp
#
#
class dockerapp {

  include 'stdlib'

  class {'::dockerapp::params':}
  class {'::dockerapp::basedirs':}
  class {'::docker':}

}
