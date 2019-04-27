# frozen_string_literal: true

class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.string :in_url
      t.text :out_url
      t.integer :http_status
      t.integer :counter
      t.string :title

      t.timestamps
    end

    add_index :links, :in_url
    add_index :links, :counter
  end
end
