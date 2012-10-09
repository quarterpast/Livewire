sync = require \sync

module.exports = new class Router
	time = ->Date|>(new)>>(.get-time!)
	routes:[]
	String::pipe = (.end String this)
	Buffer::pipe = (.end this)
	respond(method,path,funcs):
		reg = switch typeof! path
		| \String =>
			params = /:([a-z$_][a-z0-9$_]*)/i |> unfold (reg)->if reg.exec path
				path .= replace reg, /([^\/]+)/$
				[that.1,reg]
			RegExp "^#{path}$",\i
		| \RegExp =>  path
		| \Function => test:path,exec:path
		| otherwise => throw new TypeError "Invalid path #path"

		[]+++funcs |> concat-map (.async!)>>(import do
			match: (req)->method in [\ANY req.method] and (it.match ? reg.test) req.url
			extract: (req)->
				values = (reg.exec req.url) ? []
				req@params import if params? then tail values |> zip that |> list-to-obj else values
				this
		) |> each @routes~push

	::<<< map ::respond, {\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \PATCH \CONNECT \HEAD}

	~>
		server = require \http .create-server (req,res)~>sync ~>try
			start = time!
			[end$,res.end] = [res.end,->console.log "#{res.status-code} #{req.url}: #{time! - start}ms";end$ ...]

			filter (.match req), @routes
			|> map (.sync req,res,_)<<(.extract req)
			|> fold (|>),"404 #{req.url}"
			|> (.pipe res)
		catch => res.end e.stack
		return server import all this