require! {
	'karma-sinon-expect'.expect
	'../lib/error'
}

export 'Error handler':
	'handle-exception':
		'passes arguments to function': ->
			f = expect.sinon.spy!

			h = error.handle-exception f
			h "world"
			expect f .to.be.called-with "world"

		'throws exceptions into the stream': (done)->
			ex = new Error "hello"
			f = expect.sinon.stub!
			f.throws ex

			once = no
			twice = ->
				if once
					done ...
				else once := yes

			h = error.handle-exception f
			h!
			.stop-on-error (e)->
				expect e .to.be ex
				twice!
			.to-array (xs)->
				expect xs .to.be.empty!
				twice!

		'pushes results to the stream': (done)->
			f = expect.sinon.stub!
			f.returns "hello"

			h = error.handle-exception f
			h!.to-array (xs)->
				expect xs .to.eql <[hello]>
				done!
