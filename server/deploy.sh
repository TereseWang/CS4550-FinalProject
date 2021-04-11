#From Nat Tuck's CS4550 Lecture Notes, Photoblog deployment
#!/bin/bash
export MIX_ENV=prod
export PORT=4800
export SECRET_KEY_BASE=insecure
export DATABASE_URL=ecto://kittenlover:bad@localhost/kittenlover_prod

mix deps.get --only prod

mix compile
CFGD=$(readlink -f /home/kittenlover/.config/kittenlovers)

if [ ! -d "$CFGD" ]; then
	mkdir -p "$CFGD"
fi

if [ ! -e "$CFGD/base" ]; then
	mix phx.gen.secret > "$CFGD/base"
fi

if [ ! -e "$CFGD/db_pass" ]; then
	pwgen 12 1 > "$CFGD/db_pass"
fi

SECRET_KEY_BASE=$(cat "$CFGD/base")
export SECRET_KEY_BASE

DB_PASS=$(cat "$CFGD/db_pass")
export DATABASE_URL=ecto://kittenlover:$DB_PASS@localhost/kittenlover_prod

mix ecto.create
mix ecto.reset

npm install --prefix ./assets
npm run deploy --prefix ./assets
mix phx.digest

mix release
