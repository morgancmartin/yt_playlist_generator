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

  def id_from_url(url)
    regex = /[=](.*)/
    url.match(regex)[0][1..-1]
  end

  def delete_all_user_playlists
    YtApi.new.delete_all_playlists(session[:oauth])
  end
end
