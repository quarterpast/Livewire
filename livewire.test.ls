require! {
	Livewire: "./lib"
	buster
	buster.assertions
	http
	sync
}

{expect} = assertions
async = (fn)->
	as = fn.async!
	(done)->
		as (err,r)->
			throw that if err?
			done!

async-get = (url,cb)->
	http.get url,(res)->
		body = []
		res.on \data body~push
		res.on \error cb
		res.on \end ->cb null {body: (Buffer.concat body)to-string \utf8} import res
	.on \error cb

get = (->async-get.sync null,...&).async!

buster.test-case "Livewire" {

	set-up: (done)->
		Livewire.log = id
		@server = http.create-server Livewire.app .listen 8000 ->done!

	"fills in params": async ->
		Livewire.GET "/a/:b" ->"hello #{@params.b}"
		expect (get "http://localhost:8000/a/world")body .to-be "hello world"
		expect (get "http://localhost:8000/a/there")body .to-be "hello there"

	"unwinds chains": async ->
		Livewire.GET "/b/:c" [
			->"hello #{@params.c}"
			->"hello #{&1}"
		]
		expect (get "http://localhost:8000/b/world")body .to-be "hello hello world"

	"executes regexes": async ->
		Livewire.GET /^\/test\/(\w+)/, ->"test #{@params.0}"
		expect (get "http://localhost:8000/test/things")body .to-be "test things"

	"gives 404s": async ->
		result = get "http://localhost:8000/rsnt"
		expect result.body .to-be "404 /rsnt"
		expect result.status-code .to-be 404

	"trailing slash implies prefix": async !->
		Livewire.GET "/noslash" -> "hello"
		Livewire.GET "/slash/" -> "hello"

		expect (get "/noslash/hello")status-code .to-be 404
		expect (get "/slash/hello")status-code .to-be 200

	tear-down: -> @server.close!

}