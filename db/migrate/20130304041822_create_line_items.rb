class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :performer_id
      t.integer :bucket_id

      t.timestamps
    end
  end
end
