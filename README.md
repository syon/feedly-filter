Feedly Mute
===========

Mark as read articles and tag "MUTE" in Feedly with your config.

### CLI sample

```ruby
require_relative 'lib/feedly_mute'
require 'yaml'

config = YAML.load_file "config.yml"
mute = FeedlyMute.new(config['options'])
entries = mute.mark_muted_as_read(config['mute_def'])
```
