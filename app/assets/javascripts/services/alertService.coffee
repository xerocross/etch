alertService = ->
  @alert = (text)->
    alert text
  @confirm = (text)->
    confirm text
  this
app.service('alertService',[alertService]);