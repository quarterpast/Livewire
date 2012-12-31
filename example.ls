require! http
Livewire = require "./src"
	..GET "/" ->"hello world"
	..GET "/:name" [
		->"hello #{@params.name}"
		->"hello #{&1}"
	]
	..GET /^\/test\/(\w+)/, ->"test #{@params.0}"
	..GET (->if it.pathname.split '/' .1 is 'other' then a:"hello" else false), ->"other #{@params.a}"

port = process.env.PORT ? 8000

http.create-server Livewire.app .listen port, ->console.log "listening on #port"