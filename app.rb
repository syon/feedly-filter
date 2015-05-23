require 'dotenv'
require 'yaml'
require 'json'
require_relative 'lib/feedly_filter'

get '/' do
  slim :index
end

post '/' do
  Dotenv.load
  config = YAML.load_file "config.yml"
  begin
    mute = FeedlyFilter.new(config['options'])
    @entries = mute.mark_muted_as_read(config['mute_def'])
  rescue => ex
    @error = ex
  end
  @entries.to_json
end
