require 'spec_helper'

describe 'dockerapp::run' do
  let(:title) { 'runtest' }
  let(:node) { 'node1.test.com' }
  let(:params) do
    {
      image: 'test/image:1.1',
      extra_parameters: [
        'param1',
        'param2',
      ],
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
      operatingsystemmajrelease: '7',
      architecture: 'x86_64',
      os:
      {
        'family'     => 'RedHat',
        'name'       => 'OracleLinux',
        'release'    =>
        {
          'major' => '7',
          'minor' => '5',
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
end
