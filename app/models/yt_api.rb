require 'rubygems'
require 'yt'

class YtApi

  CLIENT_ID = '791272575222-mu57nle6b0iklbds3cfugmop8so8qani.apps.googleusercontent.com'
  CLIENT_SECRET = 'vyLGKc1aqiqOL9iq7XhhVKh0'
  KEY = 'AIzaSyAlvGIXaCABWek6d_ztlQxYOX-vQt12jgg'

  def initialize
    configure
    @redirect_uri = 'http://localhost:3000/oauth'
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

  # def create_playlist(title)
  #   @account.create_playlist(title: title, privacy_status: "public")
  # end

  def get_last_playlist
    @account.playlists.first if @account
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
      config.client_id = CLIENT_ID
      config.client_secret = CLIENT_SECRET
      config.api_key = KEY
    end
  end
end
