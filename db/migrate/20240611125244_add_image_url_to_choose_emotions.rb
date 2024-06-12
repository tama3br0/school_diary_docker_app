class AddImageUrlToChooseEmotions < ActiveRecord::Migration[7.1]
  def change
    add_column :choose_emotions, :image_url, :string
  end
end
