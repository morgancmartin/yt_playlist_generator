class AddChannelNameToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :channelname, :string
  end
end
