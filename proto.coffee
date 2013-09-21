(->
  window.requestAnimationFrame =
    window.requestAnimationFrame ||
    window.mozRequestAnimationFrame ||
    window.webkitRequestAnimationFrame ||
    window.msRequestAnimationFrame
)()

ob_to_rgba = (ob) ->
  "rgba(#{ob.r}, #{ob.g}, #{ob.b}, #{ob.a})"

drawA = ($scope) ->
  $scope.ctx.clearRect 0, 0, window.innerWidth, window.innerHeight
  if $scope.clear
    $scope.ctx.fillStyle = ob_to_rgba $scope.colors[0]
  else
    $scope.ctx.fillStyle = ob_to_rgba $scope.colors[1]
  $scope.ctx.fillRect 0, 0, window.innerWidth, window.innerHeight

drawB = ($scope) ->
  $scope.ctx.clearRect 30, 30, 55, 70
  if $scope.clear
    $scope.ctx.fillStyle = ob_to_rgba $scope.colors[2]
  else
    $scope.ctx.fillStyle = ob_to_rgba $scope.colors[3]
  $scope.ctx.fillRect 30, 30, 55, 70

window.HertzBlinker = ($scope) ->
  $scope.colors = [
    {r: 100, g: 0, b: 140, a: 0.5},
    {r: 0, g: 100, b: 120, a: 0.9},
    {r: 100, g: 0, b: 100, a: 0.9},
    {r: 100, g: 0, b: 200, a: 0.9},
  ]
  $scope.hertz = 2.1
  $scope.canvas = document.getElementById 'canvas'
  $scope.ctx = canvas.getContext '2d'

  $scope.fullscreen_toggle = () ->
    #console.log "clicked!"
    #console.log $scope.canvas.style
    full = () ->
      $scope.canvas.style.width = document.body.clientWidth
      $scope.canvas.style.height = document.body.clientHeight
      $scope.canvas.style.position = "absolute"
      $scope.canvas.style.top = 0
      $scope.canvas.style.left = 0
      $scope.canvas.style.background = "#fff"
    if $scope.canvas.style.position isnt "absolute"
      $scope.originalcssText = $scope.canvas.style.cssText
      full()
      window.addEventListener 'resize', full
    else
      $scope.canvas.style.cssText = $scope.originalcssText
      window.removeEventListener 'resize', full
      window.onresize = ->

  $scope.then = (new Date()).getTime()
  changeHertz = (newval, oldval) ->
    #$scope.then = (new Date()).getTime()
    $scope.ms = 1000.0 / newval
    #$scope.clear = false
  changeHertz()
  $scope.$watch 'hertz', changeHertz
  ms = 1000.0 / $scope.hertz
  draw = () ->
    #console.log "draw!"
    $scope.now = (new Date()).getTime()
    $scope.diff = $scope.now - $scope.then
    new_clear = (($scope.diff % $scope.ms) / $scope.ms) <= 0.5
    #console.log new_clear, $scope.clear
    if (new_clear isnt $scope.clear)
      drawA $scope
      drawB $scope
      $scope.clear = !$scope.clear
    requestAnimationFrame draw
  window.draw = draw
  $scope.draw = draw
  draw()
  window.scope = $scope
