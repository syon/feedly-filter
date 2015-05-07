require 'dotenv'
require 'yaml'
require_relative 'feedly_mute'
Dotenv.load

config = YAML.load_file "config.yml"

mute = FeedlyMute.new(config['options'])
mute.mark_muted_as_read(config['mute_def'])
