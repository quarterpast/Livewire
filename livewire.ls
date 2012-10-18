sync = require \sync
String::pipe = Buffer::pipe = (.end @constructor this)

module.exports = let me = {}, routes = [(->it.status-code = 404; "404 #{@pathname}")<<<match:(->yes),carp:->@]
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
			carp: ->
				values = (reg.exec it.pathname) ? []
				it@params <<< if params? then tail values |> zip that |> list-to-obj else values
				this
		)<<(.async!) |> each routes~push
	me.use(fn)= routes.push fn<<<match:(->yes),carp:->@
	me<<<map me.respond,{\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \CONNECT \HEAD}

	server = require \http .create-server (req,res,start = Date.now!, end$ = res.end)-> sync ->try
		res.end = ->console.log "#{res.status-code} #{req.url}: #{Date.now! - start}ms"; end$ ...
		req <<< require \url .parse req.url,yes
		fold1 (|>),[r.carp req .sync req,res,_ for r in routes when r.match req] .pipe res
	catch => res.end e.stack
	server <<<< me