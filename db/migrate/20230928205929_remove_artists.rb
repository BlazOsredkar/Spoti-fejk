class RemoveArtists < ActiveRecord::Migration[7.0]
  def change
    drop_table :artists
  end
end