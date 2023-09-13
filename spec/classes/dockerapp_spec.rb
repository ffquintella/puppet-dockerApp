require 'spec_helper'

describe '::dockerapp' do
  let(:node) { 'node1.test.com' }
  let(:params) do
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
        'architecture' => 'x86_64',
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
  it { is_expected.to contain_file('/srv/application-data') }
  it { is_expected.to contain_file('/srv/application-config') }
  it { is_expected.to contain_file('/srv/application-lib') }
  it { is_expected.to contain_file('/srv/application-log') }
  it { is_expected.to contain_file('/srv/scripts') }
end
