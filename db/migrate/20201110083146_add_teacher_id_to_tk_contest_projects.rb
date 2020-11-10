class AddTeacherIdToTkContestProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :tk_contest_projects, :teacher_id, :integer
    add_column :tk_contests, :event_link, :string
  end
end
