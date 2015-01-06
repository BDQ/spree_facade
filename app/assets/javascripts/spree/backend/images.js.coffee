$ ->
  $('a.add_image').on 'click', (event) ->
    event.preventDefault()

    link = $(this)
    path = link.data('path')
    field = {'type': 'image'}
    count = parseInt(link.data('count'))

    #increment count for next call
    link.data('count', count+1)

    #fetch template
    template = JST['spree/backend/templates/pages/image']
    div = $('div#' + link.data('id'))

    #append template
    div.append template({"path": path, "field": field, "i": count})
