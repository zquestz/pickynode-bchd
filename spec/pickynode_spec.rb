# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'mocks'

describe PickynodeBCHD do
  # Debug mode makes sure we don't execute real commands.
  let(:opts) do
    { debug: true }
  end

  # IPv6 addresses are long, easier to refer by let.
  let(:ipv6_ip) { '[2a01:e34:ee3a:5730:21f:5bff:fec5:e356]:8333' }

  # The currently connected nodes for the specs.
  let(:node_hash) do
    { '131.114.88.218:33422' => '/FirstClient/',
      ipv6_ip => '/SecondClient/' }
  end

  # String to simulate a json error.
  let(:json_error) { 'An error occurred.' }

  # Parsed information from getinfo.
  let(:parsed_node_info) { JSON.parse(NODE_INFO) }

  subject { PickynodeBCHD.new(opts) }

  describe '.add' do
    it 'should add nodes based on user agent' do
      expect(subject).to receive(:blockchair_snapshot).once
                                                      .and_return(BLOCKCHAIR_SNAPSHOT)
      expect(subject).to receive(:run_cmd)
        .with(%(bchctl addnode "#{ipv6_ip}" add))
      subject.add('ABC')
      expect(subject).to receive(:run_cmd)
        .with('bchctl addnode "88.99.199.87:8333" add')
      subject.add('Unlimited')
    end

    it 'should return if the filter is falsy' do
      expect(subject).to_not receive(:blockchair_snapshot)
      expect(subject).to_not receive(:run_cmd)
      subject.add(false)
      subject.add(nil)
    end

    it 'should recover gracefully if json is malformed' do
      expect(subject).to receive(:blockchair_snapshot).once
                                                      .and_return(json_error)
      expect(subject).to_not receive(:run_cmd)
      subject.add('Anything')
    end

    it 'should raise an error if the limit is <= 0' do
      expect { subject.add('Anything', 0) }
        .to raise_error('Limit must be greater than 0')
      expect { subject.add('Anything', -5) }
        .to raise_error('Limit must be greater than 0')
    end

    context 'with a limit' do
      it 'should respect a limit parameter of 1' do
        expect(subject).to receive(:blockchair_snapshot).once
                                                        .and_return(BLOCKCHAIR_SNAPSHOT)
        expect(subject).to receive(:run_cmd)
          .with('bchctl addnode "88.99.199.87:8333" add')
        subject.add('i', 1)
      end

      it 'should respect a limit parameter greater than 1' do
        expect(subject).to receive(:blockchair_snapshot).once
                                                        .and_return(BLOCKCHAIR_SNAPSHOT)
        expect(subject).to receive(:run_cmd)
          .with('bchctl addnode "88.99.199.87:8333" add')
        expect(subject).to receive(:run_cmd)
          .with(%(bchctl addnode "#{ipv6_ip}" add))
        subject.add('i', 2)
      end
    end
  end

  describe '.remove' do
    it 'should remove nodes based on user agent' do
      expect(subject).to receive(:`).once
                                    .and_return(PEER_INFO)
      expect(subject).to receive(:run_cmd)
        .with(%(bchctl node remove "#{ipv6_ip}"))
      subject.remove('SecondClient')
      expect(subject).to receive(:run_cmd)
        .with('bchctl node remove "131.114.88.218:33422"')
      subject.remove('FirstClient')
    end

    it 'should return if the filter is falsy' do
      expect(subject).to_not receive(:getpeerinfo)
      expect(subject).to_not receive(:run_cmd)
      subject.remove(false)
      subject.remove(nil)
    end

    it 'should recover gracefully if json is malformed' do
      expect(subject).to receive(:`).once
                                    .and_return(json_error)
      expect(subject).to_not receive(:run_cmd)
      subject.remove('Anything')
    end
  end

  describe '.connect' do
    it 'should connect to nodes based on user agent' do
      expect(subject).to receive(:blockchair_snapshot).once
                                                      .and_return(BLOCKCHAIR_SNAPSHOT)
      expect(subject).to receive(:run_cmd)
        .with('bchctl node connect "88.99.199.87:8333"')
      subject.connect('Unlimited')
      expect(subject).to receive(:run_cmd)
        .with(%(bchctl node connect "#{ipv6_ip}"))
      subject.connect('ABC')
    end

    it 'should return if the filter is falsy' do
      expect(subject).to_not receive(:blockchair_snapshot)
      expect(subject).to_not receive(:run_cmd)
      subject.connect(false)
      subject.connect(nil)
    end

    it 'should recover gracefully if json is malformed' do
      expect(subject).to receive(:blockchair_snapshot).once
                                                      .and_return(json_error)
      expect(subject).to_not receive(:run_cmd)
      subject.connect('Anything')
    end

    it 'should raise an error if the limit is <= 0' do
      expect { subject.connect('Anything', 0) }
        .to raise_error('Limit must be greater than 0')
      expect { subject.connect('Anything', -5) }
        .to raise_error('Limit must be greater than 0')
    end

    context 'with a limit' do
      it 'should respect a limit parameter of 1' do
        expect(subject).to receive(:blockchair_snapshot).once
                                                        .and_return(BLOCKCHAIR_SNAPSHOT)
        expect(subject).to receive(:run_cmd)
          .with('bchctl node connect "88.99.199.87:8333"')
        subject.connect('i', 1)
      end

      it 'should respect a limit parameter greater than 1' do
        expect(subject).to receive(:blockchair_snapshot).once
                                                        .and_return(BLOCKCHAIR_SNAPSHOT)
        expect(subject).to receive(:run_cmd)
          .with('bchctl node connect "88.99.199.87:8333"')
        expect(subject).to receive(:run_cmd)
          .with(%(bchctl node connect "#{ipv6_ip}"))
        subject.connect('i', 2)
      end
    end
  end

  describe '.disconnect' do
    it 'should disconnect nodes based on user agent' do
      expect(subject).to receive(:`).once
                                    .and_return(PEER_INFO)
      expect(subject).to receive(:run_cmd)
        .with(%(bchctl node disconnect "#{ipv6_ip}"))
      subject.disconnect('SecondClient')
      expect(subject).to receive(:run_cmd)
        .with('bchctl node disconnect "131.114.88.218:33422"')
      subject.disconnect('FirstClient')
    end

    it 'should return if the filter is falsy' do
      expect(subject).to_not receive(:getpeerinfo)
      expect(subject).to_not receive(:run_cmd)
      subject.disconnect(false)
      subject.disconnect(nil)
    end

    it 'should recover gracefully if json is malformed' do
      expect(subject).to receive(:`).once
                                    .and_return(json_error)
      expect(subject).to_not receive(:run_cmd)
      subject.disconnect('Anything')
    end
  end

  describe '.display' do
    it 'should display connected nodes' do
      expect(subject).to receive(:`).once
                                    .and_return(PEER_INFO)
      expect(subject).to receive(:ap).with(node_hash).and_return(node_hash)
      expect(subject.display).to eq(node_hash)
    end

    it 'should recover gracefully if json is malformed' do
      expect(subject).to receive(:`).once
                                    .and_return(json_error)
      expect(subject).to receive(:ap).with({}).and_return({})
      expect(subject.display).to eq({})
    end
  end

  describe '.info' do
    it 'should display local node info' do
      expect(subject).to receive(:`).once
                                    .and_return(NODE_INFO)
      expect(subject).to receive(:ap).with(parsed_node_info)
                                     .and_return(parsed_node_info)
      expect(subject.info).to eq(parsed_node_info)
    end

    it 'should recover gracefully if json is malformed' do
      expect(subject).to receive(:`).once
                                    .and_return(json_error)
      expect(subject).to receive(:ap).with({}).and_return({})
      expect(subject.info).to eq({})
    end
  end

  describe '.run' do
    context 'with opts' do
      let(:opts) do
        {
          debug: true,
          info: true,
          add: 'Wanted',
          connect: 'Now',
          remove: 'Nefarious',
          disconnect: 'Fools',
          limit: 1
        }
      end

      it 'should call add, connect, remove, disconnect and info' do
        expect(subject).to receive(:blockchair_snapshot).once
                                                        .and_return(BLOCKCHAIR_SNAPSHOT)
        expect(subject).to receive(:getpeerinfo).once
                                                .and_return(PEER_INFO)
        expect(subject).to receive(:add).with(opts[:add], opts[:limit])
                                        .and_call_original
        expect(subject).to receive(:connect).with(opts[:connect], opts[:limit])
                                            .and_call_original
        expect(subject).to receive(:remove).with(opts[:remove], opts[:limit])
                                           .and_call_original
        expect(subject).to receive(:disconnect)
          .with(opts[:disconnect], opts[:limit])
          .and_call_original
        expect(subject).to receive(:info)
        expect(subject).to_not receive(:display)
        subject.run
      end

      it 'should recover gracefully if json is malformed' do
        expect(subject).to receive(:blockchair_snapshot).at_least(1)
                                                        .and_return(json_error)
        expect(subject).to receive(:getpeerinfo).at_least(1)
                                                .and_return(json_error)
        expect(subject).to receive(:`)
          .and_return(json_error)
        expect(subject).to receive(:info)
          .and_call_original
        expect(subject).to receive(:ap).with({})
        expect(subject).to_not receive(:run_cmd)
        subject.run
      end
    end

    context 'without opts' do
      let(:opts) do
        {}
      end

      it 'should call display' do
        expect(subject).to receive(:`).once
                                      .and_return(PEER_INFO)
        expect(subject).to receive(:ap).with(node_hash).and_return(node_hash)
        expect(subject).to receive(:display).and_call_original
        subject.run
      end

      it 'should recover gracefully if json is malformed' do
        expect(subject).to receive(:`).once
                                      .and_return(json_error)
        expect(subject).to_not receive(:run_cmd)
        expect(subject).to_not receive(:info)
        expect(subject).to receive(:ap).with({}).and_return({})
        subject.run
      end
    end
  end

  describe 'clear_cache' do
    it 'should clear the bitnodes cache' do
      expect(subject).to receive(:blockchair_snapshot).once
                                                      .and_return(BLOCKCHAIR_SNAPSHOT)
      expect(subject).to receive(:run_cmd)
        .with(%(bchctl addnode "#{ipv6_ip}" add))
      expect(subject).to receive(:run_cmd)
        .with('bchctl addnode "88.99.199.87:8333" add')
      subject.add('ABC')
      subject.add('Unlimited')
      subject.clear_cache
      expect(subject).to receive(:blockchair_snapshot).once
                                                      .and_return(BLOCKCHAIR_SNAPSHOT)
      expect(subject).to receive(:run_cmd)
        .with(%(bchctl addnode "#{ipv6_ip}" add))
      subject.add('ABC')
    end

    it 'should clear the getpeerinfo cache' do
      expect(subject).to receive(:getpeerinfo).once
                                              .and_return(PEER_INFO)
      expect(subject).to receive(:run_cmd)
        .with('bchctl node remove "131.114.88.218:33422"')
      expect(subject).to receive(:run_cmd)
        .with(%(bchctl node remove "#{ipv6_ip}"))
      subject.remove('FirstClient')
      subject.remove('SecondClient')
      subject.clear_cache
      expect(subject).to receive(:getpeerinfo).once
                                              .and_return(PEER_INFO)
      expect(subject).to receive(:run_cmd)
        .with('bchctl node remove "131.114.88.218:33422"')
      subject.remove('FirstClient')
    end
  end
end
