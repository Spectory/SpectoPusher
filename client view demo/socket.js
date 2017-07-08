var wsUri = "ws://echo.websocket.org/";
var output;

function init() {
    output = document.getElementById("output");
    testWebSocket();
}

function testWebSocket() {
    websocket = new WebSocket(wsUri);

    websocket.onopen = function(evt) {
        onOpen(evt)
    };

    websocket.onmessage = function(evt) {
        onMessage(evt)
    };

    websocket.onerror = function(evt) {
        onError(evt)
    };
}

function onOpen(evt) {
    writeToScreen("CONNECTED");
}

function onMessage(evt) {
    writeToScreen("RECIEVED: " + evt.data);
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
    websocket.send(message);
    document.getElementById("comment").value = ''
}

function closeSocket() {
    websocket.close();
}

function writeToScreen(message) {
    var pre = document.createElement("p");
    pre.style.wordWrap = "break-word";
    pre.innerHTML = message;
    output.appendChild(pre);
}

window.addEventListener("load", init, false);
