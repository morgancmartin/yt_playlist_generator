class PlaylistsController < ApplicationController

  include PlaylistsHelper

  def new
    @playlist = Playlist.new
    if session[:oauth] != session[:lastauth] || session[:oauth].nil?
     render :new
    else
      render :oauth
    end
  end

  # NOTE: URL's must be in http:// format
  def create
    @playlist = Playlist.new(whitelisted_playlist_params)
    @playlist.popular_url = gen_pop_url(@playlist.url)
    @playlist.playlistID = id_from_url(@playlist.popular_url)
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
    @last_id = @playlists.last.playlistID if @playlists.any?
  end

  def edit
    @playlist = Playlist.find(params[:id])
  end

  def update
    @playlist = Playlist.find(params[:id])
    if @playlist.update(whitelisted_playlist_params)
      redirect_to playlist_path(@playlist)
    else
      flash.now[:alert] = "That's not valid input"
      render :edit
    end
  end

  def oauth
    session[:oauth] = params[:code]
    redirect_to new_playlist_path
  end

  def reset
    reset_session
    redirect_to new_playlist_path
  end

  def delete_user_playlists
    delete_all_user_playlists
    redirect_to playlists_path
  end

  private

  def whitelisted_playlist_params
    params.require(:playlist).permit(:url, :channelname, :playlistID)
  end
end
