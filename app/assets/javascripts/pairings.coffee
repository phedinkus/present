$ ->
  return unless $('.pairing').length > 0
  $('#wants_reminder').on 'change', (e) ->
    if $(e.target).val() == "true" && $('input.days').val() == ""
      $('input.days').val(7)
