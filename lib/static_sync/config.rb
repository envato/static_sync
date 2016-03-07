require "erb"

module StaticSync
  class Config < Hash

    def log
      self.fetch('log', true)
    end

    def local
      self.fetch('local', {})
    end

    def local_directory
      self.local['directory']
    end

    def remote
      self.fetch('remote', {})
    end

    def remote_directory
      self.remote['directory']
    end

    def cache
      self.fetch('cache', {})
    end

    def ignored
      self.fetch('ignored', nil)
    end

    def conflict_mode
      self.fetch('conflict_mode', 'overwrite')
    end

    def fail_on_conflict?
      conflict_mode == 'fail'
    end

    def fail_on_conflict_if_cached?
      conflict_mode == 'fail_if_cached'
    end

    def ignore_conflict?
      conflict_mode == 'ignore_conflict'
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
