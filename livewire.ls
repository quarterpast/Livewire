sync = require \sync
{map,filter,fold,each,unfold,zip,list-to-obj} = require \prelude-ls

module.exports = new class Router
	routes:[]

	respond(method,path,funcs):
		params = /:([a-z$_][a-z0-9$_]*)/i |> unfold (reg)->
			if reg.exec path
				path .= replace reg, /([^\/]+)/$
				[that.1,reg]
		reg = RegExp "^#{path}$",\i
		
		[]+++funcs |> map (.async!)>>(import do
			match: it.match ? (req)->
				method in [\ANY req.method] and reg.test req.url
			extract: it.extract ? (req)->
				[m,...values] = (reg.exec req.url) ? []
				zip params,values |> list-to-obj
		)>>@routes~push

	::<<< map ::respond, {\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \PATCH \CONNECT \HEAD}
	::'*' = ::any

	~>
		server = require \http .create-server (req,res)~>sync ~>try
			console.time "#{req.method} #{req.url}"
			@routes
			|> filter (.match req)
			|> each (req@params import)<<(.extract req)
			|> fold ((out,route)->route.sync req,res,out),"404 #{req.url}"
			|> ->if it.readable then res.pipe it else res.end it
			console.time-end "#{req.method} #{req.url}"
		catch => res.end e.stack

		return server import all this