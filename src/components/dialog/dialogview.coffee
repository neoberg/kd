KDView        = require './../../core/view.coffee'
KDOverlayView = require './../overlay/overlayview.coffee'
KDButtonView  = require './../buttons/buttonview.coffee'

module.exports = class KDDialogView extends KDView

  constructor: (options = {}, data) ->

    options.duration  or= 200
    options.topOffset or= 0
    options.offset     ?= yes
    options.buttons   or=
      Cancel            :
        style           : "clean-red"
        callback        : => @hide()

    super options, data

    @setClass "kddialogview"
    @$().hide()
    @setButtons()
    @setTopOffset()

  show:->
    {duration} = @getOptions()
    @overlay   = new KDOverlayView
    @$overlay  = @overlay.getDomElement()

    @overlay.on "click", => @hide()

    @$().slideDown duration

  hide:->
    {duration} = @getOptions()
    @$overlay.fadeOut duration,()=>
      @$overlay.remove()

    @$().slideUp duration,()=>
      @destroy()

  setButtons:->
    {buttons} = @getOptions()
    @buttons = {}
    @buttonHolder = new KDView {cssClass : "kddialog-buttons clearfix"}
    @addSubView @buttonHolder
    for own buttonTitle,buttonOptions of buttons
      @createButton buttonTitle,buttonOptions

  createButton:(title,buttonOptions)->
    @buttonHolder.addSubView button = new KDButtonView
      title       : title
      loader      : buttonOptions.loader    if buttonOptions.loader?
      style       : buttonOptions.style     if buttonOptions.style?
      callback    : buttonOptions.callback  if buttonOptions.callback?
    @buttons[title] = button

  setTopOffset:->
    {topOffset} = @getOptions()
    @$().css "top",topOffset
