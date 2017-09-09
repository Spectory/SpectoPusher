# SpectoPusher client core

SpectoPusher core module.

Handles connection & msg passing between SpectoPusher server, and brower clients.

## API

### new SpectoPusher(params: object)

Params object:

* url: string - URL of spectoPusher server socket endpoint.
* debug: boolean - Show debug info

### SP.connect()

Establish socket connection.

### SP.join(topic: string, callbacks: object)

Creates a channel to topic.

* topic: string - topic name.
* callbask : object
  * onJoinSucc(response) - triggered on successful join to a topic.
  * onJoinFail(response) - triggered on failed join to a topic.
  * onMsg(response) - triggered on msg recieved on topic.

### SP.send(topic: string, msg: any)

Sends a msg on topic channel.

* topic: string - topic name
* msg: any - msg content

-------------------------------------------------------------------

## Scripts

* `npm run build` - produces production version of your library under the `lib` folder
* `npm run dev` - produces development version of your library and runs a watcher
* `npm run test` - well ... it runs the tests :)
* `npm run test:watch` - same as above but in a watch mode

## Readings
based on the work of [Start your own JavaScript library using webpack and ES6](http://krasimirtsonev.com/blog/article/javascript-library-starter-using-webpack-es6)

