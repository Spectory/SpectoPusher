$(document).ready(() => {
  const params = {
    url: 'ws://localhost:4000/socket',
    debug: true,
  }
  window.SP = new SpectoPusher(params);

  const socketCallbacks = {
    onOpen: ev => { changeSocketStatus(true) },
    onError: ev => { changeSocketStatus(false) },
    onClose: e => { changeSocketStatus(false) },
  };

  SP.connect({}, socketCallbacks)

  const callbacksFor = (channelId) => {
    return {
      onJoinSucc: (res) => { changeChannelStatus(channelId, true); },
      onJoinFail: (res) => { changeChannelStatus(channelId, false); },
      onMsg: (msg) => { addMsg(channelId, msg.body) },
      onError: e => console.log(`${channelId} error`, e),
      onClose: e => console.log(`${channelId} closed`, e),
    }
  }

  const topic1 = 'public:1';
  const topic2 = 'public:2';
  SP.join(topic1, callbacksFor('channel_1'));
  SP.join(topic2, callbacksFor('channel_2'));

  const changeChannelStatus = (channelId, status) => {
    $(`#${channelId}_status`).html(`connected? ${status}`);
  };
  
  const changeSocketStatus = (status) => $('socket_status').html(`socket open?: ${status}`);

  const addMsg = (channelId, msg) => $(`#${channelId}_msgs`).append(`<li>${msg}</li>`);

  sendMsg = (topic) => {
    SP.send(topic, `Look! a random number: ${Math.random()}`);
  }

  setInterval(sendMsg, 3000, topic1);
  setInterval(sendMsg, 5000, topic2);
});
