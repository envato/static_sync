require "timecop"

require "./lib/static_sync/config"
require "./lib/static_sync/uploadable"

describe StaticSync::Uploadable do

  let(:config)        { StaticSync::Config.new }

  subject(:html_file) { StaticSync::Uploadable.new("index.html", config) }
  subject(:text_file) { StaticSync::Uploadable.new("data.txt", config) }
  subject(:css_file)  { StaticSync::Uploadable.new("screen.css", config) }
  subject(:gif_file)  { StaticSync::Uploadable.new("spinner.gif", config) }
  subject(:png_file)  { StaticSync::Uploadable.new("background.png", config) }

  describe "#headers" do

    it "should make all files viewable by everyone" do
      html_file.headers[:public].should be true
    end

    it "should reduce storage costs for all files" do
      html_file.headers[:storage_class].should == "REDUCED_REDUNDANCY"
    end

    it "should set the content type header for html files" do
      html_file.headers[:content_type].should == "text/html"
    end

    it "should set the content type header for png files" do
      png_file.headers[:content_type].should == "image/png"
    end

    xit "should set the content encoding header for html files" do
      html_file.headers[:content_encoding].should == "gzip"
    end

    it "should not set the content encoding header for png files" do
      png_file.headers[:content_encoding].should be_nil
    end

    it "should set a content md5 header for html files" do
      html_file.headers[:content_md5].should == "1B2M2Y8AsgTpgAmY7PhCfg=="
    end

    it "should set an etag header for html files" do
      html_file.headers[:etag].should == "d41d8cd98f00b204e9800998ecf8427e"
    end

    context "when caching is enabled for html" do

      before do
        config['cache'] = { 'html' => 60 * 60 * 24 * 365 }
      end

      before do
        Timecop.freeze(Time.local(2010))
      end

      it "sets the cache control header for html files" do
        html_file.headers[:cache_control].should == "public, max-age=31536000"
      end

      it "sets the expires header for html files " do
        html_file.headers[:expires].should == "Fri, 31 Dec 2010 13:00:00 GMT"
      end
    end

  end

  describe "#cached?" do
    it "returns false by default" do
      subject.cached?.should be false
    end

    context "when caching is enabled for html" do

      before do
        config['cache'] = { 'html' => '86400' }
      end

      it "returns true for a html file" do
        html_file.cached?.should be true
      end
    end
  end

  describe "#cache_time" do

    context "when caching is disabled" do

      before do
        config['cache'] = { }
      end

      it "returns nil for a html file" do
        html_file.cache_time.should be_nil
      end
    end

    context "when caching is enabled for html" do

      before do
        config['cache'] = { 'html' => '86400' }
      end

      it "returns the configured value for html files" do
        html_file.cache_time.should == 86400
      end

      it "returns the configured value for text files" do
        text_file.cache_time.should be_nil
      end

      it "returns nil for css files" do
        css_file.cache_time.should be_nil
      end
    end

    context "when caching is enabled for images" do

      before do
        config['cache'] = { 'image' => '86400' }
      end

      it "returns the configured value for gif files" do
        gif_file.cache_time.should == 86400
      end

      it "returns the configured value for png files" do
        png_file.cache_time.should == 86400
      end
    end

  end

  describe "#gzipped?" do

    xit "returns true for html files" do
      html_file.gzipped?.should be true
    end

    it "returns false for png files" do
      png_file.gzipped?.should be false
    end

  end
end
