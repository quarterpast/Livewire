require! http

a = ->"hello world"
b = [
	->"hello #{@params.name}"
	->"hello #{&1}"
]
c = ->"test #{@params.0}"
d = ->"other #{@params.a}"

Livewire = require "./src"
	..GET "/" a
	..GET "/:name" b
	..GET /^\/test\/(\w+)/, c
	..GET (->if it.pathname.split '/' .1 is 'other' then a:"hello" else false), d

console.log Livewire.Router.reverse a,{}
console.log Livewire.Router.reverse b,name:"there"
console.log try Livewire.Router.reverse c catch => e.message
console.log try Livewire.Router.reverse d catch => e.message

port = process.env.PORT ? 8000

http.create-server Livewire.app .listen port, ->console.log "listening on #port"