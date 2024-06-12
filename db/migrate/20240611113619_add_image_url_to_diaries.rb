class AddImageUrlToDiaries < ActiveRecord::Migration[7.1]
  def change
    add_column :diaries, :image_url, :string
  end
end
