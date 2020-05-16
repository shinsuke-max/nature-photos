class RegistrationsController < Devise::RegistrationsController
  before_action :forbid_test_user, {only: [:edit,:update,:destroy]}

  protected

    def update_resource(resource, params)
      resource.update_without_current_password(params)
    end

    def after_update_path_for(resource)
      user_path(resource)
    end

    def forbid_test_user
      if @user.email == "test@example.com"
        flash[:notice] = "テストユーザーのため変更できません"
        redirect_to root_path
      end
    end
end
