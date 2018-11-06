# frozen_string_literal: true

require 'awesome_print'
require 'json'
require 'net/http'
require 'trollop'
require 'uri'

# Allows you to easily add/remove/connect/disconnect nodes
# based on User Agent.
class PickynodeBCHD
  VERSION = '0.1.1'

  def initialize(opts = {})
    @opts = opts
  end

  def add(filter, limit = nil)
    return unless filter

    validate_limit(limit)

    blockchair_addr_types
      .select { |_, v| v.include?(filter) }
      .each_with_index do |(k, _), i|
        break if limit == i
        run_cmd(%(bchctl addnode "#{k}" add))
      end
  end

  def remove(filter, limit = nil)
    return unless filter

    validate_limit(limit)

    addr_types
      .select { |_, v| v.include?(filter) }
      .each_with_index do |(k, _), i|
        break if limit == i
        run_cmd(%(bchctl node remove "#{k}"))
      end
  end

  def connect(filter, limit = nil)
    return unless filter

    validate_limit(limit)

    blockchair_addr_types
      .select { |_, v| v.include?(filter) }
      .each_with_index do |(k, _), i|
        break if limit == i
        run_cmd(%(bchctl node connect "#{k}"))
      end
  end

  def disconnect(filter, limit = nil)
    return unless filter

    validate_limit(limit)

    addr_types
      .select { |_, v| v.include?(filter) }
      .each_with_index do |(k, _), i|
        break if limit == i
        run_cmd(%(bchctl node disconnect "#{k}"))
      end
  end

  def display
    ap addr_types
  end

  def info
    ap getinfo
  end

  def run
    add(@opts[:add], @opts[:limit])
    connect(@opts[:connect], @opts[:limit])

    remove(@opts[:remove], @opts[:limit])
    disconnect(@opts[:disconnect], @opts[:limit])

    display_info
  end

  def clear_cache
    @addr_types = nil
    @blockchair_addr_types = nil
  end

  private

  def display_info
    info if @opts[:info]
    display if @opts.values.select { |v| v }.empty?
  end

  def run_cmd(cmd)
    puts "Running #{cmd}" if @opts[:output] || @opts[:debug]
    `#{cmd}` unless @opts[:debug]
  end

  def addr_types
    return @addr_types if @addr_types
    nodes = getpeerinfo
    parsed_nodes = JSON.parse(nodes)
    @addr_types = parsed_nodes.map do |n|
      [n['addr'], n['subver']]
    end.to_h
  rescue JSON::ParserError
    {}
  end

  def blockchair_addr_types
    return @blockchair_addr_types if @blockchair_addr_types
    parsed_nodelist = JSON.parse(blockchair_snapshot)
    @blockchair_addr_types = parsed_nodelist['data']['nodes'].map do |k, v|
      [k, v['version']]
    end.to_h
  rescue JSON::ParserError
    {}
  end

  def blockchair_snapshot
    Net::HTTP.get(URI.parse('https://api.blockchair.com/bitcoin-cash/nodes'))
  end

  def getinfo
    JSON.parse(`bchctl getinfo`)
  rescue JSON::ParserError
    {}
  end

  def getpeerinfo
    `bchctl getpeerinfo`
  end

  def validate_limit(limit)
    return unless limit
    raise 'Limit must be greater than 0' unless limit > 0
  end
end
