
begin
  Rails.application.config.present.reference_invoice_week = SystemConfiguration.instance.reference_invoice_week
rescue ActiveRecord::StatementInvalid
  # ^ This might run before the table is defined during migrations.
end
