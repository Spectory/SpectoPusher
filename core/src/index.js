const Phoenix = require('phoenix-socket');

/**
 * A wrapper around phoenix-socket module.
 * Provides the core logic for connection and message passing with the
 * Coyote server.
 */
export default class Coyote {
  constructor(args = {}) {
    this.URL = args.url;
    this.socket = null;
    this.channels = {};
    this.debug = args.debug || false;
    this.log_('Coyote initialized');
  }

 /**
  * Prints messages to console (if this.debug === true).
  * @param {*} msg - Message to be printed.
  * @param {string} level - Log level to be used (debug/info/warn/error)
  * @private
  */
  log_(msg, level = 'debug') {
    if (!this.debug) { return; }
    console[level](msg);
  }

 /**
  * @private A function that performs no operations.
  */
  noop_() {}

 /**
  * Initialize and connects to a Phoenix.Socket.
  * @param {object} args - Connection parameters passed to Phoenix socket.
  * @param {object} callbacks - Callbacks collection for socket.
  */
  connect(params = {}, callbacks = {}) {
    this.log_(`Coyote.connect: connecting ${this.url}`);
    this.socket = new Phoenix.Socket(this.URL, {params});
    this.socket.connect();
    this.socket.onOpen(callbacks.onOpen);
    this.socket.onError(callbacks.onError);
    this.socket.onClose(callbacks.onClose);
  }

 /**
  * Joins to a channel.
  * @param {string} topic - topic name.
  * @param {object} callbacks - callbacks collection for created channel.
  */
  join(topic, callbacks = {}) {
    this.log_(`Coyote.join: joining topic ${topic}`);
    if (!callbacks.onJoinSucc) { this.log_('Coyote.join: onJoinSucc is undefined', 'warn'); };
    if (!callbacks.onJoinFail) { this.log_('Coyote.join: onJoinFail is undefined', 'warn'); };
    if (!callbacks.onMsg) { this.log_('Coyote.join: onMsg is undefined', 'warn'); };
    if (!callbacks.onError) { this.log_('Coyote.join: onError is undefined', 'warn'); };
    if (!callbacks.onClose) { this.log_('Coyote.join: onClose is undefined', 'warn'); };
    const channel = this.socket.channel(topic, {});

    channel.onError = callbacks.onError || this.noop_;
    channel.onClose = callbacks.onClose || this.noop_;

    channel.join()
      .receive('ok', callbacks.onJoinSucc || this.noop_)
      .receive('error', callbacks.onJoinFail || this.noop_);

    channel.on('broadcast', callbacks.onMsg || this.noop_);
    this.channels[topic] = channel;
  }

 /**
  * Sends a msg on channel
  * @param {string} topic - channel name.
  * @param {*} msg - msg content.
  */
  broadcast(topic, msg) {
    this.log_(`Coyote.broadcast: ${topic}, ${JSON.stringify(msg)}`);
    const channel = this.channels[topic];

    channel.push('broadcast', {body: msg});
  }

 /**
  * Leaves channel.
  * @param {string} topic - channel name.
  * @param {object} callbacks - callbacks collection.
  */
  leave(topic, callbacks = {}) {
    if (!callbacks.onLeave) {
      this.log_('Coyote.leave: callbacks is undefined', 'warn');
    };
    this.channels[topic].leave()
      .receive('ok', callbacks.onLeave || this.noop_);
    this.channels[topic] = undefined;
  }
}
