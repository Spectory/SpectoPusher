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
    // testWebSocket();
}

var join = function (socket, topic) {
    channel = socket.channel(topic, {})
    channel.join()
        .receive("ok", resp => { console.log("Joined successfully", resp) })
        .receive("error", resp => { console.log("Unable to join", resp) })

    channel.on("new_msg", payload => {
        debugger
        onMessage(payload.body);
        // let messageItem = document.createElement("li");
        // messageItem.innerText = `[${Date()}] ${payload.body}`
        // messagesContainer.appendChild(messageItem)
    })
}

// function testWebSocket() {
//     websocket = new WebSocket(wsUri);
//     debugger
//     websocket.onopen = function(evt) {
//         onOpen(evt)
//     };

//     websocket.onmessage = function(evt) {
//         onMessage(evt)
//     };

//     websocket.onerror = function(evt) {
//         onError(evt)
//     };
// }

// function onOpen(evt) {
//     writeToScreen("CONNECTED");
// }

function onMessage(msg) {
    writeToScreen("RECIEVED: " + msg);
}

// function onError(evt) {
//     writeToScreen("ERROR:");
//     writeToScreen(evt.data);
// }
// function onClose(evt) {
//     writeToScreen("DISCONNECTED");
//  }

function doSend() {
  var message = document.getElementById("comment").value
    writeToScreen("SENDING: " + message);
    channel.push("new_msg", { body: message});
    document.getElementById("comment").value = ''
}

// function closeSocket() {
//     websocket.close();
// }

function writeToScreen(message) {
    var pre = document.createElement("p");
    pre.style.wordWrap = "break-word";
    pre.innerHTML = message;
    output.appendChild(pre);
}

window.addEventListener("load", init, false);
