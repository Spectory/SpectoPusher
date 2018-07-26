/**
 * @fileOverview
 * A basic example of Coyote connection to a public channel, and message
 * broadcasting.
 */

document.addEventListener("DOMContentLoaded", () => {
  // const url = 'ws://localhost:4000';
  const url = 'wss://coyote-demo.herokuapp.com';

  // Create a Coyote instance.
  const params = {
    url: `${url}/socket`,
    debug: true,
  }
  window.Coyote = new Coyote(params);

  // Define connection event handlers.
  const connectionCallbacks = {
    onOpen: ev => console.log("socket open", ev),
    onError: ev => console.log("socket error", ev),
    onClose: e => console.log("socket close", e),
  };


  // Define messages callbacks.
  const messageCallbacks = {
    onJoinSucc: (res) => { console.log('join succ', res) },
    onJoinFail: (res) => { console.log('join fail', res) },
    onMsg: (res) => { console.log('msg received', res) },
    onError: ev => console.log("channel error", ev),
    onClose: e => console.log("channel close", e),
  }

  window.onClick = () => {
    // Connect.
    const token = document.getElementById('token').value;
    console.log(token)
    Coyote.connect({token}, connectionCallbacks);
    // Join public channels.
    const topic1 = 'public:1';
    const topic2 = 'public:2';
    Coyote.join(topic1, messageCallbacks);
    Coyote.join(topic2, messageCallbacks);

    // Coyote.broadcast(<CHANNEL>, <MESSAGE>) to broadcast.
    console.log(`run 'Coyote.broadcast(${topic1}, SOME_MSG)' to broadcast`);
  }
});