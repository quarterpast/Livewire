sync = require \sync
global import require \prelude-ls

routes = {}

respond(method,path,func)=
	params = []
	reg = "^"+(path.replace /:([a-z$_][a-z0-9$_]*)/ig,(m,param)->
		params.push param
		/([^\/]+)/$
	)+"$"
	|> RegExp _,\i

	func.match(req)=
		if method.to-lower-case! is req.method.to-lower-case!
			if reg.exec req.url
				[m,...values] = that
				zip params,values |> list-to-obj
			else false
		else false

	routes."#method #path" = func

server = require \http .create-server (req,res)->
	sync ->
		try
			routes
			|> filter (.match req)
			|> each (req@params import) . (.match req)
			|> fold1 (out,route)->route.sync req,res,out
			|> res~end
		catch => console.warn e.stack

exports.listen = (...args)->
	server.listen ...args
	console.log "listening",...args

<[any get post put delete options trace patch connect head]>
|> map (method)->exports[method] = respond method
