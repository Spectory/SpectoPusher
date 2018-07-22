# Coyote Server

<<<<<<< HEAD
### Deployment
See `deployment` folder scripts.

=======
>>>>>>> 4b2ec3bb0dc746b267dbe063280dbdcbb1c41eb4
### Dev setup

 - it is recommended to use [asdf version manager](https://github.com/asdf-vm/asdf). anyways make sure your local versions match the ones defined at `.tools-versions`

### DB

not sure we need one, by currently we use sqlite3. didn't test it yet.

https://github.com/scouten/sqlite_ecto2

### Static Assets
we use webpack, but I don't expect we'll use it much.
we should prefer a simple round-trip UI & static pages.

### Admin UI
see [ExAdmin](https://github.com/smpallen99/ex_admin)

check `mix phoenix.routes` for available routes.

------------------------------------------

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


#for docker setup
install docker ce: use https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository instructions
-sudo apt-get install docker-ce=17.06.0~ce-0~ubuntu

docker pull elixir

docker pull phusion/baseimage

dickerfile created using this tutorial:
https://gist.github.com/brienw/85db445a0c3976d323b859b1cdccef9a

build a new release:
important!!! make sure you have config/prod.secret.exs file
if not you can create a new project and take the secret file from there
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez
mix phoenix.new hello_phoenix

mix do deps.get, compile
MIX_ENV=prod mix phoenix.digest
MIX_ENV=prod mix compile
MIX_ENV=prod mix release

rel/coyote/bin/coyote console


run docker:
docker build -t coyote .
docker run -p 4000:4000 --name coyote -d coyote

stop:
docker stop coyote

clean up the container:
docker rm coyote

see runnig docker container:
docker ps



---------------------------------
after you've made changes to your application, to build your new Dockerized release, you'll only need to repeat the last few steps you went over:

MIX_ENV=prod mix do phoenix.digest, compile, release

docker build coyote .