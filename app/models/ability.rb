class Ability
  include CanCan::Ability

  def initialize(user)

    #user ||= User.new # guest user (not logged in)

    if user.role == "manager"
      can :read, :all
      can [:update, :destroy], Request
      can :manage, [Order, Shipping, Customer, Store]
    elsif user.role == "seller"
      can :read, :all
      can [:create, :destroy], Request
      can :update, Order
      can :manage, [Customer, Store]
    end

  end
end
