class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :number, null: false
      t.integer :messages_count
      t.references :application, foreign_key: true

      t.timestamps
    end
  end
end
