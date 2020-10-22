module Contest
  module ContestsHelper
    def contest_has_projects contest
      contest.contest_projects.present?
    end
  end
end
