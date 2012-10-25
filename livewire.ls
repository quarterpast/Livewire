sync = require \sync; String::pipe = Buffer::pipe = (.end @constructor this)

module.exports = (routes = [])->
	function respond method then (path,funcs)->
		reg = switch typeof! path
		| \String =>
			params = [/:([a-z$_][a-z0-9$_]*)/i,path] |> unfold ([ident,part])->
				if ident.exec part then [that.1,[ident,part.replace ident, /([^\/]+)/$]] else path := part; null
			RegExp "^#{path}$",\i
		| \RegExp => path
		| \Function => test:path,exec:path
		| otherwise => throw new TypeError "Invalid path #path"

		[]+++funcs |> concat-map (<<< do
			match: ->method in [\ANY it.method] and reg.test it.pathname
			handle: (req,res)->
				vals = (reg.exec req.pathname) ? []
				req@params <<< if params? then tail vals |> zip that |> list-to-obj else vals
				if res.skip and not it.always then id else (last)~>it.sync req,res,last
		)<<(.async!) |> each routes~push
		this

	(require \http .create-server (req,res)->sync ->try start = Date.now!; end$ = res.end
		res <<< end:(->console.log "#{res.status-code} #{req.url}: #{Date.now! - start}ms"; end$ ...);
		req <<< require \url .parse req.url,yes
		fold (|>),"404 #{req.pathname}",[r.handle req,res for r in routes when r.match req] .pipe res
	catch => res.end e.stack)
	<<< map respond,{\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \CONNECT \HEAD}
	<<< use: ->routes.push it.async!<<<match:(->yes),handle:(req,res)->(last)->it.sync req,res,last