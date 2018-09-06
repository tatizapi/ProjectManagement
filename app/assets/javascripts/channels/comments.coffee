jQuery(document).on 'turbolinks:load', ->
  comments = $('#comments')
  if $('#comments').length > 0
    comments_to_bottom = -> $('.scroll-down').scrollTop($('.scroll-down')[0].scrollHeight);

    comments_to_bottom()

    App.global_chat = App.cable.subscriptions.create {
        channel: "CommentsChannel"
        ticket_id: comments.data('ticket-id')
      },
      connected: ->
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        comments.append data['comment']
        comments_to_bottom()

      send_comment: (comment, ticket_id) ->
        @perform 'send_comment', comment: comment, ticket_id: ticket_id

      # send_notification: (ticket_id) ->
      #   console.log(ticket_id)
      #   @perform 'send_notification', ticket_id: ticket_id

    $('#new-comment-form').submit (e) ->
      $this = $(this)
      textarea = $this.find('#comment_body')
      if $.trim(textarea.val()).length > 0
        App.global_chat.send_comment textarea.val(), comments.data('ticket-id')
        textarea.val('')
      e.preventDefault()
      return false

  $('#ticket-new-comment-div').submit (e) ->
    console.log("was here")
    # $this = $(this)
    # textarea = $this.find('#comment_body')
    # if $.trim(textarea.val()).length > 0
    #   App.global_chat.send_notification $('#ticket-new-comment-form').data('ticket-id')
    e.preventDefault()
    return false
