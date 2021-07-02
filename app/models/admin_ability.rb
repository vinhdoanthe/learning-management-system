# frozen_string_literal: true

class AdminAbility
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    return unless user && (user.is_admin? || user.is_content_admin? || user.is_operation_admin?)
    if user.is_admin?
      can :manage, :all
      can :access, :rails_admin       # only allow admin users to ac
    elsif user.is_content_admin?
      can :dashboard, :all
      can :access, :rails_admin
      can :read, :dashboard
      can :edit, [SocialCommunity::ScStudentProject, Learning::Material::Question, Learning::Material::QuestionChoice]
      can :update, SocialCommunity::ScStudentProject
      can :destroy, SocialCommunity::ScStudentProject
      can :index, [SocialCommunity::ScStudentProject, Learning::Course::OpCourse, Learning::Course::CourseDescription, Learning::Course::OpLession, Learning::Material::Question, Learning::Material::QuestionChoice]
      can :show, [SocialCommunity::ScStudentProject, Learning::Course::OpCourse, Learning::Course::CourseDescription, Learning::Course::OpLession, Learning::Material::Question, Learning::Material::QuestionChoice]
    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
