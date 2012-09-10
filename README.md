# StaticSync

This gem provides a stand alone mechanism for uploading static websites to cloud hosting providers such as 
[Amazon AWS](http://en.wikipedia.org/wiki/Amazon_S3#Hosting_entire_websites).

### Features

* Works with any language / framework.
* Configurable cache control.
 
## Installation

```bash
  gem install static_sync
```

## Usage

In your project directory create a `.static` file:

```
> cat .static
local:
  directory: build

remote:
  provider: AWS
  username: my-aws-key
  password: my-aws-secret
  directory: my-aws-bucket
```

And run the following command any time you want to upload.

```bash
  static_sync
```

### Cache Control

By default uploaded files have no cache headers set. 

You can add cache headers on a content type basis to your `.static` file: 

```yaml
cache:
  javascript: 31536000
  css: 31536000
```

Which will cache all javscript and css files for 31536000 seconds (one year).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
