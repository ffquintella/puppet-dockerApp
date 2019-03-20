#
# == Class: dockerapp::basedirs
#
#
class dockerapp::basedirs {

if!defined(File[$dockerapp::params::data_dir]) { file { $dockerapp::params::data_dir: ensure => directory, } }
if!defined(File[$dockerapp::params::config_dir]) { file { $dockerapp::params::config_dir: ensure => directory, } }
if!defined(File[$dockerapp::params::lib_dir]) { file { $dockerapp::params::lib_dir: ensure => directory, } }
if!defined(File[$dockerapp::params::log_dir]) { file { $dockerapp::params::log_dir: ensure => directory, } }
if!defined(File[$dockerapp::params::scripts_dir]) { file { $dockerapp::params::scripts_dir: ensure => directory, } }

}
