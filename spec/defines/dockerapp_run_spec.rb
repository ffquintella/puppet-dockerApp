require 'spec_helper'

describe 'dockerapp::run' do
  let(:title) { 'runtest' }
  let(:node) { 'node2.test.com' }
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
        'fqdn' => 'node2.test.com',
      },
    }
  end

  context 'with a basic run configuration' do
    let(:params) do
      {
        image: 'test/image:1.1',
        extra_parameters: [
          'param1',
          'param2',
        ],
        net: 'test',
        dir_owner: '10',
        dir_group: '10',
      }
    end

    it { is_expected.to compile }
    it { is_expected.to contain_class('dockerapp::params') }
    it { is_expected.to contain_class('dockerapp::basedirs') }
    it { is_expected.to contain_class('docker') }
    it { is_expected.to contain_file('/srv/application-data/runtest') }
    it { is_expected.to contain_file('/srv/application-config/runtest') }
    it { is_expected.to contain_file('/srv/application-lib/runtest') }
    it { is_expected.to contain_file('/srv/application-log/runtest') }
    it { is_expected.to contain_file('/srv/scripts/runtest') }

    it do
      is_expected.to contain_docker__run('runtest')
        .with(
          image: 'test/image:1.1',
          net: ['test'],
        )
    end
  end

  context 'when links and a custom network are provided' do
    let(:params) do
      {
        image: 'test/image:1.1',
        links: ['db:db'],
        net: 'appnet',
      }
    end

    it { is_expected.to contain_docker_network('appnet').with(ensure: 'present') }
    it do
      is_expected.to contain_docker__run('runtest')
        .with(
          links: ['db:db'],
          net: ['appnet'],
        )
    end
  end
end
