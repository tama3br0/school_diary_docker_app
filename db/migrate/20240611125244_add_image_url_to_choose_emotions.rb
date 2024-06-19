class AddImageUrlToChooseEmotions < ActiveRecord::Migration[7.1]
    def change
      unless column_exists?(:choose_emotions, :image_url)
        add_column :choose_emotions, :image_url, :string
      end
    end
end
