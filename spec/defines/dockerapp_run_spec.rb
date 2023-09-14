require 'spec_helper'

describe 'dockerapp::run' do
  let(:title) { 'runtest' }
  let(:node) { 'node2.test.com' }
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

  let(:facts) do
    {
      id: 'root',
      kernel: 'Linux',
      osfamily: 'RedHat',
      operatingsystem: 'OracleLinux',
      operatingsystemmajrelease: '8',
      architecture: 'x86_64',
      os:
      {
        'family'     => 'RedHat',
        'name'       => 'OracleLinux',
        'architecture' => 'x86_64',
        'release'    =>
        {
          'major' => '8',
          'minor' => '1',
        },
      },
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      is_pe: false,
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


  it { is_expected.to contain_docker__run('runtest')
          .with(
            image: 'test/image:1.1',
            net: ['test']
          )}

end
