# frozen_string_literal: true

require 'logger'
require 'json'
# TODO: move to only be request if using redis store
require 'redis'

require 'coverband/version'
require 'coverband/configuration'
require 'coverband/adapters/redis_store'
require 'coverband/adapters/memory_cache_store'
require 'coverband/adapters/file_store'
require 'coverband/collectors/base'
require 'coverband/collectors/trace'
require 'coverband/collectors/coverage'
require 'coverband/baseline'
require 'coverband/reporters/base'
require 'coverband/reporters/simple_cov_report'
require 'coverband/reporters/console_report'
require 'coverband/middleware'
require 'coverband/s3_report_writer'

module Coverband
  CONFIG_FILE = './config/coverband.rb'

  class << self
    attr_accessor :configuration_data
  end

  def self.configure(file = nil)
    configuration
    if block_given?
      yield(configuration)
    else
      if File.exist?(CONFIG_FILE)
        file ||= CONFIG_FILE
        require file
      else
        raise ArgumentError, "configure requires a block or the existance of a #{CONFIG_FILE} in your project"
      end
    end
  end

  def self.configuration
    self.configuration_data ||= Configuration.new
  end
end
