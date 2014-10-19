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
  $('.has-tooltip').tooltip()


  $('.timesheet-form .presence-select input[type=radio]').on 'change', (e) ->
    $label = $(e.target).closest('label')
    $label.closest('.presence-select').find('.presence-memo').val($label.data('presence'))
    $label.addClass('color').siblings().removeClass('color')


  $('.location').each (i, el) ->
    $wrap = $(el)
    $link = $wrap.find('.location-open')

    $link.popover(html: true).on 'click', ->
      $link.popover('show').on 'shown.bs.popover', ->
        $wrap.find('select[name="location_id"]').val($link.data('locationId')).removeClass('invisible')

    $wrap.on 'click', '.location-cancel', ->
      $link.popover('hide')

    $wrap.on 'click', '.location-set', (e) ->
      $button = $(e.target).prop('disabled', true)
      newLocationId = parseInt($wrap.find('select[name="location_id"]').val(), 10)
      $affectedLinks = if $link.data('model') == "timesheet" then $('.location-open').not($link) else $link

      $link.data('locationId', newLocationId)
      xhr = $.post '/entries/set_locations',
        model_id: $link.data('modelId')
        model: $link.data('model')
        location_id: newLocationId

      xhr.done ->
        $affectedLinks.toggleClass('customized', $('#current_user_location').data('locationId') != newLocationId)
        renderAlert("Location updated!", "success")
      xhr.fail -> renderAlert("Failed to set location!")
      xhr.always -> $link.popover('hide')

  addingProject = false
  $('.add-project').on 'click', 'button', (e) ->
    return false if addingProject
    $(e.target).addClass('disabled')
    addingProject = true
