class Contest::AwardsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    c_project = Contest::ContestProject.where(id: params[:project_id]).first
    return if c_project.blank?
    @prize = c_project.contest_prize&.prize_type
    @c_project_detail = Contest::ContestsService.new.contest_project_detail c_project
    @contest = c_project.contest
  end
end
