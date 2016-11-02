class AddDefaultToProjectProgress < ActiveRecord::Migration
  def change
    change_column_default :projects, :progress, 0.0
  end
end
