require! "./router".Router

export class RouterFactory

	#create :: Method -> ...Stuff -> Maybe Route
	make-router: (method)->(...spec)~>
		if find (.supports? ...spec), Router.subclasses
			@context.routers ++= that method,...spec
		else throw new TypeError "No routers can handle #{spec}."

	#route :: Request -> List Function
	route: (ctx)->
		filter (.match ctx), @context.routers

	reverse: (fn,params)->
		paths = filter (.has fn), @context.routers
		|> concat-map (.reverse fn,params)
		|> filter (?)

		if empty paths
			throw new TypeError "Could not route to #fn using #{util.inspect params}"

		paths
		|> sort-by compare (.length)
		|> head

	(@context)->
