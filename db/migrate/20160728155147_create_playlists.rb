class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :url
      t.string :popular_url

      t.timestamps null: false
    end
  end
end
