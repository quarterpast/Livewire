sync = require \sync
{map,filter,fold,each,unfold} = require \prelude-ls

module.exports = new class Router
	respond(method,path,funcs):
		params = /:([a-z$_][a-z0-9$_]*)/i |> unfold (reg)->
			if reg.exec path
				path .= replace reg, /([^\/]+)/$
				[that.0,reg]
		reg = RegExp "^#{path}$",\i
		@routes .= concat do
			[]+++funcs |> map (.async!) |> each (.match ?= (req)->
				if method in [\ANY req.method]
					[m,...values] = (reg.exec req.url) ? []
					if m? then zip params,values |> list-to-obj
			)

	{\any \get \post \put \delete \options \trace \patch \connect \head}
	|> map ::respond . (.to-upper-case!) |> (prototype import)
	::'*' = ::any

	~>
		@routes = []
		server = require \http .create-server (req,res)~>sync ~>try
			console.time "#{req.method} #{req.url}"
			@routes
			|> filter (.match req)
			|> each (req@params import) . (.match req)
			|> fold ((out,route)->route.sync req,res,out),"404 #{req.url}"
			|> res~end
			console.time-end "#{req.method} #{req.url}"
		catch => console.warn e.stack

		return server import all this