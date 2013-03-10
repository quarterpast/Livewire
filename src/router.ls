require! \require-folder

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
	@route = (req)->
		filter (.match req), @@routers

	#error :: Response -> Error -> Nothing
	@error = (res,err)-->
		if err?
			res.status-code = 500
			res.end!

			console.error err.stack ? err.to-string!

	match: ->@method in [\ANY it.method]
	handlers: ->
		throw new TypeError "#{@constructor.display-name} does not implement handlers"
	extract: ->
		throw new TypeError "#{@constructor.display-name} does not implement extract"
	(@method)~>


require-folder "./routers"
