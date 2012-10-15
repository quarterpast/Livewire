String::pipe = Buffer::pipe = (.end @constructor this)

module.exports = let me = {}, routes = []
	me.respond(method,path,funcs)=
		reg = switch typeof! path
		| \String =>
			params = /:([a-z$_][a-z0-9$_]*)/i |> unfold (ident)->if ident.exec path
				path .= replace ident, /([^\/]+)/$
				[that.1,ident]
			RegExp "^#{path}$",\i
		| \RegExp =>  path
		| \Function => test:path,exec:path
		| otherwise => throw new TypeError "Invalid path #path"

		[]+++funcs |> concat-map (<<< let orig = it.match
			match: ->method in [\ANY it.method] and (orig ? reg~test<<(.pathname)) it
			extract: ->
				values = (reg.exec it.pathname) ? []
				it@params <<< if params? then tail values |> zip that |> list-to-obj else values
				this
		)<<(.async!) |> each routes~push

	me<<<map me.respond,{\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \CONNECT \HEAD}

	server = require \http .create-server (req,res)~>require \sync <| ~>try
		[end$,start,res.end] = [res.end,Date.now!,
		->console.log "#{res.status-code} #{req.url}: #{Date.now! - start}ms";end$ ...]
		req <<< require \url .parse req.url,yes
		[r.extract req .sync req,res,_ for r in routes when r.match req]
		|> fold (|>),"404 #{req.url}"
		|> (.pipe res)
	catch => (if @error? then that else res~end) e.stack
	server <<<< me