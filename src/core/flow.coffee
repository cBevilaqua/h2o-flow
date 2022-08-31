# 
# TODO
#
# XXX how does cell output behave when a widget throws an exception?
# XXX GLM case is failing badly. Investigate. Should catch/handle gracefully.
#
# tooltips on celltype flags
# arrow keys cause page to scroll - disable those behaviors
# scrollTo() behavior

application = require('./modules/application')
context = require("./modules/application-context")
h2oApplication = require('../ext/modules/application')

ko = require('./modules/knockout')

getZooxEyeToken = () ->
    params = new URLSearchParams(window.location.search)
    token = null
    urlToken = params.get('zooxeye-token')
    localStorageToken = localStorage.getItem('zooxeyeToken')
    if urlToken
      localStorage.setItem('zooxeyeToken', urlToken)
      return urlToken
    else if localStorageToken
      return localStorageToken
    return null

$.ajaxSetup
    beforeSend: (xhr, settings) ->
      token = getZooxEyeToken()
      xhr.setRequestHeader("Authorization", "Bearer #{token}")

getContextPath = (_) ->
    if process.env.NODE_ENV == "development"
      console.debug "Development mode, using localhost:54321"
      _.ContextPath = "http://localhost:54321/"
    else
      url = window.location.toString()
      if !url.endsWith("flow/index.html")
        console.warn("URL does not have expected form -> does not end with /flow/index.html")
        _.ContextPath = "/"
      else
        _.ContextPath = url.substring(0, url.length - "flow/index.html".length)

checkSparklingWater = (context) ->
    context.onSparklingWater = false
    $.ajax
        url: context.ContextPath + "3/Metadata/endpoints"
        type: 'GET'
        dataType: 'json'
        success: (response) ->
            for route in response.routes
                if route.url_pattern is '/3/scalaint'
                    context.onSparklingWater = true
        async: false

$ ->
  console.debug "Starting Flow"
  getContextPath context
  checkSparklingWater context
  window.flow = application.init context
  h2oApplication.init context
  ko.applyBindings window.flow
  context.ready()
  context.initialized()
  console.debug "Initialization complete", context
