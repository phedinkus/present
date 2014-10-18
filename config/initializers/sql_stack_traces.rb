if Rails.env.development?
  ruby_stdlib_dir = (require 'base64'; File.dirname(Base64.method(:encode64).source_location.first))
  excluded_stack_frames = Gem.path + [ruby_stdlib_dir]
  ActiveSupport::Notifications.subscribe("sql.active_record") do |_, _, _, _, details|
    if details[:sql] =~ /SELECT/ && details[:name] !="SCHEMA"
      stack_frames = caller.reject { |frame| excluded_stack_frames.any? { |p| frame.start_with?(p) } }
      if stack_frames.present?
        Rails.logger.info "Stack trace for query: \n#{stack_frames.join("\n")}"
      end
    end
  end
end
