#
# == Class: dockerapp
#
#
class dockerapp {

  class {'::dockerapp::params':}
  class {'::dockerapp::basedirs':}
  class {'::docker':}

}
