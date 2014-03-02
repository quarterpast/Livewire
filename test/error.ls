require! {
	'karma-sinon-expect'.expect
	'../lib/error'
	'fantasy-eithers'.Left
	'fantasy-eithers'.Right
	\concat-stream
}

export 'Error handler':
	'handle-error':
		'calls error handler on left': ->
			f = expect.sinon.stub!

			h = error.handle-error f, (->)
			h Left "hello"

			expect f .to.be.called-with "hello"

		'calls result handler on right': ->
			f = expect.sinon.stub!

			h = error.handle-error (->), f
			h Right "hello"

			expect f .to.be.called-with "hello"

	'handle-exception':
		'passes arguments to function': ->
			f = expect.sinon.spy!

			h = error.handle-exception f
			h "world"
			expect f .to.be.called-with "world"

		'passes thrown exceptions on left': ->
			ex = new Error "hello"
			f = expect.sinon.stub!
			f.throws ex

			h = error.handle-exception f
			expect h! .to.have.property \l ex

		'passes result on right': ->
			f = expect.sinon.stub!
			f.returns "hello"

			h = error.handle-exception f
			expect h! .to.have.property \r "hello"

	'dev-result':
		'returns error result of stack if an error on the left': (done)->
			e = {\stack}
			res = error.dev-result Left e

			expect res .to.have.property \statusCode 500
			res.body.pipe concat-stream encoding:\string, (data)->
				expect data .to.be \stack
				done!
		'returns ok result of if something on the right': (done)->
			res = error.dev-result Right "hello"

			expect res .to.have.property \statusCode 200
			res.body.pipe concat-stream encoding:\string, (data)->
				expect data .to.be "hello"
				done!