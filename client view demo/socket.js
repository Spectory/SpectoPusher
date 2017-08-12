// var wsUri = "http://localhost:4000/";
var wsUri = "ws://localhost:4000/socket/websocket/public:5";
var output;



function init() {

    var socket = new Phoenix.Socket("ws://localhost:4000/socket", {})

    socket.connect()

    // Now that you are connected, you can join channels with a topic:
    let channel;

    join(socket, 'public:5');

    output = document.getElementById("output");
}

var join = function (socket, topic) {
    channel = socket.channel(topic, {})
    channel.join()
        .receive("ok", resp => { console.log("Joined successfully", resp) })
        .receive("error", resp => { console.log("Unable to join", resp) })

    channel.on("new_msg", payload => {
        onMessage(payload.body);
    })
}

function onMessage(msg) {
    writeToScreen("RECIEVED: " + msg);
}

function onError(evt) {
    writeToScreen("ERROR:");
    writeToScreen(evt.data);
}
function onClose(evt) {
    writeToScreen("DISCONNECTED");
 }

function doSend() {
  var message = document.getElementById("comment").value
    writeToScreen("SENDING: " + message);
    channel.push("new_msg", { body: message});
    document.getElementById("comment").value = ''
}

function closeSocket() {
    socket.onClose();
}

function writeToScreen(message) {
    var pre = document.createElement("p");
    pre.style.wordWrap = "break-word";
    pre.innerHTML = message;
    output.appendChild(pre);
}

window.addEventListener("load", init, false);
