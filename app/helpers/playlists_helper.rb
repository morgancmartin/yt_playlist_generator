module PlaylistsHelper
  def auth_url
    YtApi.new.authentication_url
  end

  def gen_pop_url(url)
    YtApi.new.create_playlist('name', url, session[:oauth])
  end

  def gen_channel_name(url)
    YtApi.new.channel_name(url)
  end
end
