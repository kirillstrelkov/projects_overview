# frozen_string_literal: true

class CreateDueDates < ActiveRecord::Migration
  def change
    create_table :due_dates do |t|
      t.string :name
      t.string :description
      t.datetime :date
      t.float :progress
      t.references :project, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
