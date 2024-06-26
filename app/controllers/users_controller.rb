class UsersController < ApplicationController
  after_action :trigger_webhooks

  def create
    user = User.new(user_params)
    unless user.save!
      render json: {error: user.errors.full_messages.join(", ")}, status: :unprocessable_entity
      return
    end

    render json: {data: user}, status: :ok
  end

  def update
    user = User.find_by(id: params[:id])
    unless user.update!(user_params)
      render json: {error: user.errors.full_messages.join(", ")}, status: :unprocessable_entity
      return
    end

    render json: {data: user}, status: :ok
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :dob)
  end

  def trigger_webhooks
    if response.status == 200
      body = JSON.parse(response.body)['data']
      ThirdPartyApi::Notify.new(body).call
    end
  end
end
