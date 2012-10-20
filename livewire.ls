sync = require \sync; String::pipe = Buffer::pipe = (.end @constructor this)

module.exports = let routes = []
	function respond method then (path,funcs)->
		reg = switch typeof! orig-path = path
		| \String =>
			params = /:([a-z$_][a-z0-9$_]*)/i |> unfold (ident)->if ident.exec path
				path .= replace ident, /([^\/]+)/$
				[that.1,ident]
			RegExp "^#{path}$",\i
		| \RegExp =>  path
		| \Function => test:path,exec:path
		| otherwise => throw new TypeError "Invalid path #path"

		[]+++funcs |> concat-map (<<< do
			match: ->method in [\ANY it.method] and reg.test it.pathname
			handle: (req,res)->(last)~>
				vals = (reg.exec req.pathname) ? []
				req@params <<< if params? then tail vals |> zip that |> list-to-obj else vals
				if last.escape is escape and it.unescape isnt unescape then last else it.sync req,res,last
		)<<(.async!) |> each routes~push

	(require \http .create-server (req,res)->sync ->try start = Date.now!; end$ = res.end
		res <<< end:(->console.log "#{res.status-code} #{req.url}: #{Date.now! - start}ms"; end$ ...);
		req <<< require \url .parse req.url,yes
		fold (|>),"404 #{req.pathname}",[r.handle req,res for r in routes when r.match req] .pipe res
	catch => res.end e.stack)
	<<< map respond,{\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \CONNECT \HEAD}
	<<< use: ->routes.push it.async!<<<match:(->yes),handle:(req,res)->(last)->it.sync req,res,last