
# For a User to sign-in,
# 1) User makes a POST request sending email and password
# 2) In our controller, we check if email and password match!
# 3) If it does, we generate an auth token and render it to the user
#       so that the user can send us e-mail + token for an authenticated request
# 4) If it doesn't, we tell the user "Sorry wrong credentials" but within a json

# ZW3qq9xGvcb156Wx9jy1

class Api::V1::RestaurantsController < Api::V1::BaseController

  acts_as_token_authentication_handler_for User, except: [ :index, :show ]
  before_action :set_restaurant, only: [:show, :update, :destroy]

  def index
    @restaurants = policy_scope(Restaurant)
  end

  def show
  end

  def update
    if @restaurant.update(restaurant_params)
      render :show
    else
      render_error
    end
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user

    authorize @restaurant

    if @restaurant.save
      render :show, status: :created
    else
      render_error
    end
  end

  def destroy
    @restaurant.destroy

    # we could render the index
    # we could just render a json saying "deleted successfully"
    # render json: {
    #   message: "Deleted successfully"
    # }, status: 200

    head :no_content
  end
  
  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :address)
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
  end

  def render_error
    render json: { errors: @restaurant.errors.full_messages },
      status: :unprocessable_entity
  end
end