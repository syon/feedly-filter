require 'dotenv'
require 'yaml'
require_relative 'lib/feedly_mute'

get '/' do
  Dotenv.load
  config = YAML.load_file "config.yml"
  mute = FeedlyFilter.new(config['options'])
  @entries = mute.mark_muted_as_read(config['mute_def'])
  slim :index
end
