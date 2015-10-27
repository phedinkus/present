module HarvestHelper
  def respond_to_harvest_creation(target, redirect_path)
    if target.id?
      flash[:info] = ["#{target.class.uppercase} #{target.name} created!"]
      redirect_to redirect_path
    else
      flash[:error] = ["Project creation failed!"] + target.errors.full_messages
      render :edit
    end
  end
end
