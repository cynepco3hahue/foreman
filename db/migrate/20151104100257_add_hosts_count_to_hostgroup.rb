class AddHostsCountToHostgroup < ActiveRecord::Migration
  def up
    add_column :hostgroups, :hosts_count, :integer, :default => 0
  end

  def down
    remove_column :hostgroups, :hosts_count
  end
end
