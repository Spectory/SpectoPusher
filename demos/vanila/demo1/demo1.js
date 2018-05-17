/**
 * @fileOverview
 * A basic example of SpectoPusher connection to a public channel, and message
 * broadcasting.
 */

// Create a SpectoPusher instance.
const params = {
  url: 'ws://localhost:4000/socket',
  debug: true,
}
window.SP = new SpectoPusher(params);

// Define connection event handlers.
const connectionCallbacks = {
  onOpen: ev => console.log("socket open", ev),
  onError: ev => console.log("socket error", ev),
  onClose: e => console.log("socket close", e),
};

// Connect.
SP.connect({}, connectionCallbacks)

// Define messages callbacks.
const messageCallbacks = {
  onJoinSucc: (res) => { console.log('join succ', res) },
  onJoinFail: (res) => { console.log('join fail', res) },
  onMsg: (res) => { console.log('msg received', res) },
  onError: ev => console.log("channel error", ev),
  onClose: e => console.log("channel close", e),
}

// Join public channels.
const topic1 = 'public:1';
const topic2 = 'public:2';
SP.join(topic1, messageCallbacks);
SP.join(topic2, messageCallbacks);

// SP.send(<CHANNEL>, <MESSAGE>) to broadcast.
console.log(`run 'SP.send(${topic1}, SOME_MSG)' to broadcast`);