$ ->
  $('.timesheet-form .presence-select').on 'change', (e) ->
    $select = $(e.target)
    $select.siblings('input.hours').toggleClass('hidden', $select.val() != "hourly")
