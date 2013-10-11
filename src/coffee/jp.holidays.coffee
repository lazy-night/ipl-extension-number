###

    日本の休日を JavaScript で計算するためのライブラリ
                         Osamu Takeuchi <osamu@big.jp>

    ChangeLog
        2013.04.17 初出

    Date クラスに以下の関数を追加する

    **** Date::isHoliday(furikae = true)

    指定された日が休日かどうかを判定して、休日なら名前を返す
    休日でなければ null を返す
    furikae に false を指定すると振替休日を除く
    内部ではキャッシュした値を使って計算するため繰り返し呼ぶ
    際にはとても高速に動作する

    JavaScript:

      today = new Date();
      holiday = today.isHoliday();
      if(holiday) {
          alert("今日は " + holiday + " です<br/>");
      } else {
          alert("今日は祝日ではありません<br/>");
      }


    **** Date.getHolidaysOf(year, furikae = true)

    指定された年の休日を配列にして返す
    配列には {month:m, date:d, name:s} の形で表わされた休日が日付順に並ぶ
    furikae に false を指定すると、振替休日および国民の休日を除く

    JavaScript：

    today = new Date();
    holidays = Date.getHolidaysOf( today.getFullYear() );
    for(holiday in holidays) {
        document.write(
            holiday.month + "月" + holiday.date + "日は " +
            holiday.name + " です<br/>"
        );
    }


   **** Date::getShifted(year, mon, day, hour, min, sec, msec )

    元の時刻から指定時間だけずらした時刻を生成して返す
    負の数も指定できる

    d = new Date();
    d.getShifted(1);        # １年後の時刻
    d.getShifted(0, -10);   # １０ヶ月前の時刻
    d.getShifted(0,0,0,1);  # １時間後の時刻

###

Date::getShifted = (year, mon, day, hour, min, sec, msec) ->
    # まずは日付以下の部分を msec に直して処理する
    res = new Date()
    res.setTime( @getTime() +
        (((( day ? 0 ) * 24 + ( hour ? 0 )) * 60 + ( min ? 0 )) * 60 +
                                ( sec ? 0 )) * 1000 + ( msec ? 0 )
    )
    # 年と月はちょっと面倒な処理になる
    res.setFullYear res.getFullYear() + ( year ? 0 ) +
       Math.floor( ( res.getMonth() + ( mon ? 0 ) ) / 12 )
    res.setMonth ( ( res.getMonth() + ( mon ? 0 ) ) % 12 + 12 ) % 12
    return res

###
    ヘルパ関数
###

# 年を与えると指定の祝日を返す関数を作成
simpleHoliday = (month, day) ->
    (year) -> new Date(year, month-1, day)


# 年を与えると指定の月の nth 月曜を返す関数を作成
happyMonday = (month, nth) ->
    (year) ->
        monday = 1
        first = new Date(year, month-1, 1)
        first.getShifted( 0, 0,
            ( 7 - ( first.getDay() - monday ) ) % 7 + ( nth - 1 ) * 7
        )


# 年を与えると春分の日を返す
shunbun = (year) ->
    date = new Date()
    date.setTime( -655910271894.040039 + 31556943676.430065 * (year-1949) + 24*3600*1000/2 )
    new Date(year, date.getMonth(), date.getDate())


# 年を与えると秋分の日を返す
shubun = (year) ->
    date = new Date()
    date.setTime( -671361740118.508301 + 31556929338.445450 * (year-1948) + 24.3*3600*1000/2 )
    new Date(year, date.getMonth(), date.getDate())


###
    休日データ
    https://ja.wikipedia.org/wiki/%E5%9B%BD%E6%B0%91%E3%81%AE%E7%A5%9D%E6%97%A5
###

definition = [
    [ "元旦",               simpleHoliday( 1,  1), 1949       ],
    [ "成人の日",           simpleHoliday( 1, 15), 1949, 1999 ],
    [ "成人の日",           happyMonday(   1,  2), 2000       ],
    [ "建国記念の日",       simpleHoliday( 2, 11), 1967       ],
    [ "昭和天皇の大喪の礼", simpleHoliday( 2, 24), 1989, 1989 ],
    [ "春分の日",           shunbun,               1949       ],
    [ "明仁親王の結婚の儀", simpleHoliday( 4, 10), 1959, 1959 ],
    [ "天皇誕生日",         simpleHoliday( 4, 29), 1949, 1988 ],
    [ "みどりの日",         simpleHoliday( 4, 29), 1989, 2006 ],
    [ "昭和の日",           simpleHoliday( 4, 29), 2007       ],
    [ "憲法記念日",         simpleHoliday( 5,  3), 1949       ],
    [ "みどりの日",         simpleHoliday( 5,  4), 2007       ],
    [ "こどもの日",         simpleHoliday( 5,  5), 1949       ],
    [ "徳仁親王の結婚の儀", simpleHoliday( 6,  9), 1993, 1993 ],
    [ "海の日",             simpleHoliday( 7, 20), 1996, 2002 ],
    [ "海の日",             happyMonday(   7,  3), 2003       ],
    [ "敬老の日",           simpleHoliday( 9, 15), 1966, 2002 ],
    [ "敬老の日",           happyMonday(   9,  3), 2003       ],
    [ "秋分の日",           shubun,                1948       ],
    [ "体育の日",           simpleHoliday(10, 10), 1966, 1999 ],
    [ "体育の日",           happyMonday(  10,  2), 2000       ],
    [ "文化の日",           simpleHoliday(11,  3), 1948       ],
    [ "即位の礼正殿の儀",   simpleHoliday(11, 12), 1990, 1990 ],
    [ "勤労感謝の日",       simpleHoliday(11, 23), 1948       ],
    [ "創立記念日",         simpleHoliday(12, 10), 1988       ],
    [ "天皇誕生日",         simpleHoliday(12, 23), 1989       ],
]


