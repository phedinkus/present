class NullClient < Client
  def present?
    false
  end

  def blank?
    true
  end

  def _create_record
  end
  def _update_record
  end

  def name
  end
end
