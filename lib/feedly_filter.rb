require 'feedlr'
require 'dotenv'

class FeedlyFilter

  attr_accessor :client, :profile, :subscriptions

  def initialize(options = {})
    @mute_tag_label = options['mute_tag_label']
    @tag_only_mode = options['tag_only_mode']
    @engagement_threshold = options['engagement_threshold'] ||= "99999"

    Dotenv.load
    @client = Feedlr::Client.new({oauth_access_token: ENV['ACCESS_TOKEN']})

    # Testing auth
    @profile = @client.user_profile
    @subscriptions = @client.user_subscriptions

    @client
  end

  def mark_muted_as_read(mute_def)
    profile_id = @client.user_profile.id
    stream_id = "user/#{profile_id}/category/global.all"
    entries = @client.stream_entries_contents(stream_id, :count => 1000).items
    return unless entries

    muted_eids = fetch_muted_eids entries, mute_def
    return if muted_eids.size == 0

    # Mark as read muted entries
    @client.mark_articles_as_read muted_eids unless @tag_only_mode

    # Tag muted entries
    if @mute_tag_label
      muted_tag_id = "user/#{@client.user_profile.id}/tag/#{@mute_tag_label}"
      @client.tag_entries muted_eids, [muted_tag_id]
    end

    client.user_entries muted_eids
  end

  private

  def fetch_muted_eids(entries, mute_def)
    muted_eids = []
    entries.each do |e|
      next if e.engagement.to_i > @engagement_threshold.to_i
      if is_muted_by_title(e.title, mute_def['word'])
        muted_eids.push e.id
      end
      if is_muted_by_url(e.alternate.first.href, mute_def['url'])
        muted_eids.push e.id
      end
      if is_muted_by_timeout(e, mute_def['timeout'])
        muted_eids.push e.id
      end
    end
    muted_eids
  end

  def is_muted_by_title(title, mute_words)
    mute_words.map do |word|
      tr_word  = convert_upcase_halfwidth word
      tr_title = convert_upcase_halfwidth title
      return true if tr_title.include? tr_word
    end
    return false
  end

  def convert_upcase_halfwidth(text)
    text.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z').upcase.gsub /\s/, ""
  end

  def is_muted_by_url(url, mute_urls)
    mute_urls.map do |mu|
      return true if url.include? mu
    end
    return false
  end

  def is_muted_by_timeout(entry, timeout_def)
    is_feed = is_timeout_by_feedname   entry, timeout_def['feedname']
    is_elap = is_timeout_by_elapsed    entry, timeout_def['elapsed']
    is_enga = is_timeout_by_engagement entry, timeout_def['engagement']
    return is_feed & is_elap & is_enga
  end

  def is_timeout_by_feedname(entry, def_feedname)
    feedname = detect_custom_feedname entry
    def_feedname.include? feedname
  end

  def detect_custom_feedname(entry)
    @subscriptions.each do |s|
      return s.title if s.id == entry.origin.streamId
    end
  end

  def is_timeout_by_elapsed(entry, def_elapsed)
    crawled = entry.crawled.to_s[0..9].to_i
    current = Time.now.to_i.to_s[0..9].to_i
    (current - crawled) > def_elapsed
  end

  def is_timeout_by_engagement(entry, def_engagement)
    entry.engagement.to_i < def_engagement
  end
end
