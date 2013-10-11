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

  api = "http://192.168.5.67:9292/api"

  updateStatus = (schedules) ->
    for schedule in schedules
      target = $("#no-#{schedule.employeeNo}").parent()
      appended = ''
      if schedule.status != "　"
        appended += "<div class=\"status\" title=\"#{schedule.status}\">#{schedule.status}</div>"
      else
        appended += "<div class=\"emptyStatus\">&nbsp;</div>"
      appended += "<div class=\"defaultStatus\" title=\"#{schedule.default}\">#{schedule.default}</div>"
      target.append(appended)
      target.addClass("out") if schedule.out == true

  addClickEvent = ->
    modal = $("#modalSchedule")
    label = $("#modalLabel")
    modalBody = $("#modal-body")
    $(".user").click ->
      target = $(this)
      employeeNo = target.attr("id").slice(3)
      date = new Date()
      jQuery.getJSON("#{api}/schedule/#{employeeNo}?callback=?", (json) ->
        html = ""
        for day in json
          html += "<p><span class=\"#{holidaySpan(date)}\" title=\"#{holidayName(date)}\">#{day.day}(#{day.dayOfWeek})</span>: #{day.status}</p>"
          date.setDate(date.getDate() + 1)
        label.html("#{target.html()}さんの予定")
        modalBody.html(html)
        modal.modal()
      )

  holidaySpan = (date) ->
    return "holiday"  if date.isHoliday(true)
    return "saturday" if date.getDay() == 6
    return "sunday"   if date.getDay() == 0
    return ""

  holidayName = (date) ->
    date.isHoliday(true) || ""

  updateUserInfo = (users) ->
    for user in users
      content = "<div id=\"no-#{user.employeeNo}\" class=\"user\" title=\"社員番号:#{user.employeeNo}\">#{user.kanji}</div>"
      content +=  "<div class=\"seat #{telOrPhs(user.isPhs?)}\">#{extNo(user.extNo)}</div>"
      $("##{user.seat}").append(content).addClass(group(user.group))

  jQuery.getJSON api + "/extension_number?callback=?", (json) ->
    updateUserInfo json.users
    jQuery.getJSON api + "/schedule/today?callback=?", updateStatus
    addClickEvent()

  $("#date").html("取得: " + getNow())
