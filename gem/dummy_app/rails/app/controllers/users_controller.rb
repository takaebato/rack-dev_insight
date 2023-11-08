class UsersController < ApplicationController
  def create
    User.create!(user_params)
  end

  def update
    @user = User.find(params[:id])
    @user.update!(params.fetch(:user, {}))

    render json: @user, status: :created
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
