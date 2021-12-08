class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.owner?
      can :manage, :all
    elsif user.customer?
      can :read, :all
    end
  end
end
