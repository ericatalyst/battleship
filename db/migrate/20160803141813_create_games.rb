class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :player_1_id, foreign_key: true
      t.integer :player_2_id, default: nil
      t.boolean :player_1_setup, default: false
      t.boolean :player_2_setup, default: false
      t.integer :winner_id

      t.timestamps
    end
  end
end
