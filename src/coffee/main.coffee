$ ->
  jQuery.getJSON "js/extension_number", (json) ->
    cols = $("#ext-table > div :first")
    for user in json.users
      if user.extNo?
        content = "<p>" + user.kanji + "(" + user.extNo + ")</p>"
      else
        content = "<p>" + user.kanji + "</p>"
      $("#" + user.seat).append(content).addClass(user.group)
