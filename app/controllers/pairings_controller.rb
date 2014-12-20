class PairingsController < ApplicationController
  def index
    @poster_digits = [AccidentalPairing.days_since_last_pairing_for(@current_user),99].compact.min.to_s.split("")
    @accidental_pairings = AccidentalPairing.for_user(@current_user).order('paired_at desc')
  end

  def create
    ap = AccidentalPairing.create!(params[:accidental_pairing].permit(:description).merge(:user => @current_user, :paired_at => Time.zone.now))
    redirect_to accidental_pairings_path
  end

  def update_user_settings
    reminder_days =  params[:user][:days_between_pair_reminders].to_i if params[:wants_reminder] == "true"
    unless @current_user.update(:days_between_pair_reminders => reminder_days)
      flash[:error] = @current_user.errors.full_messages
    end
    redirect_to accidental_pairings_path
  end
end
