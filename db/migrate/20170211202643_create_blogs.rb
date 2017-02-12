class CreateBlogs < ActiveRecord::Migration[5.0]
  def change
    create_table :blogs do |t|
      t.belongs_to :user, index: true
      t.string  :name
    end
  end
end
