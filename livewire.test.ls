livewire = require "./livewire.ls"
http = require \http
{expect,throws}:describe = require \pavlov
get = require "../get"

async = (.async!)

describe "Livewire" do
	"Its router"():
		topic: livewire!
		"is an http.Server"(): it instanceof http.Server
		"has some sugar methods": (topic)-> <[ANY GET POST PUT DELETE OPTIONS TRACE CONNECT HEAD]> |> all (in keys topic)
		"which return the router"():
			it is it.GET "/",(->)
	"When we set a few routes"():
		topic(): with livewire!
			@log = id

			@GET "/a/:b" ->"hello #{@params.b}"
			@GET "/b/:c" [
				->"hello #{@params.c}"
				->"hello #{&1}"
			]
			@GET /^\/test\/(\w+)/, ->"test #{@params.1}"
			@listen.sync this,8000
			this

		"params are filled in": ->
			get "http://localhost:8000/a/world" .body is "hello world"
			and get "http://localhost:8000/a/there" .body is "hello there"

		"chains are unwound": expect "hello hello world" ->get "http://localhost:8000/b/world" .body

		"regexes are executed": ->
			get "http://localhost:8000/test/things" .body is "test things"

		"we get a 404 message"():
			with get "http://localhost:8000/rsnt"
				@body is "404 /rsnt" and @res.status-code is 404

		"and we can close the server"():
			it.close!

.run!