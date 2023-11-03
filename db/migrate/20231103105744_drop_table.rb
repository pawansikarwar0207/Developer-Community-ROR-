class DropTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :articles
    drop_table :blogs
    drop_table :post_visits
  end
end
