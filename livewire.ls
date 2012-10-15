sync = require \sync

module.exports = new class Router
	time = ->Date|>(new)>>(.get-time!)
	String::pipe = Buffer::pipe = (.end @constructor this)
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

		[]+++funcs |> concat-map (.async!)>>(import let orig = it.match
			match: (req)->method in [\ANY req.method] and (orig ? reg~test<<(.url)) req
			extract: (req)->
				values = (reg.exec req.url) ? []
				req@params import if params? then tail values |> zip that |> list-to-obj else values
				this
		) |> each this@@routes~push

	::<<< map ::respond, {\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \PATCH \CONNECT \HEAD}

	~>
		server = require \http .create-server (req,res)~>sync ~>try
			start = time!
			[end$,res.end] = [res.end,->console.log "#{res.status-code} #{req.url}: #{time! - start}ms";end$ ...]

			[r.extract req .sync req,res,_ for r in @routes when r.match req]
			|> fold (|>),"404 #{req.url}"
			|> (.pipe res)
		catch => (if @error? then that else res~end) e.stack
		return server import all this