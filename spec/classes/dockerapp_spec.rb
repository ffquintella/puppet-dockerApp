require 'spec_helper'

describe 'dockerapp' do
  let(:node) { 'node1.test.com' }

  shared_examples 'base directories' do
    it { is_expected.to compile }
    it { is_expected.to contain_class('dockerapp') }
    it { is_expected.to contain_class('dockerapp::params') }
    it { is_expected.to contain_class('dockerapp::basedirs') }
    it { is_expected.to contain_file('/srv/application-data') }
    it { is_expected.to contain_file('/srv/application-config') }
    it { is_expected.to contain_file('/srv/application-lib') }
    it { is_expected.to contain_file('/srv/application-log') }
    it { is_expected.to contain_file('/srv/scripts') }
  end

  context 'with RedHat defaults' do
    let(:facts) do
      {
        os: {
          'family' => 'RedHat',
          'name' => 'OracleLinux',
          'architecture' => 'x86_64',
          'release' => {
            'major' => '9',
            'minor' => '1',
          },
        },
        networking: {
          'fqdn' => 'node1.test.com',
        },
      }
    end

    include_examples 'base directories'

    it { is_expected.to contain_class('docker').with(docker_ce_package_name: 'docker-ce') }
    it { is_expected.to contain_package('podman').with(ensure: 'absent') }
    it { is_expected.to contain_package('podman-docker').with(ensure: 'absent') }
    it { is_expected.to contain_yumrepo('docker-ce') }
  end

  context 'with Debian defaults' do
    let(:facts) do
      {
        os: {
          'family' => 'Debian',
          'name' => 'Debian',
          'architecture' => 'amd64',
          'release' => {
            'major' => '11',
            'minor' => '0',
          },
          'distro' => {
            'codename' => 'bullseye',
          },
        },
        networking: {
          'fqdn' => 'node1.test.com',
        },
      }
    end

    include_examples 'base directories'

    it { is_expected.to contain_class('docker').with(docker_ce_package_name: 'docker-ce') }
    it { is_expected.to contain_apt__source('docker-ce') }
  end

  context 'when manage_docker is false' do
    let(:params) do
      {
        manage_docker: false,
      }
    end

    let(:facts) do
      {
        os: {
          'family' => 'RedHat',
          'name' => 'OracleLinux',
          'architecture' => 'x86_64',
          'release' => {
            'major' => '9',
            'minor' => '1',
          },
        },
        networking: {
          'fqdn' => 'node1.test.com',
        },
      }
    end

    include_examples 'base directories'

    it { is_expected.to contain_class('docker').with(manage_package: false) }
  end
end
