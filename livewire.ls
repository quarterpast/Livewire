require! [sync,http,url]
String::pipe = Buffer::pipe = (.end @constructor this)
String::on = Buffer::on = ->@

module.exports = (routes = [])->
	function route method then (path,funcs)->
		params = []
		reg = switch typeof! path
		| \String =>
			path.replace /:([a-z$_][a-z0-9$_]*)/i (m,param)->
				params.push param; /([^\/]+)/$
			|> ->"^#{it}"+(if '/' is last path then '' else \$)
			|> RegExp _,\i
		| \RegExp => path
		| \Function => test:path,exec:path
		| otherwise => throw new TypeError "Invalid path #path"

		[]+++funcs |> concat-map (<<< do
			match: ->method in [\ANY it.method] and reg.test it.pathname
			handle: (req,res)->
				vals = (reg.exec req.pathname) ? []
				req.route = path
				req{}params <<< if params? then tail vals |> zip that |> list-to-obj else vals
				if res.skip and not it.always then id else (last)~>it.sync req,(res<<<status-code:200),last
		)<<(.async!) |> each routes~push
		this

	(http.create-server (req,res)->
		error = ->if it?
			(res <<< status-code:500)end! ; console.log it.stack ? it.to-string!
		sync do
			:fiber -> let start = Date.now!, end$ = (res <<< status-code:404).end
				res.end = -> console.log "#{res.status-code} #{req.url}: #{Date.now! - start}ms"; end$ ...
				req <<< url.parse req.url,yes
				fold (|>),"404 #{req.pathname}",[r.handle req,res for r in routes when r.match req] .on \error error .pipe res
			error
	)<<< map route,{\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \CONNECT \HEAD}
	<<< use: ->routes.push it.async!<<<match:(->yes),handle:(req,res)->(last)->it.sync req,res,last