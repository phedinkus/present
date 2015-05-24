$ ->
  return unless $('#dossiers-page').length > 0
  $('select').on('chosen:ready', (e, data) ->
    $(e.target).data('chosen', data.chosen)
  ).chosen
    allow_single_deselect: true
    no_results_text: "Set a free-form project description of"
    width: "80%"

  assignCustomProjectText = (e) ->
    $chooser = $(e.target).closest('.chosen-container')
    $form = $chooser.closest('form')
    $select = $chooser.prev('select')
    chosen = $select.data('chosen') #<- set by us in the chosen:ready callback
    projectPlaceholderDescription = $chooser.find('.chosen-search input').val().trim()

    $select.val('')
    $form.find('[name="mission[project_placeholder_description]"]').val(projectPlaceholderDescription)
    $select.data('placeholder', projectPlaceholderDescription)

    chosen.results_reset()

    $chooser.find('.chosen-default span:first').text(projectPlaceholderDescription).addClass('overridden-placeholder')

  $('.chosen-container').
    on('click', '.no-results', assignCustomProjectText).
    on 'keyup', '.chosen-search input', (e) ->
      return if $(e.target).closest('.chosen-container').find('.no-results').length == 0
      return unless e.keyCode == 13 #enter
      assignCustomProjectText(e)
