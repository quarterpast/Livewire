{route} = require './lib/route'
{get, respond} = require './lib/respond'
{ok, not-found} = require './lib/result'
{serve, listen} = require \fantasy-http

(.unsafe-perform!) listen 8000 serve route (-> not-found "nope"), [
	get '/' -> ok "hello world"
]