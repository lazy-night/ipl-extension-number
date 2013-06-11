$ ->
  jQuery.getJSON "http://192.168.5.41:10000/api/extension_number?callback=?", (json) ->
    #$("div.span2 > div").addClass("row-fluid")
    tag = "div"
    for user in json.users
      content = "<#{tag} class=\"user\">#{user.kanji}</#{tag}>"
      if user.extNo?
        content +=  "<#{tag} class=\"seat #{telOrPhs(user.isPhs?)}\">#{user.extNo}</#{tag}>"
      $("##{user.seat}").append(content).addClass(group(user.group))

  telOrPhs = (isPhs) ->
    if isPhs
      "phs"
    else
      "tel"

  group = (group) ->
    if group?
      group
    else
      "Other"


