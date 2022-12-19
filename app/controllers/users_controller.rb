class UsersController < ApplicationController
  def create
    @user = User.create(user_params)
    @user.save

    if @user.valid?
      render json: @user
    else
      render json: @user.errors.full_messages
    end
  end

  def index
    render json: User.all
  end

  def update
    response_data = { status: false, result: {}, error: {} }

    begin
      user = User.find_by(id: params[:id])

      if user
        user.assign_attributes(name: params[:name])
        user.assign_attributes(email: params[:email])
        user.assign_attributes(phone_number: params[:phone_number])

        user.save

        if user.valid?
          response_data[:status]        = true
          response_data[:result][:user] = user
        else
          response_data[:error][:user]  = user.errors.full_messages
        end
      else
        response_data[:error][:user] = "User not found"
      end

    rescue Excpetion => ex
      response_data[:error][:user] = ex.message
    end

    render json: response_data
  end

  def destroy
    response_data = { status: false, result: {}, error: {} }

    begin
      user = User.find_by(id: params[:id])

      if user && user.destroy
        response_data[:status]           = true
        response_data[:result][:message] = "Successfully deleted user"
      else
        response_data[:error][:user] = "User not found"
      end

    rescue Exception => ex
      response_data[:error][:user] = ex.message
    end

    render json: response_data
  end

  private
  def user_params
    params.permit(:name, :email, :phone_number)
  end
end
