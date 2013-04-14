require! {
	"./oop".abstract
	\require-folder
}

export class Router implements abstract {\handlers \has \extract \reverse \routes}
	@subclasses = []
	@extended = @subclasses~push

	#error :: Response -> Error -> Nothing
	@error = (res,err)-->
		if err?
			res.status-code = 500
			res.end!

			console.error err.stack ? err.to-string!

	match: ->@method in [\ANY it.request.method]
	(@method)~>


require-folder "./routers"
