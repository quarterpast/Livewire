livewire = require "./livewire.ls"
http = require \http
describe = require \pavlov
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
			@GET "/a/:b" ->"hello #{@params.b}"
			@GET "/b/:c" [
				->"hello #{@params.c}"
				->"hello #{&1}"
			]
			@GET /^\/test\/(\w+)/, ->"test #{@params.1}"
			@listen.sync this,8000
			this

		"params are filled in": ->
			"hello world" is get "http://localhost:8000/a/world"
			and "hello there" is get "http://localhost:8000/a/there"

		"chains are unwound": ->
			"hello hello world" is get "http://localhost:8000/b/world"

		"regexes are executed": ->
			"test things" is get "http://localhost:8000/test/things"

		"we get a 404 message"():
			"404 /rsnt" is get "http://localhost:8000/rsnt"

		"and we can close the server"():
			it.close!

.run!