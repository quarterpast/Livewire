require! [\require-folder \util]

export class Router
	@subclasses = []
	@extended = @subclasses~push

	@routers = []

	#create :: Method -> ...Stuff -> Maybe Route
	@create = (method, ...spec)->
		if find (.supports? ...spec), @subclasses
			@routers ++= that method,...spec
		else throw new TypeError "No routers can handle #{spec}."

	#route :: Request -> List Function
	@route = (ctx)->
		filter (.match ctx), @@routers

	@reverse = (fn,params)->
		paths = filter (.has fn), @@routers
		|> concat-map (.reverse fn,params)
		|> filter (?)

		if empty paths
			throw new TypeError "Could not route to #fn using #{util.inspect params}"

		paths
		|> sort-by compare (.length)
		|> head


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
