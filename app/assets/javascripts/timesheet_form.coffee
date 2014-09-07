$ ->
  return unless $('#timesheet_form').length > 0

  renderAlert = (message, mode = 'danger') ->
    $('.alert-area').html """
        <div class="alert alert-#{mode} fade in" role="alert">
          <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
          #{message}
        </div>
      """

  checkboxMakesVisible = (checkbox, target) ->
    $checkbox = $(checkbox)
    cb = ->
      $(target).toggleClass('hidden', !$checkbox.prop('checked'))
    $checkbox.on('change', cb)
    setTimeout(cb, 0) #<-- because Bootstrap!

  checkboxMakesVisible('input[name=show_weekends]', '.weekend')
  checkboxMakesVisible('input[name=edit_location]', '.location')

  $('.timesheet-form .presence-select input[type=radio]').on 'change', (e) ->
    $(e.target)
      .closest('label')
      .toggleClass('btn-info', $(e.target).prop('checked'))
      .siblings().removeClass('btn-info')

  $('.location').each (i, el) ->
    $wrap = $(el)
    $link = $wrap.find('.location-open')

    $link.popover(html: true).on 'click', -> $link.popover('show')

    $wrap.on 'click', '.location-cancel', ->
      $link.popover('hide')

    $wrap.on 'click', '.location-set', (e) ->
      $button = $(e.target).prop('disabled', true)

      xhr = $.post '/entries/set_locations',
        model_id: $link.data('model-id')
        model: $link.data('model')
        location_id: $wrap.find('select[name="location_id"]').val()

      xhr.done -> renderAlert("Location updated!", "success")
      xhr.fail -> renderAlert("Failed to set location!")
      xhr.always -> $link.popover('hide')
