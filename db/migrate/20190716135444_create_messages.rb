class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.integer :number, null: false
      t.references :chat, foreign_key: true
      t.text :body, null: false

      t.timestamps
    end
  end
end
