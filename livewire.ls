require! [sync,http,url]
class exports.PathMatcher
	->
	@extended = @[]subclasses~push
	@create = (pathspec)-->
		if find (.handles pathspec), @subclasses
			new that pathspec
		else throw TypeError "No routers can handle #pathspec"

	match:  ->throw TypeError "#{@constructor.display-name} does not implement match"
	extend: ->throw TypeError "#{@constructor.display-name} does not implement extend"

class StringMatcher extends PathMatcher
	@handles = (instanceof String)
	(path)->
		@params = []
		@reg = path.replace /:([a-z$_][a-z0-9$_]*)/i (m,param)~>
			@params.push param
			/([^\/]+)/$
		|> ->"^#{it}"+(if '/' is last path then '' else \$)
		|> RegExp _,\i
	match: (req)->@reg.test req.pathname
	extract: (req)->
		(@reg.exec req.pathname) ? []
		|> tail
		|> zip @params
		|> list-to-obj

class RegexpMatcher extends PathMatcher
	@handles = (instanceof RegExp)
	(@reg)->
	match: (req)->@reg.test req.pathname
	extract: (req)->
		tail (@reg.exec req.pathname) ? []

class FunctionMatcher extends PathMatcher
	@handles = (instanceof Function)
	(@func)->
	match: (req)-> false isnt @result = @func req.pathname
	extract: (req)->@result

class AlwaysMatcher extends PathMatcher
	@handles = (is true)
	match:   -> yes
	extract: -> {}

class exports.Request
	params: {}
	(req)~>
		import req
		import url.parse req.url,yes

class exports.Response
	(res)~>import res

class exports.Route
	@routes = []

	@error = (err)->
		if err?
			res.status-code = 500
			res.end!

			console.error err.stack ? err.to-string!

	(@method,pathspec,@func)~>
		if typeof! func is \Array
			for fn in func then Route method,pathspec,fn
		else
			@matcher = PathMatcher.create pathspec
			@@routes.push this

for method of {\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \CONNECT \HEAD}
	exports[method] = (path,funcs)~>Route it,path,funcs

exports.use = -> Route \ANY true, it

exports.use ->
	@status-code = 404
	"404 #{@pathname}"

module.exports = (req,res)->
	sync ~>
		req = Request  req # augment!
		res = Response res

		fold1 (|>) <| for route in Route.routes when route.match req
			req.params import route.extract req
			-> @func.sync req,res,it
