require! {
	'karma-sinon-expect'.expect
	'../lib/body'
	from
}


create-request = (str)->
	(from [str]) import headers: 'content-length': str.length
create-error-request = (err)->
	e = new process.EventEmitter
	e.headers = 'content-length':0
	process.next-tick -> e.emit \error err
	e

export
	"Body parser":
		"returns an either transformed promise": ->
			expect (body.raw create-request "hello").run.fork
			.to.be.a Function
		"resolves to the body": (done)->
			body.raw create-request "hello"
			.run.fork ({l,r})->
				expect r .to.be "hello"
				done l
		"resolves to the parsed body": (done)->
			body.json create-request JSON.stringify a:1
			.run.fork ({l,r})->
				expect r .to.have.property \a 1
				done l
		"passes stream errors on the left": (done)->
			body.json create-error-request new Error "hello"
			.run.fork ({l})->
				expect l.message .to.be "hello"
				done!
		"passes parse errors on the left": (done)->
			(body.json create-request "not json").run.fork ({l})->
				expect l .to.be.a SyntaxError
				done!

	"json parser":
		"promises parsed json on the right": (done)->
			body.json-parse '{"a":1}' .run.fork (e)->
				expect e .to.have.property \r
				expect e.r .to.have.property \a 1
				done!
		"promises errors on the left": (done)->
			body.json-parse 'not json' .run.fork (e)->
				expect e .to.have.property \l
				expect e.l .to.be.a SyntaxError
				done!

	"query parser":
		"promises parsed query string on the right": (done)->
			body.query-parse 'a=1' .run.fork (e)->
				expect e .to.have.property \r
				expect e.r .to.have.property \a '1'
				done!