sync = require \sync
global import require \prelude-ls

routes = {}

respond(method,path,func)=
	params = /:([a-z$_][a-z0-9$_]*)/i |> unfold (reg)->
		if reg.exec path
			path .= replace reg, /([^\/]+)/$
			[that.0,reg]
	reg = RegExp "^#{path}$",\i
	func .= async!
	func.match(req)=
		if method is req.method
			if reg.exec req.url
				[m,...values] = that
				zip params,values |> list-to-obj

	routes."#method #path" = func

server = require \http .create-server (req,res)->
	sync ->
		try
			console.time "#{req.method} #{req.url}"
			routes
			|> filter (.match req)
			|> each (req@params import) . (.match req)
			|> fold ((out,route)->route.sync req,res,out),""
			|> req~end
			console.time-end "#{req.method} #{req.url}"
		catch => console.warn e.stack

export server~listen

<[any get post put delete options trace patch connect head]>
|> map ->exports[it] = respond it.to-upper-case!
