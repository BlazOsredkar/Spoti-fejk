class Playlist < ApplicationRecord
    belongs_to :user
    has_many :playlist_songs
    has_many :songs, through: :playlist_songs

    def songs_by_position
        self.songs.order('playlists_songs.position')
    end




    def self.ransackable_attributes(auth_object = nil)
        ["cover_image", "created_at", "id", "name", "privacy", "updated_at", "user_id"]
    end
end
