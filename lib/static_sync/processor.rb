require "logger"

require_relative "storage"
require_relative "uploadable"

module StaticSync
  class Processor

    class ConflictError < StandardError
    end

    def initialize(config, storage = nil)
      @config  = config
      @storage = storage || StaticSync::Storage.new(config)
      @skip    = []
    end

    def sync
      log_sync
      each_uploadable_file do |uploadable_file|
        next if @storage.has_version?(uploadable_file.version)

        look_for_conflicts(uploadable_file)

        store_file(uploadable_file)
      end
    end

    def handle_conflict(file)
      log.info("Overwriting #{file}") if @config.log
      if @config.fail_on_conflict?
        raise ConflictError, "modifications to existing files are not allowed."
      elsif @config.fail_on_conflict_if_cached?
        if file.cached?
          raise ConflictError, "modifications to existing cached files are not allowed."
        end
      elsif @config.ignore_conflict?
        @skip << file
        log.info("#{file} already exist, skipping.") if @config.log
      end
    end

    def skip?(file)
      @skip.include?(file)
    end

    def local_filtered_files
      local_files.reject do |file|
        file =~ Regexp.new(@config.ignored) if @config.ignored
      end
    end

    private

    def look_for_conflicts(file)
      if @storage.has_file?(file.version)
        handle_conflict(file)
      else
        log.info("Uploading #{ file }") if @config.log
      end
    end

    def store_file(file)
      return if skip?(file)
      @storage.create(file.headers)
    rescue => error
      log.error("Failed to upload #{file}")
      raise error
    end

    def log_sync
      return unless @config.log
      log.info("Synching #{@config.local_directory} to #{@config.remote_directory}.")
    end

    def each_uploadable_file
      Dir.chdir(@config.local_directory) do
        local_filtered_files.each do |file|
          yield Uploadable.new(file, @config)
        end
      end
    end

    def local_files
      Dir.glob("**/*.*").reject do |file|
        File.directory?(file)
      end
    end

    def log
      @log ||= begin
        logger = Logger.new(STDOUT)
        logger.formatter = proc do |severity, datetime, progname, msg|
            "#{datetime}: #{severity} -- #{msg}\n"
        end
        logger
      end
    end

  end
end
