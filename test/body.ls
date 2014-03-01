require! {
	'../test'
	'../lib/body'.body-params
	stream.Readable
	\fantasy-streams
}

create-request = (str)->
	(Readable.of str) import headers: 'content-length': str.length
create-error-request = (err)->
	e = new process.EventEmitter
	e.headers = 'content-length':0
	process.next-tick -> e.emit \error err
	e

id = -> it

test do
	"returns an either transformed promise": do
		(body-params id, create-request "hello").run.fork instanceof Function
	"resolves to the body": (done)->
		(body-params id, create-request "hello").run.fork ->
			done do
				if it.l? then that
				it.r is "hello"
	"resolves to the parsed body": (done)->
		(body-params JSON.parse, create-request JSON.stringify a:1).run.fork ->
			done do
				if it.l? then that
				it.r.a is 1
	"passes stream errors on the left": (done)->
		body-params do
			JSON.parse
			create-error-request new Error "hello"
		.run.fork ->
			done null it.l.message is "hello"
	"passes parse errors on the left": (done)->
		(body-params JSON.parse, create-request "not json").run.fork ->
			done null it.l instanceof SyntaxError