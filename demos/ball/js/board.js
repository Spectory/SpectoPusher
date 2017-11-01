var BOARD_SIZE = {
  height: 300 ,
  width: 700
};

var RADIUS = {
  min: 10,
  max: 60
};
var DURATION = {
  max: 1000,
  min: 200
};

var topic1 = 'public:1';

var svgContainer = d3.select("body")
  .append("svg")
  .attr("width", BOARD_SIZE.width)
  .attr("height", BOARD_SIZE.height)
  .style("border", "1px solid black");

var print = function (text, xPos, yPos,color) {
  var scoreText = svgContainer.append('text').text(text)
    .style('font-size', '10px')
    .transition()
    .duration(1000)
    .style('font-size', '70px').style('opacity', '0')
    .attr("x", xPos)
    .attr("y", yPos)
    .style("fill", color || generateRandColor());
  scoreText.remove();
};

var generateRandColor = function () {
  return d3.rgb(_.random(255), _.random(255), _.random(255));
};

var radius = _.random(RADIUS.min, RADIUS.max);
var duration = _.random(DURATION.min, DURATION.max);

var moveBall = function (name,radius,duration,color,oldPos,newPos) {
  color = color || generateRandColor();
  console.log(color);
  print(name + ' scored ! ',oldPos.xPos,oldPos.yPos,color);
  ball
    .transition()
    .duration(duration)
    .attr("cx", newPos.xPos)
    .attr("cy", newPos.yPos)
    .attr("r", radius)
    .style("fill", 'rgb(' + color.r + ',' + color.g + ',' + color.b +')');
};
var broadcastScoreEvent = function(){
  var radius =  _.random(RADIUS.min, RADIUS.max);
  var scoreObject = {
    type: 'score',
    name: 'ohad',
    radius: radius,
    duration: _.random(DURATION.min, DURATION.max),
    color: generateRandColor(),
    oldPos: {xPos:d3.event.clientX, yPos:d3.event.clientY},
    newPos: {xPos: _.random(BOARD_SIZE.width - 2 * radius), yPos: _.random(BOARD_SIZE.height - 2 * radius)}
  };
  console.log('sss');
    SP.send(topic1, JSON.stringify(scoreObject));
};


var radius = 20;
var ball = svgContainer.append("circle")
  .attr("cx", _.random(BOARD_SIZE.width - radius))
  .attr("cy", _.random(BOARD_SIZE.height - radius))
  .attr("r", 20)
  .style("fill", generateRandColor())
  .style("cursor", "pointer")
  .on("click", broadcastScoreEvent);


var leaderBoard = d3.select("body").append('div').classed("leader-board", true);

var params = {
  url: 'wss://quiet-wave-32794.herokuapp.com/socket',
  debug: true,
};

window.SP = new SpectoPusher(params);

var socketCallbaks = {
  onOpen: function (ev) {
    console.log("socket open", ev);
  },
  onError: function (ev) {
    console.log("socket error", ev);
  },
  onClose: function (ev) {
    console.log("socket close", ev);
  },
};

SP.connect({}, socketCallbaks);

var joinRoom = function (res) {
  var joinMessage = {
    type: 'join',
    name: 'name'
  };
  SP.send(topic1, JSON.stringify(joinMessage));
};

var userJoinEvent = function (messageObject) {
  print('welcome ' + messageObject.name, BOARD_SIZE.width / 2, BOARD_SIZE.height / 2);
};

var userScoreEvent = function (scoreObject) {
  console.log(scoreObject);
    moveBall(scoreObject.name,scoreObject.radius,scoreObject.duration,scoreObject.color,scoreObject.oldPos,scoreObject.newPos);
};


var routerFunc = function (res) {
  var messageActions = {
    join: userJoinEvent,
    score: userScoreEvent
  };

  var messageObject = JSON.parse(res.body);
  messageActions[messageObject.type](messageObject);
};


var callbacks = {
  onJoinSucc: joinRoom,
  onJoinFail: function (res) {
    console.log('join fail', res);
  },
  onMsg: routerFunc,
  onError: function (ev) {
    console.log("channel error", ev);
  },
  onClose: function (e) {
    console.log("channel close", e);
  },
};

SP.join(topic1, callbacks);
console.log(`run 'SP.send(${topic1}, SOME_MSG)' to brodcast`);
