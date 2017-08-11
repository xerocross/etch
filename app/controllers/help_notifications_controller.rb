class HelpNotificationsController < ApplicationController
  before_action :authenticate

  
  def create
    help_notification = HelpNotification.new(help_notification_params)
    help_notification.user = @user
    help_notification.save!
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    # Never trust parameters from the scary internet, only allow the white list through.
    def help_notification_params
      params.require(:help_notification).permit(:tip_id)
    end
end
