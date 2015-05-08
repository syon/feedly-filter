Feedly Mute
===========

Mark as read articles and tag "MUTE" in Feedly with your config.


## Usage

1. Get accsess token
    - https://feedly.com/v3/auth/dev
2. Paste it into .env file
    - .env
```sh
ACCESS_TOKEN="Anm8nV5.....mQifQ:feedlydev"
```
3. Edit your config
    - config.yml

```yaml
options:
  mute_tag_label: MUTED
  tag_only_mode: false
  engagement_threshold: 200

mute_def:
  word:
    - ｗｗｗｗ
    - 閲覧注意
  url:
    - blog.example.com
    - example.com/mute/
```


### CLI sample

```ruby
require_relative 'lib/feedly_mute'
require 'yaml'

config = YAML.load_file "config.yml"
mute = FeedlyMute.new(config['options'])
entries = mute.mark_muted_as_read(config['mute_def'])
```
