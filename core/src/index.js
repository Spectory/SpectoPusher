const Phoniex = require('phoenix-socket');

export default class SpectoPusher {
  constructor(args = {}) {
    this.URL = args.url;
    this.socket = undefined;
    this.channels = {};
    this.debug = args['debug'];
    this.log('SpectoPusher initilized');
  }

  log(msg, level = 'debug') {
    if (!this.debug) { return; }
    console[level](msg);
  }

  connect() {
    this.log(`SpectoPusher.connect: connecting ${this.url}`);
    this.socket = new Phoniex.Socket(this.URL, this.params);
    this.socket.connect();
  }

  join(topic, callbacks = {}) {
    this.log(`SpectoPusher.join: joining topic ${topic}`);
    if (!callbacks['onJoinSucc']) { this.log('onJoinSucc is undefined', 'warn'); };
    if (!callbacks['onJoinFail']) { this.log('onJoinFail is undefined', 'warn'); };
    if (!callbacks['onMsg']) { this.log('onMsg is undefined', 'warn'); };

    const channel = this.socket.channel(topic, {});

    channel.join()
      .receive('ok', callbacks['onJoinSucc'])
      .receive('error', callbacks['onJoinFail']);

    channel.on('new_msg', callbacks['onMsg']);
    this.channels[topic] = channel;
  }

  send(topic, msg) {
    this.log(`SpectoPusher.send: sending to ${topic}, ${JSON.stringify(msg)}`);
    const channel = this.channels[topic];

    channel.push('new_msg', {body: msg});
  }
}
