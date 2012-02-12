###
ProTweets Main CoffeeScript
###

$ ->
  console.log "CoffeeScript works"

  $('li').hoverIntent
    over: ->
      $(@).find('.tweet-text').fadeIn 500
    out: ->
      $(@).find('.tweet-text').fadeOut 500
    timeout: 500
