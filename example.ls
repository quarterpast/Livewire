{
	route
	get, post, respond
	ok, not-found
	body-params
	dev-result
} = require './lib'
{serve, listen} = require \fantasy-http
Promise = require \fantasy-promises

delay = (n)->
	new Promise set-timeout _, n

(.unsafe-perform!) listen 8000 serve route (-> not-found "nope"), [
	get '/' -> ok "hello world"
	get '/path' -> ok "hello there"
	get '/param' -> ok "param"
	get '/prefix/' -> ok "prefix"
	get '/param/:a' -> ok "hello #{it.params.a}"
	get '/wait' ->
		<- delay 1000 .chain
		ok "thanks for waiting"
	post '/post' dev-result . (req)->
		{name} <- body-params JSON.parse, req .map
		"hi there #name"
]