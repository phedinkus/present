$ ->
  return unless $('.pairing').length > 0
  $('#wants_reminder').on 'change', (e) ->
    if $(e.target).val() == "true"
      $days = $('input.days')
      $days.val(7) if $days.val() == ""
      $days.focus()
