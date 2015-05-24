class MissionView
  constructor: (@$select, @chosen) ->
    @$chosen = @$select.next('.chosen-container')
    @$projectPlaceholderHidden = @$select.closest('form').find('[name="mission[project_placeholder_description]"]')
    @wireUpEvents()

  # As soon as Chosen renders:
  init: ->
    @overridePlaceholder(@$projectPlaceholderHidden.val()) if @$projectPlaceholderHidden.val()

  #private

  wireUpEvents: =>
    @$chosen.
      on('click', '.no-results', @setProjectPlaceholder).
      on 'keyup', '.chosen-search input', (e) =>
        return if @$chosen.find('.no-results').length == 0 || e.keyCode != 13 #RETURN/ENTER
        @setProjectPlaceholder(e)
    @$select.on('change', @onChange)

  onChange: =>
    _.defer =>
      if @$chosen.find('.overridden-placeholder').length == 0
        @$projectPlaceholderHidden.val('')

  setProjectPlaceholder: =>
    projectPlaceholderDescription = @$chosen.find('.chosen-search input').val().trim()
    @$select.val('')
    @$projectPlaceholderHidden.val(projectPlaceholderDescription)
    @chosen.results_reset()
    @overridePlaceholder(projectPlaceholderDescription)

  overridePlaceholder: (val) =>
    @$chosen.find('.chosen-default').html("""
      <span><span class="overridden-placeholder"></span></span>
      <abbr class="search-choice-close"></abbr>
      <div><b></b></div>
    """).find('.overridden-placeholder').text(val)

$ ->
  return unless $('#dossiers-page').length > 0
  $('select').on('chosen:ready', (e, data) ->
    new MissionView($(e.target), data.chosen).init()
  ).chosen
    allow_single_deselect: true
    no_results_text: "Set project description to"
    width: "80%"
