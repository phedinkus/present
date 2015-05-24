module DossiersHelper
  def bootstrap_class_for_mission_status(mission)
    case mission.status
      when "available" then "success"
      when "tentative" then "warning"
      when "deployed" then "danger"
    end
  end
end
