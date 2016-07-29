class AddPlaylistIdToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :playlistID, :string
  end
end
