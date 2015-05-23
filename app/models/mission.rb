class Mission < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates_presence_of :month, :year, :user_id

  def name
    project.try(:name) || project_placeholder_description
  end

  def project
    if real_project = super
      real_project
    else
      project_placeholder_description
    end
  end

  def time
    Time.zone.local(year, month)
  end
end
