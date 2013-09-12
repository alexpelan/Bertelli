class CreatePerformers < ActiveRecord::Migration
  def change
  	drop_table :performers
    create_table :performers do |t|
      t.string :name
      t.string :ticket_url
      t.string :image_url

      t.timestamps
    end
  end
end
