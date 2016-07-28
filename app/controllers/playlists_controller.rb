class PlaylistsController < ApplicationController

  include PlaylistsHelper

  def new
    @playlist = Playlist.new
    if session[:oauth] != session[:lastauth]
     render :new
    else
      render :oauth
    end
  end

  # NOTE: URL's must be in http:// format
  def create
    @playlist = Playlist.new(whitelisted_playlist_params)
    @playlist.popular_url = gen_pop_url(@playlist.url)
    @playlist.channelname = gen_channel_name(@playlist.url)
    session[:lastauth] = session[:oauth]
    if @playlist.save
      redirect_to playlist_path(@playlist)
    else
      render :new
    end
  end

  def show
    @playlist = Playlist.find(params[:id])
  end

  def index
    @playlists = Playlist.all
  end

  def oauth
    session[:oauth] = params[:code]
    redirect_to new_playlist_path
  end

  def reset
    reset_session
    redirect_to new_playlist_path
  end

  private

  def whitelisted_playlist_params
    params.require(:playlist).permit(:url)
  end
end
