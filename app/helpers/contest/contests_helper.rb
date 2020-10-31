module Contest
  module ContestsHelper
    def contest_has_projects contest
      contest.contest_projects.present?
    end

    def get_contest_company contest
      contest.contest_projects.joins(user: { op_student: :res_company }).pluck('res_company.name', 'res_company.id').uniq
    end
  end
end
