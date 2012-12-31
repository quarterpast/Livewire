require! "./meta".require-all

require-all "./routers"

export class Router
	@subclasses = []
	@extended = @subclasses~push

	#create :: Method -> ...Stuff -> Maybe Route
	@create = (method, ...spec)->
		if find (.supports? ...spec), @subclasses
			that method,...spec
		else throw new TypeError "No routers can handle #{spec}."

	#route :: Request -> List Function
	@route = (req)->
		concat-map (.find req), @@subclasses

	#error :: Response -> Error -> Nothing
	@error = (res,err)-->
		if err?
			res.status-code = 500
			res.end!

			console.error err.stack ? err.to-string!

	@find = (req)-> # default impl, override me plz (or implement .handlers)
		filter (.match req), @instances
		|> concat-map (.handlers!)

	match:  ->
		throw new TypeError "#{@constructor.display-name} does not implement match"
	handlers: ->
		throw new TypeError "#{@constructor.display-name} does not implement handlers"
	extract: ->
		throw new TypeError "#{@constructor.display-name} does not implement extract"
	~>
		throw new TypeError "#{@constructor.display-name} is abstract and can't be instantiated."
