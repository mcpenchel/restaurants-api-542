class RestaurantPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def update?
    # record is the instance that you sent on the authorize method
    # user is the current_user
    is_owner?
  end

  def create?
    true
  end

  def destroy?
    is_owner?
  end

  def is_owner?
    record.user == user
  end
end
