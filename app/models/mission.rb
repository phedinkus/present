class Mission < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates_presence_of :month, :year, :user_id

  enum :status => {
    :available => 0,
    :tentative => 1,
    :deployed => 2
  }

  def name
    if real_project
      "#{real_project.client.name} - #{real_project.name}"
    else
      project_placeholder_description
    end
  end

  alias :real_project :project
  def project
    if real_project
      real_project
    else
      project_placeholder_description
    end
  end

  def time
    Time.zone.local(year, month)
  end
end
