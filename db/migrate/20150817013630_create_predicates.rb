class CreatePredicates < ActiveRecord::Migration
  def change
    create_table :predicates do |t|
      t.integer :chat_session_id
      t.timestamps null: false
      t.text :predicates_json
    end

    add_index :predicates, :chat_session_id
  end
end