# 休日を与えるとその振替休日を返す
# 振り替え休日がなければ null を返す
furikaeHoliday = (holiday) ->
    # 振替休日制度制定前 または 日曜日でない場合 振り替え無し
    sunday = 0
    if holiday < new Date(1973, 4-1, 30-1) or holiday.getDay() != sunday
        return null
    # 日曜日なので一日ずらす
    furikae = holiday.getShifted(0, 0, 1)
    # ずらした月曜日が休日でなければ振替休日
    if !furikae.isHoliday(false)
        return furikae
    # 旧振り替え制度では１日以上ずらさない
    if holiday < new Date(2007, 1-1,  1)
        return null # たぶんこれに該当する日はないはず？
    loop
        # 振り替えた結果が休日だったら１日ずつずらす
        furikae = furikae.getShifted(0, 0, 1)
        if !furikae.isHoliday(false)
            return furikae


# 休日を与えると、翌日が国民の休日かどうかを判定して、
# 国民の休日であればその日を返す
kokuminHoliday = (holiday) ->
    if holiday.getFullYear() < 1988 # 制定前
        return null
    # ２日後が振り替え以外の祝日か
    if !holiday.getShifted(0, 0, 2).isHoliday(false)
        return null
    sunday = 0
    monday = 1
    kokumin = holiday.getShifted(0, 0, 1)
    if kokumin.isHoliday(false) or  # 次の日が祝日
       kokumin.getDay()==sunday or  # 次の日が日曜
       kokumin.getDay()==monday     # 次の日が月曜（振替休日になる）
        return null
    return kokumin


#
# holidays[furikae] = {
#    1999:
#      "1,1": "元旦"
#      "1,15": "成人の日"
#      ...
# }
#
holidays = { true: {}, false: {} }

getHolidaysOf = (y, furikae) ->
    # キャッシュされていればそれを返す
    furikae = if !furikae? or furikae then true else false
    cache = holidays[furikae][y]
    return cache if cache?
    # されてなければ計算してキャッシュ
    # 振替休日を計算するには振替休日以外の休日が計算されて
    # いないとダメなので、先に計算する
    wo_furikae = {}
    for entry in definition
        continue if entry[2]? && y < entry[2]   # 制定年以前
        continue if entry[3]? && entry[3] < y   # 廃止年以降
        holiday = entry[1](y)                   # 休日を計算
        continue unless holiday?                # 無効であれば無視
        m = holiday.getMonth()+1                # 結果を登録
        d = holiday.getDate()
        wo_furikae[ [m,d] ] = entry[0]
    holidays[false][y] = wo_furikae

    # 国民の休日を追加する
    kokuminHolidays = []
    for month_day of wo_furikae
        month_day = month_day.split(",")
        holiday = kokuminHoliday( new Date(y, month_day[0]-1, month_day[1] ) )
        if holiday?
            m = holiday.getMonth()+1            # 結果を登録
            d = holiday.getDate()
            kokuminHolidays.push([m,d])
    for holiday in kokuminHolidays
        wo_furikae[holiday] = "国民の休日"

    # 振替休日を追加する
    w_furikae = {}
    for month_day, name of wo_furikae
        w_furikae[month_day] = name
        month_day = month_day.split(",")
        holiday = furikaeHoliday( new Date(y, month_day[0]-1, month_day[1] ) )
        if holiday?
            m = holiday.getMonth()+1            # 結果を登録
            d = holiday.getDate()
            w_furikae[ [m,d] ] = "振替休日"
    holidays[true][y] = w_furikae               # 結果を登録
    return holidays[furikae][y]

Date.getHolidaysOf = (y, furikae) ->
    # データを整形する
    result = []
    for month_day, name of getHolidaysOf(y, furikae)
        result.push(
            month : parseInt(month_day.split(",")[0])
            date  : parseInt(month_day.split(",")[1])
            name  : name
        )
    # 日付順に並べ直す
    result.sort( (a,b)-> (a.month-b.month) or (a.date-b.date) )
    result

Date::isHoliday = (furikae) ->
    return getHolidaysOf(@getFullYear(), furikae)[ [@getMonth()+1, @getDate()] ]
