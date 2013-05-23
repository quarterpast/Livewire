require! {
	"./oop".abstract
	"./response".Response
	\require-folder
}

export class Router implements abstract {\handlers \has \extract \reverse \routes}
	@subclasses = []
	@extended = @subclasses~push

	@error = id.async!
	@handle = (.async!) (res,ctx,err)-->
		if err?
			console.error err.stack ? err.to-string!

			@error.sync ctx,err
			|> Response.create
			|> (.respond res)

	match: ->@method in [\ANY it.request.method]
	(@method)~>


require-folder "./routers"
