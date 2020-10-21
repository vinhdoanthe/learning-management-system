class AddJudgesScoreToTkContestProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :tk_contest_projects, :judges_score, :integer
  end
end
