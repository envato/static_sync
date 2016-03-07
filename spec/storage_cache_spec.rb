require "./lib/static_sync/storage_cache"

module StaticSync
  describe StorageCache do

    let(:path) { "index.html" }

    let(:version_one) { StorageCache::Version.new(path, "0cc175b9c0f1b6a831c399e269772661") }
    let(:version_two) { StorageCache::Version.new(path, "92eb5ffee6ae2fec3ad71c777531578f") }

    let(:files) { [] }

    subject do
      StorageCache.new(files)
    end

    describe "#has_file?" do

      it "returns false by default" do
        subject.has_file?(version_one).should be false
        subject.has_file?(version_two).should be false
      end

      context "when an existing version of a file exists in the cache" do

        let(:files) { [version_one] }

        it "returns true if the given version is the same" do
          subject.has_file?(version_one).should be true
        end
      end
    end

    describe "#has_version?" do

      it "returns false by default" do
        subject.has_version?(version_one).should be false
        subject.has_version?(version_two).should be false
      end

      context "when an existing version of a file exists in the cache" do

        let(:files) { [version_one] }

        it "returns false if the given version is different" do
          subject.has_version?(version_two).should be false
        end

        it "returns true if the given version is the same" do
          subject.has_version?(version_one).should be true
        end
      end
    end

    describe "#has_conflict?" do

      it "returns false by default" do
        subject.has_conflict?(version_one).should be false
        subject.has_conflict?(version_two).should be false
      end

      context "when an existing version of a file exists in the cache" do

        let(:files) { [version_one] }

        it "returns false when the given version is the same" do
          subject.has_conflict?(version_one).should be false
        end

        it "returns true when the given version is different" do
          subject.has_conflict?(version_two).should be true
        end

      end

    end
  end
end
