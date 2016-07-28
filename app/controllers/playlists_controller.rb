class PlaylistsController < ApplicationController

  include PlaylistsHelper

  def new
    @playlist = Playlist.new
    @auth = session[:oauth]
  end

  def create ## URL's MUST be HTTP-ified before saving to the database!!
    @playlist = Playlist.new(whitelisted_playlist_params)
    @playlist.popular_url = gen_pop_url(@playlist.url)
    # @playlist.popular_url = popular_url if popular_url = gen_pop_url(@playlist.url)
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

  private

  def whitelisted_playlist_params
    params.require(:playlist).permit(:url)
  end
end
