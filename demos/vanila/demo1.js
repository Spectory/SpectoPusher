const params = {
  url: 'ws://localhost:4000/socket',
  debug: true,
}
window.SP = new SpectoPusher(params);

const socketCallbacks = {
  onOpen: ev => console.log("socket open", ev),
  onError: ev => console.log("socket error", ev),
  onClose: e => console.log("socket close", e),
};

SP.connect({}, socketCallbacks)

const callbacks = {
  onJoinSucc: (res) => { console.log('join succ', res) },
  onJoinFail: (res) => { console.log('join fail', res) },
  onMsg: (res) => { console.log('msg received', res) },
  onError: ev => console.log("channel error", ev),
  onClose: e => console.log("channel close", e),
}

const topic1 = 'public:1';
const topic2 = 'public:2';
SP.join(topic1, callbacks);
SP.join(topic2, callbacks);

console.log(`run 'SP.send(${topic1}, SOME_MSG)' to broadcast`);