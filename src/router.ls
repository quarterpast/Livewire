require! [\require-folder \util]

export class Router
	@subclasses = []
	@extended = @subclasses~push

	#error :: Response -> Error -> Nothing
	@error = (res,err)-->
		if err?
			res.status-code = 500
			res.end!

			console.error err.stack ? err.to-string!

	match: ->@method in [\ANY it.request.method]
	handlers: ->
		throw new TypeError "#{@constructor.display-name} does not implement handlers"
	has: ->
		throw new TypeError "#{@constructor.display-name} does not implement has"
	extract: ->
		throw new TypeError "#{@constructor.display-name} does not implement extract"
	reverse: ->
		throw new TypeError "#{@constructor.display-name} does not implement reverse"
	(@method)~>


require-folder "./routers"
