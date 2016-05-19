require "fog"

module StaticSync
  class Storage

    def initialize(config)
      @config = config

      validate_credentials!
    end

    def has_file?(version)
      cache.has_file?(version)
    end

    def has_version?(version)
      cache.has_version?(version)
    end

    def cache
      @cache ||= begin
        versions = []
        remote_directory.files.each do |file|
          versions << StorageCache::Version.new(file.key, file.etag)
        end
        versions
        StorageCache.new(versions)
      end
    end

    def create(headers)
      remote_directory.files.create(headers)
    end

    private

    def remote_directory
      storage.directories.new(:key => @config.remote['directory'])
    end

    def validate_credentials!
      storage.get_bucket(@config.remote['directory'])
    end

    def storage
      @storage ||= Fog::Storage.new({
        :persistent            => true,
        :provider              => @config.remote['provider'],
        :region                => @config.remote['region'],
        :aws_access_key_id     => @config.remote['username'],
        :aws_secret_access_key => @config.remote['password'],
        :aws_session_token     => @config.remote['session_token'],
        :path_style            => @config.remote['path_style']
      })
    end

  end
end
