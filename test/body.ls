require! {
	'karma-sinon-expect'.expect
	'../lib/body'
	from
	σ: highland
}

Stream = σ!constructor # sigh

create-request = (str)->
	(from [str]) import headers: 'content-length': str.length
create-error-request = (err)->
	e = new process.EventEmitter
	e.headers = 'content-length':0
	process.next-tick -> e.emit \error err
	e

export
	"Body parser":
		"returns a stream": ->
			expect (body.raw create-request "hello") .to.be.a Stream
		"resolves to the body": (done)->
			body.raw create-request "hello"
			.to-array (xs)->
				expect xs .to.eql <[hello]>
				done!
		"resolves to the parsed body": (done)->
			body.json create-request JSON.stringify a:1
			.to-array (xs)->
				expect xs.0 .to.have.property \a 1
				done!
		"passes stream errors to the stream": (done)->
			body.json create-error-request new Error "hello"
			.stop-on-error (err)->
				expect err.message .to.be "hello"
				done!
			.each ->
		"passes parse errors to the stream": (done)->
			(body.json create-request "not json")
			.stop-on-error (err)->
				expect err .to.be.a SyntaxError
				done!
			.each ->

	"json parser":
		"streams parsed json": (done)->
			body.json-parse '{"a":1}' .to-array (xs)->
				expect xs.0 .to.have.property \a 1
				done!
		"passes parse errors to the stream": (done)->
			body.json-parse 'not json'
			.stop-on-error (err)->
				expect err .to.be.a SyntaxError
				done!
			.each ->

	"query parser":
		"streams parsed query strings": (done)->
			body.query-parse 'a=1' .to-array (xs)->
				expect xs.0 .to.have.property \a '1'
				done!
