class AddDifficultyLevelToColors < ActiveRecord::Migration
  def change
    add_column :colors, :difficulty_level, :string
  end
end
