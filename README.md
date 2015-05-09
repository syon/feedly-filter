Feedly Filter
=============

Filtering Feedly articles with your rules.


## Provides

<dl>
  <dt>Mute</dt>
  <dd>Mark as read articles and tag "MUTE" in Feedly with words and urls.<br>Furthermore, you can keep it unread if the article engagement is high.</dd>
</dl>
<dl>
  <dt>Pick</dt>
  <dd>Pick articles with specific words and assign them to preserved category. (future)</dd>
</dl>


## on

- Web browser
- Command line
- Heroku for automation
- Web service (future)


## Usage

#### 1. Get accsess token

- https://feedly.com/v3/auth/dev

#### 2. Paste it into .env file

```sh
ACCESS_TOKEN="Anm8nV5.....mQifQ:feedlydev"
```

#### 3. Edit your config.yml

```yaml
options:
  mute_tag_label: MUTED
  tag_only_mode: false
  engagement_threshold: 200

mute_def:
  word:
    - ｗｗｗｗ
    - 閲覧注意
    - The NG Word
  url:
    - blog.example.com
    - example.com/mute/
```

### Run on Web browser

```sh
$ foreman start
```
- http://localhost:5000

### Run on CLI (Ruby)

```ruby
require_relative 'lib/feedly_mute'
require 'yaml'
require 'ap'

config = YAML.load_file "config.yml"
mute = FeedlyMute.new(config['options'])
entries = mute.mark_muted_as_read(config['mute_def'])
ap entries.first
```
