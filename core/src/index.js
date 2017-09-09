const Phoniex = require('phoenix-socket');

export default class SpectoPusher {
  constructor(args = {}) {
    this.URL = args.url;
    this.socket = undefined;
    this.channels = {};
    this.debug = args['debug'];
    this._log('SpectoPusher initilized');
  }

  /* Private */

  /*
  * Prints msgs to console (if this.debug === true).
  * @param msg:any - msg to be printed.
  * @param level:string - log level to be used (debug/info/warn/error)
  */
  _log(msg, level = 'debug') {
    if (!this.debug) { return; }
    console[level](msg);
  }

  _doNothing() {}

  /* Public */

  /*
  * Initilize and connects to a Phoniex.Socket.
  * @param args:object - Connection parameters
  * @param callbacks:object - callbacks collection for socket
  */
  connect(args = {}, callbacks = {}) {
    this._log(`SpectoPusher.connect: connecting ${this.url}`);
    this.socket = new Phoniex.Socket(this.URL, args);
    this.socket.onOpen = callbacks['onOpen'];
    this.socket.onError = callbacks['onError'];
    this.socket.onClose = callbacks['onClose'];
    console.log(this.socket);
    this.socket.connect();
  }

  /*
  * Joins to a channel.
  * @param topic:string - topic name.
  * @param callbacks:object - callbacks collection for created channel.
  */
  join(topic, callbacks = {}) {
    this._log(`SpectoPusher.join: joining topic ${topic}`);
    if (!callbacks['onJoinSucc']) { this._log('SpectoPusher.join: onJoinSucc is undefined', 'warn'); };
    if (!callbacks['onJoinFail']) { this._log('SpectoPusher.join: onJoinFail is undefined', 'warn'); };
    if (!callbacks['onMsg']) { this._log('SpectoPusher.join: onMsg is undefined', 'warn'); };
    if (!callbacks['onError']) { this._log('SpectoPusher.join: onError is undefined', 'warn'); };
    if (!callbacks['onClose']) { this._log('SpectoPusher.join: onClose is undefined', 'warn'); };

    const channel = this.socket.channel(topic, {});

    channel.onError = callbacks['onError'] || this._doNothing;
    channel.onClose = callbacks['onClose'] || this._doNothing;

    channel.join()
      .receive('ok', callbacks['onJoinSucc'] || this._doNothing)
      .receive('error', callbacks['onJoinFail'] || this._doNothing);

    channel.on('new_msg', callbacks['onMsg'] || this._doNothing);
    this.channels[topic] = channel;
  }

  /*
  * Sends a msg on channel
  * @param topic:string - channel name.
  * @param msg:any - msg content.
  */
  send(topic, msg) {
    this._log(`SpectoPusher.send: sending to ${topic}, ${JSON.stringify(msg)}`);
    const channel = this.channels[topic];

    channel.push('new_msg', {body: msg});
  }

  /*
  * Leaves channel.
  * @param topic:string - channel name.
  * @param callbacks:object - callbacks collection
  */
  leave(topic, callbacks = {}) {
    if (!callbacks['onLeave']) { this._log('SpectoPusher.leave: callbacks is undefined', 'warn'); };
    this.channels[topic].leave()
      .receive('ok', callbacks['onLeave'] || this._doNothing);
    this.channels[topic] = undefined;
  }
}
