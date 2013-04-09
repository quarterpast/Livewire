require! {
	Livewire: "./lib"
	buster:"buster-test"
	assertions:"buster-assertions"
	"buster-sinon"
	http
	sync
	"readable-stream".Readable
}
{expect,assert,refute} = assertions
async = (fn)->
	as = fn.async!
	(done)->
		as.call this, (err,r)->
			do done ~>
				throw that if err?

async-get = (url,cb)->
	http.get url,(res)->
		body = []
		res.on \data body~push
		res.on \error cb
		res.on \end ->cb null {body: (Buffer.concat body)to-string \utf8} import res
	.on \error cb

get = (->async-get.sync null,...&).async!

count = 0

assertions.on \pass ->count++
assertions.on \failure ->count++
buster.test-runner.on-create (runner)->
	runner.on \test:start ->count := 0
	runner.on \test:setUp ->assertions.throw-on-failure = on

runner = buster.test-runner.create!
runner.assertion-count = -> count

runner.on \suite:end (results)->
	process.next-tick ->
		process.exit results.errors + results.timeouts + results.failures

reporter = buster.reporters.(process.env.BUSTER_REPORTER ? \dots).create {+color}
reporter.listen runner

runner.run-suite [] ++ buster.test-case "Livewire" {

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
			->"hello #{it.body.read!}"
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
		get "http://localhost:8000/rsnt"
			..body `assert.same` "404 /rsnt"
			..status-code `assert.same` 404

	"trailing slash implies prefix":
		"usually": async ->
			Livewire.GET "/noslash" -> "hello"
			Livewire.GET "/slash/" -> "hello"

			expect (get "http://localhost:8000/noslash/hello")status-code .to-be 404
			expect (get "http://localhost:8000/slash/hello")status-code .to-be 200
		"unless it's /": async ->
			Livewire.GET '/' -> "hello"
			expect (get "http://localhost:8000/trailer")status-code .to-be 404

	"handles responses of type":
		"string": async ->
			Livewire.GET "/response/type/string" -> "string response"
			expect (get "http://localhost:8000/response/type/string")body
			.to-be "string response"

		"buffer": async ->
			Livewire.GET "/response/type/buffer" -> new Buffer "buffer response"
			expect (get "http://localhost:8000/response/type/buffer")body
			.to-be "buffer response"

		"stream": async ->
			Livewire.GET "/response/type/stream" ->
				new class extends Readable
					_read: -> if @push "stream response" then @push null
			expect (get "http://localhost:8000/response/type/stream")body
			.to-be "stream response"

		"object": async ->
			Livewire.GET "/response/type/object" ->
				body:"object response" status-code:201
			get "http://localhost:8000/response/type/object"
				..status-code `assert.same` 201
				..body `assert.same` "object response"

		"error code": async ->
			Livewire.GET "/response/type/errorcode" -> Error 418
			get "http://localhost:8000/response/type/errorcode"
				..status-code `assert.same` 418
				..body `assert.same` "I'm a teapot"

		"error message": async ->
			Livewire.GET "/response/type/errormessage" -> Error "woah there!"
			get "http://localhost:8000/response/type/errormessage"
				..status-code `assert.same` 500
				..body `assert.same` "woah there!"

	"sets headers": async ->
		Livewire.GET "/header-test" -> body:"" headers:"x-header-test":"test header"
		get "http://localhost:8000/header-test"
			..headers.'x-header-test' `assert.same` "test header"

	"final responses are final": async ->
		{final} = Livewire.Response
		spy = @spy -> "never called"
		Livewire.GET "/final" [
			-> final "final response"
			spy
		]
		get "http://localhost:8000/final"
			..body `assert.same` "final response"

		refute.called spy

	"handlers":
		"are called witdh a HandlerContext": (done)->
			Livewire.GET '/context' ->
				do done ~>
					@constructor.display-name `assert.same` \HandlerContext
				""
			get 'http://localhost:8000/context' ->
		"are given":
			"the original request": (done)->
					Livewire.GET "/context/request" ->
						do done ~>
							http.IncomingMessage.prototype `assert.same` Object.get-prototype-of @request
						""
					get "http://localhost:8000/context/request" ->
			"the route":
				"for strings": (done)->
					Livewire.GET "/my/awesome/:route" ->
						do done ~>
							expect @route .to-be "/my/awesome/#{@params.route}"
						""
					get "http://localhost:8000/my/awesome/thing" ->

				"for regexes": (done)->
					Livewire.GET /^\/my\/regex\/thing$/, ->
						do done ~>
							expect @route .to-be "/my/regex/thing"
						""
					get "http://localhost:8000/my/regex/thing" ->

				"for functions": (done)->
					Livewire.GET (.pathname is "/my/function/thing"), ->
						do done ~>
							expect @route .to-be "/my/function/thing"
						""
					get "http://localhost:8000/my/function/thing" ->




	tear-down: -> @server.close!

}