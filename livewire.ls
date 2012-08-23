sync = require \sync
global import require \prelude-ls
respond(method,path,func)=
	params = []
	reg = path.replace /:([a-z$_][a-z0-9$_]*)/ig,(m,param)->
		params.push param
		/[^\/]+/$
	|> RegExp _,\i
	func.match(path)=
		if reg.exec path
			[m,...params] = that
			zip params,values |> list-to-obj

server = require \http .create-server (req,res)->
	sync ->
		filter (.match req.path),respond
		|> each (req@params import) . (.match req.path)
		|> fold1 (out,route)->route.sync req,res,out
		|> res.end _,\utf8
	, (err)->
		throw Error "error #err got to the top of sync"

exports.listen = (...args)->
	server.listen ...args
	console.log "listening",...args

<[any get post put delete options trace patch connect head]>
|> map (method)->exports[method] = respond method
