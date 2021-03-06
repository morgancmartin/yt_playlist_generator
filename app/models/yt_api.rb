require 'rubygems'
require 'yt'

class YtApi

  def initialize
    configure
    if Rails.env.development?
      @redirect_uri = 'http://localhost:3000/oauth'
    else
      @redirect_uri = 'https://pure-retreat-81398.herokuapp.com/oauth'
    end
  end

  def authentication_url
    scopes = ['youtube', 'youtube.readonly', 'userinfo.email']
    Yt::Account.new(scopes: scopes, redirect_uri: @redirect_uri).authentication_url
  end

  def create_playlist(name, url, auth)
    channel = create_channel(url)
    name = channel.title
    vid_ids = channel.videos.where(order: 'viewCount').map { |v| v.id }[0..9]
    create_account(auth)
    playlist = @account.create_playlist(title: name, privacy_status: "public")
    vid_ids.each { |id| playlist.add_video(id) }
    playlist_url_from_id(playlist.id)
  end

  def playlist_url_from_id(id)
    "https://www.youtube.com/playlist?list=#{id}"
  end

  def get_last_playlist
    @account.playlists.first if @account
  end

  def delete_all_playlists(auth)
    account = create_account(auth)
    account.playlists.each do |playlist|
      playlist.delete unless playlist.title == "Liked Videos" || playlist.title == "Favorites"
    end
    true
  end

  def channel_name(url)
    create_channel(url).title
  end

  def create_channel(url)
    Yt::Channel.new url: url
  end

  def create_account(auth_code)
    @account = Yt::Account.new authorization_code: auth_code, redirect_uri: @redirect_uri
  end

  def get_popular_vids(url)
    create_channel(url).videos.where(order: 'viewCount')
  end

  def configure
    Yt.configure do |config|
      config.client_id = ENV['CLIENT_ID']
      config.client_secret = ENV['CLIENT_SECRET']
      config.api_key = ENV['KEY']
      config.log_level = :debug
    end
  end
end
