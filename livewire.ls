require! [sync,url]

String::pipe = (.end @constructor this)
Buffer::pipe = (.end this)

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
	@handles = (typeof)>>(is \string)
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

	@error = (res,err)-->
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
	exports[method] = (path,funcs)~>Route method,path,funcs

exports.use = -> Route \ANY true, it

exports.use ->
	@status-code = 404
	"404 #{@pathname}"

exports.app = (req,res)->
	sync ~>
		try
			aug-req = Request  req

			tap = (fn,a)-->fn a; a

			for route in Route.routes when route.matcher.match aug-req
				aug-req.params import route.matcher.extract aug-req
				-> route.func.sync aug-req,(Response res),it
			|> tap console.log
			|> fold1 (|>)
			|> (.pipe aug-res)
			|> (.on \error Route.error res)
		catch
			Route.error res,e