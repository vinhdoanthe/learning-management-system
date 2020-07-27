class AddOrderPriorityToPublicCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :public_courses, :order_in_list, :integer
  end
end
