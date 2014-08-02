$ ->
  $('.timesheet-form .presence-select input[type=radio]').on 'change', (e) ->
    $(e.target)
      .closest('label')
      .toggleClass('btn-info', $(e.target).prop('checked'))
      .siblings().removeClass('btn-info')

  $('input[name=show_weekends]').on 'change', updateWeekendVisibility = ->
    $('.weekend').toggleClass('hidden', !$('input[name=show_weekends]').prop('checked'))
  setTimeout(updateWeekendVisibility, 0) #<-- because Bootstrap!
