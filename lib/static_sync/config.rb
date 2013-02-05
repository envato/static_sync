require "erb"

module StaticSync
  class Config < Hash

    def log
      self.fetch('log', true)
    end

    def cache
      self.fetch('cache', {})
    end

    def source
      self.fetch('local', {})['directory']
    end

    def remote
      self.fetch('remote', {})
    end

    def storage
      Fog::Storage.new({
        :persistent            => true,
        :provider              => self.remote['provider'],
        :region                => self.remote['region'],
        :aws_access_key_id     => self.remote['username'],
        :aws_secret_access_key => self.remote['password']
      })
    end

    def storage_directory
      self.remote['directory']
    end

    def gzip
      self.fetch('gzip', true)
    end

    def ignored
      self['ignored']
    end

    def load(path = '.static')
      content = '{}'
      begin
        content = File.read(path)
      rescue
        # Loading config from file is not mandatory.
      end
      self.replace(YAML.load(ERB.new(content).result))
      self
    end

  end
end
