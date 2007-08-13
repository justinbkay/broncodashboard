class RenameWeekOrder < ActiveRecord::Migration
  def self.up
    #rename_column :weeks, :order, :week_order
    #ALTER TABLE `broncodashboard_development`.`weeks` CHANGE COLUMN `order` `week_order` INTEGER DEFAULT NULL;
  end

  def self.down
    #rename_column :weeks, :week_order, :order
  end
end
