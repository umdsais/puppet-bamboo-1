require 'spec_helper'

describe 'bamboo' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "bamboo class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('bamboo::params') }
          it { is_expected.to contain_class('bamboo::install').that_comes_before('bamboo::config') }
          it { is_expected.to contain_class('bamboo::config') }
          it { is_expected.to contain_class('bamboo::service').that_subscribes_to('bamboo::config') }

          it { is_expected.to contain_service('bamboo') }
          it { is_expected.to contain_package('bamboo').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'bamboo class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('bamboo') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
