module Contest
  module ContestsHelper
    def contest_has_projects contest
      contest.contest_projects.present?
    end

    def get_contest_company contest
      contest.contest_projects.joins(user: { op_student: :res_company }).pluck('res_company.name', 'res_company.id').uniq
    end

    def can_award_month_prize? contest
      time_range = Time.now.beginning_of_month..Time.now.end_of_month
      topic = contest.contest_topics.where(start_time: time_range).order(start_time: :DESC).first

      Time.now >= topic.end_time
    end
  end
end
