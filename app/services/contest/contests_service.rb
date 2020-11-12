class Contest::ContestsService
  require 'erb'
  require 'net/http'

  def leader_board contest_id
    #student_name, topic, c_project_id, res_company => region, week???????????????/
    contest = Contest::Contest.where(id: contest_id).first
    week_projects = contest.contest_projects.joins(:contest_topic).joins(:contest_prize).joins(:student_project).joins(user: { op_student: :res_company }).where(contest_id: contest.id).where(tk_contest_prizes: { prize_type: 'w', prize: 1 }).select(:id, :user_id, 'op_student.full_name as student_name', 'tk_contest_topics.id as topic_id', 'tk_contest_topics.week_number as week_number', 'tk_contest_topics.start_time as topic_start').order(created_at: :DESC).limit(8)

    month_project = contest.contest_projects.joins(:contest_topic).joins(:contest_prize).joins(:student_project).joins(user: { op_student: :res_company }).where(contest_id: contest.id).where(tk_contest_prizes: { prize_type: 'm', prize: 1 }).select(:id, :user_id, 'op_student.full_name as student_name', 'tk_contest_topics.id as topic_id', 'tk_contest_topics.week_number as week_number', 'tk_contest_topics.start_time as topic_start').order(created_at: :DESC).first
    [week_projects, month_project, contest]

  end

  def week_projects contest, time_type
    if time_type == 'current'
      topic = contest.contest_topics.where(start_time: Time.now.beginning_of_week..Time.now.end_of_week).first
    elsif time_type == 'last_week'
      topic = contest.contest_topics.where(start_time: (Time.now - 7.days).beginning_of_week..(Time.now - 7.days).end_of_week).first
    end

    return [ [], {} ] if topic.blank?

    w_projects =  topic.contest_projects.joins(user: { op_student: :res_company }).joins(:student_project).joins(:project_criterions).order(score: :DESC).select('distinct(tk_contest_projects.id)', :created_at, :user_id, 'op_student.full_name as student_name', 'sc_student_projects.name as project_name', :views, :score, 'res_company.name as company_name', :project_id).limit(10)

    project_ids = w_projects.pluck(:project_id)
    w_project_imgs = {}

    project_ids.each do |id|
      project = SocialCommunity::ScStudentProject.where(id: id).first

      next if project.blank?
      w_project_imgs.merge!( { project.id => project.image })
    end

    [ w_projects, w_project_imgs ]
  end

  def awarded_projects contest, type, page
    awarded_projects = contest.contest_projects
      .joins(:contest_prize)
      .where(tk_contest_prizes: { prize: '1', prize_type: type })

    awarded_projects = awarded_projects.page(page).per(20) if type == 'w'

    awarded_projects
  end

  def contest_project_detail c_project
    project = c_project.student_project
    return {} if project.blank?
    like = c_project.project_criterions.joins(:contest_criterion).where(tk_contest_criterions: { name: 'like' }).first&.number.to_i
    share = c_project.project_criterions.joins(:contest_criterion).where(tk_contest_criterions: { name: 'share' }).first&.number.to_i
    user = c_project.user
    user_avatar = user.avatar&.thumbnail
    project_img = project.image

    student = project.op_student
    company = student.res_company
    company_name = company&.name
    company_id = company&.id
    
    details = c_project.as_json
    details.merge! ({ 'user_avatar' => user_avatar, 'project_name' => project.name, 'project_img' => project_img, 'created_at' => c_project.created_at, 'student_name' => student.full_name, 'like' => like, 'share' => share, 'views' => c_project.views, 'company_name' => company_name, 'company_id' => company_id })

    details
  end

  def update_fb_social_count active_projects
    # get active projects
    # TODO update how to get active projects
    #active_projects = Contest::ContestProject.all

    # call FB graph API and update for each project
    active_projects.each do |project|
      begin
      plain_url = "https://lms.teky.online/contest/contest_projects/show/#{project.id}"
      encoded_url = ERB::Util.url_encode(plain_url)
      url = URI("https://graph.facebook.com/v8.0/?id=#{encoded_url}&fields=engagement&access_token=#{Settings.fbapp_access_token}")

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Get.new(url)
      request["Content-Type"] = "application/x-www-form-urlencoded"
      request.body = "access_token=#{Settings.fbapp_access_token}"

      response = https.request(request)
      puts response.read_body
      data = JSON.parse(response.read_body)
      # TODO: update project here...
      #
      Contest::ContestProjectsService.new.update_project_criterion project, data
      rescue StandardError => e
        puts "#{ project.id }: #{ e }"
      end
    end
  end

  def contest_projects params
    start_time = Time.parse(params[:start_time]).beginning_of_day
    end_time = Time.parse(params[:end_time]).end_of_day

    contest = Contest::Contest.where(id: params[:contest_id]).first

    if params[:topic_id].blank?
      projects  = contest.contest_projects.where(contest_id: contest.id, created_at: start_time..end_time)
    else
      projects  = contest.contest_projects.where(contest_id: contest.id, contest_topic_id: params[:topic_id])
    end

    projects = projects.joins(student_project: { op_student: :res_company }).where(res_company: { id: params[:company_id] }) if params[:company_id] != 'all'

    projects.page(params[:page]).per(20)
  end
end
