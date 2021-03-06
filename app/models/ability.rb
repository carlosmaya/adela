class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :supervisor
      can :create, User
    elsif user.organization
      can :manage, Inventory
    end
  end
end
