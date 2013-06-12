$ ->
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

  extNo = (extNo) ->
    if extNo?
      extNo
    else
      ""

  getNow = ->
    now = new Date()
    "#{now.getFullYear()}/#{now.getMonth()+1}/#{now.getDate()} #{now.getHours()}:#{now.getMinutes()}"

  api = "http://192.168.5.41:10000/api"

  jQuery.getJSON api + "/extension_number?callback=?", (json) ->
    #$("div.span2 > div").addClass("row-fluid")
    tag = "div"
    for user in json.users
      content = "<#{tag} id=\"no-#{user.employeeNo}\" class=\"user\" title=\"社員番号:#{user.employeeNo}\">#{user.kanji}</#{tag}>"
      content +=  "<#{tag} class=\"seat #{telOrPhs(user.isPhs?)}\">#{extNo(user.extNo)}</#{tag}>"
      $("##{user.seat}").append(content).addClass(group(user.group))

    jQuery.getJSON api + "/schedule/today?callback=?", (schedules) ->
      for schedule in schedules
        continue if schedule.status == "　"
        target = $("#no-#{schedule.employeeNo}").parent()
        target.append("<div class=\"status\" title=\"#{schedule.status}\">#{schedule.status}</div>")
        target.append("<div class=\"defaultStatus\" title=\"#{schedule.default}\">#{schedule.default}</div>")

    modal = $("#modalSchedule")
    label = $("#modalLabel")
    modalBody = $("#modalSchedule > .modal-body")
    $("div.user").click ->
      target = $(this)
      employeeNo = target.attr("id").slice(3)
      jQuery.getJSON("#{api}/schedule/#{employeeNo}?callback=?", (json) ->
        html = ""
        for day in json
          html += "<p>#{day.day}(#{day.dayOfWeek}): #{day.status}</p>"
        label.html("#{target.html()}さんの予定")
        modalBody.html(html)
        modal.modal()
      )

  $("#date").html("取得: " + getNow())
