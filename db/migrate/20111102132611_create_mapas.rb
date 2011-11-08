class CreateMapas < ActiveRecord::Migration
  def change
    create_table :mapas do |t|
      t.string :url
      t.string :url_link

      t.timestamps
    end
  end
end
