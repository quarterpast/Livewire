require! [sync,http,url]

class exports.PathMatcher
	-> ... #abstract
	@extended = @[]subclasses~push
	@create = (pathspec)-->
		if find (.handles pathspec), @subclasses
			new that pathspec
		else throw TypeError "No routers can handle #pathspec"


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

class AlwaysMatcher extends PathMatcher
	class @spec then ~>
	@handles = (instanceof @spec)

	match:   -> yes
	extract: -> {}


class exports.Request
	(req)->
		import req
		import url.parse req.url,yes

class exports.Response
	(res)->import res

class exports.Route
	@routes = []

	@error = (err)->
		if err?
			res.status-code = 500
			res.end!

			console.error err.stack ? err.to-string!

	@serve = (req,res)->
		sync ~>
			req = new Request  req # augment!
			res = new Response res

			for route in @@routes when route.match req
				route.extract req


	(@method,pathspec,@func)~>
		@matcher = PathMatcher.create pathspec
		@@routes.push this



for method of {\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \CONNECT \HEAD}
	exports[method] = (path,funcs)~>Route it,path,funcs

exports.use = -> Route \ANY AlwaysMatcher.spec!, it

exports.use ->
	@status-code = 404
	"404 #{@pathname}"