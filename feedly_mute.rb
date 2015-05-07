require 'feedlr'

class FeedlyMute

  attr_accessor :client

  def initialize(options = {})
    @mute_tag_label = options['mute_tag_label']
    @engagement_threshold = options['engagement_threshold'] ||= "99999"

    @client = Feedlr::Client.new({oauth_access_token: ENV['ACCESS_TOKEN']})
    begin
      @client.user_profile
    rescue => ex
      p ex
      exit
    end
  end

  def mark_muted_as_read(mute_def)

    profile_id = @client.user_profile.id
    stream_id = "user/#{profile_id}/category/global.all"
    entries = @client.stream_entries_contents(stream_id, :count => 1000).items

    muted_eids = []
    entries.map do |e|
      next if e.engagement.to_i > @engagement_threshold.to_i
      if is_muted_by_title(e.title, mute_def['word'])
        muted_eids.push e.id
      end
      if is_muted_by_url(e.alternate.first.href, mute_def['url'])
        muted_eids.push e.id
      end
    end
    return if muted_eids.size == 0

    # Mark as read muted entries
    #result = @client.mark_articles_as_read muted_eids
    #puts result

    # Tag muted entries
    if @mute_tag_label
      tag_label = @mute_tag_label
      muted_tag_id = "user/#{@client.user_profile.id}/tag/#{tag_label}"
      result = @client.tag_entries muted_eids, [muted_tag_id]
      puts result
    end
  end

  private

  def is_muted_by_title(title, mute_words)
    mute_words.map do |word|
      tr_word = convert_upcase_halfwidth word
      tr_title = convert_upcase_halfwidth title
      #puts "#{tr_word} -- #{tr_title}"
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
end
