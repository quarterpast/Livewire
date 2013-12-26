{route} = require './src/route'
{get, respond} = require './src/respond'
{ok, not-found} = require './src/result'
{serve, listen} = require \fantasy-http

(.unsafe-perform!) listen 8000 serve route (-> not-found "nope"), [
	get '/' -> ok "hello world"
	get '/path' -> ok "hello there"
	get '/param/:a' -> ok "hello #{it.params.a}"
]