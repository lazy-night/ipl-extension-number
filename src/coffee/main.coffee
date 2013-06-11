$ ->
  api = "http://192.168.5.41:10000/api"
  jQuery.getJSON api + "/extension_number?callback=?", (json) ->
    #$("div.span2 > div").addClass("row-fluid")
    tag = "div"
    for user in json.users
      content = "<#{tag} id=\"no-#{user.employeeNo}\" class=\"user\">#{user.kanji}</#{tag}>"
      if user.extNo?
        content +=  "<#{tag} class=\"seat #{telOrPhs(user.isPhs?)}\">#{user.extNo}</#{tag}>"
      $("##{user.seat}").append(content).addClass(group(user.group))

    jQuery.getJSON api + "/schedule?callback=?", (schedules) ->
      for schedule in schedules
        continue if schedule.status == "　"
        target = $("#no-#{schedule.employeeNo}")
        html = target.html()
        target.html("<abbr title=\"#{schedule.status}\">#{html}</abbr>")

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


