require! {
	'karma-sinon-expect'.expect
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

export
	"returns an either transformed promise": ->
		expect (body-params id, create-request "hello").run.fork
		.to.be.a Function
	"resolves to the body": (done)->
		body-params id, create-request "hello"
		.run.fork ({l,r})->
			expect r .to.be "hello"
			done l
	"resolves to the parsed body": (done)->
		body-params JSON.parse, create-request JSON.stringify a:1
		.run.fork ({l,r})->
			expect r .to.have.property \a 1
			done l
	"passes stream errors on the left": (done)->
		body-params do
			JSON.parse
			create-error-request new Error "hello"
		.run.fork ({l})->
			expect l.message .to.be "hello"
			done!
	"passes parse errors on the left": (done)->
		(body-params JSON.parse, create-request "not json").run.fork ({l})->
			expect l .to.be.a SyntaxError
			done!