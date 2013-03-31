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
		as.call this, (err,r)->
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

	set-up: ->
		Livewire.log = id
		@server = http.create-server Livewire.app .listen 8000


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

	"executes functions": async ->
		Livewire.GET ->
			if it.pathname.split '/' .1 is 'other' then a:"hello" else false
		, ->"other #{@params.a}"
		expect (get "http://localhost:8000/other")body .to-be "other hello"

	"gives 404s": async ->
		result = get "http://localhost:8000/rsnt"
		expect result.body .to-be "404 /rsnt"
		expect result.status-code .to-be 404

	"trailing slash implies prefix": async !->
		Livewire.GET "/noslash" -> "hello"
		Livewire.GET "/slash/" -> "hello"

		expect (get "http://localhost:8000/noslash/hello")status-code .to-be 404
		expect (get "http://localhost:8000/slash/hello")status-code .to-be 200

	"the route gets passed in to the handler":
		"for strings": (done)->
			Livewire.GET "/my/awesome/:route" ->
				expect @route .to-be "/my/awesome/#{@params.route}"
				done!
				""
			get "http://localhost:8000/my/awesome/thing" ->

		"for regexes": (done)->
			Livewire.GET /^\/my\/regex\/thing$/, ->
				expect @route .to-be "/my/regex/thing"
				done!
				""
			get "http://localhost:8000/my/regex/thing" ->

		"for functions": (done)->
			Livewire.GET (.pathname is "/my/function/thing"), ->
				expect @route .to-be "/my/function/thing"
				done!
				""
			get "http://localhost:8000/my/function/thing" ->


	tear-down: -> @server.close!

}