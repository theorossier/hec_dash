class Dashing.Clock extends Dashing.Widget

  ready: ->
    setInterval(@startTime, 500)
    setInterval(@startTimeChina, 500)
    setInterval(@startTimeQatar, 500)

  startTime: =>
    today = new Date()


    h = today.getHours()
    m = today.getMinutes()
    s = today.getSeconds()
    m = @formatTime(m)
    s = @formatTime(s)
    @set('time', h + ":" + m + ":" + s)
    @set('date', today.toDateString())





  startTimeChina: =>
    todayChina = new Date()

    todayChina.setUTCHours 6

    hc = todayChina.getHours()
    mc = todayChina.getMinutes()
    sc = todayChina.getSeconds()
    mc = @formatTime(mc)
    sc = @formatTime(sc)
    @set('time-china', hc + ":" + mc + ":" + sc)
    @set('date-china', todayChina.toDateString())



  startTimeQatar: =>
    todayQatar = new Date()

    todayQatar.setUTCHours 3

    hq = todayQatar.getHours()
    mq = todayQatar.getMinutes()
    sq = todayQatar.getSeconds()
    mq = @formatTime(mq)
    sq = @formatTime(sq)
    @set('time-qatar', hq + ":" + mq + ":" + sq)
    @set('date-qatar', todayQatar.toDateString())


  formatTime: (i) ->
    if i < 10 then "0" + i else i

   