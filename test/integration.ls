{
	route
	get, post, respond
	ok, not-found
	body-params
} = require '../lib'
σ = require \highland
require! [http, freeport, 'karma-sinon-expect'.expect, \concat-stream]

assert-response = (addr, path, response, callback)-->
	http.get addr + path, (res)->
		res.pipe concat-stream encoding:\string, (data)->
			expect data .to.be response
			callback!
	.on \error callback

export
	before: (done)->
		r = route [
			get '/' -> σ <[hello]>
			get '/blah' -> σ <[foo]>
			get '/foo/:bar' ({params})-> σ [params.bar]
			-> σ ['not found']
		]

		e, @port <~ freeport
		done e if e?

		@assert-response = assert-response "http://localhost:#{@port}"


		http.create-server (req, res)->
			r req .pipe res
		.listen @port, done

	'HTTP integration':
		'base route hits': (done)->
			@assert-response '/' 'hello' done
		'sub route hits': (done)->
			@assert-response '/blah' 'foo' done
