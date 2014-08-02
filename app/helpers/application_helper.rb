module ApplicationHelper
  def css_class_for_flash_key(name)
    case name
      when "info" then "success"
      when "error" then "danger"
    end
  end
end
