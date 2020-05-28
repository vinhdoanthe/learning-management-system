class SocialCommunity::Leader
  attr_accessor :name, :center, :star

  def initialize(user)
    if user.is_student?
      @name = user.student_name
      @center = user.center_name
      @star = user.star
      @star = 0 if @star.nil?
    else
      @name = ''
      @center = ''
      @star = 0
    end
  end
end
