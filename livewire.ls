require! [sync,url]

String::pipe = (.end @constructor this)
Buffer::pipe = (.end this)

class exports.Request
	params: {}
	(req)~>
		import req
		import url.parse req.url,yes

class exports.Response
	(res)~>import res


class exports.Router
	@subclasses = []
	@extended = (subclass)->
		@subclasses.push ->
			subclass[]instances.push this # lol wrap constructors i'm so dirty
			subclass ...

	#create :: Method -> ...Stuff -> Maybe Route
	@create = (method, ...spec)->
		if find (.supports ...spec), @subclasses
			new that method,...spec
		else throw TypeError "No routers can handle #{spec}."

	#route :: Request -> List Function
	@route = (req)->
		concat-map (.find req), @@subclasses

	#error :: Response -> Error -> Nothing
	@error = (res,err)-->
		if err?
			res.status-code = 500
			res.end!

			console.error err.stack ? err.to-string!

	@find = (req)-> # default impl, override me plz (or implement .handler)
		filter (.match req), @instances
		|> concat-map (.handlers!)

	match:  ->
		throw TypeError "#{@constructor.display-name} does not implement match"
	handlers: ->
		throw TypeError "#{@constructor.display-name} does not implement handlers"
	extract: ->
		throw TypeError "#{@constructor.display-name} does not implement extract"

	~>
		throw "#{@constructor.display-name} is abstract and can't be instantiated."

function delegate methods,unto
	{[method, ->@[unto][method] ...] for method in methods}

class MatcherRouter implements delegate <[match extract]> \matcher extends Router
	@supports = (instanceof Matcher)
	# match:    ->@matcher.match it
	# extract:  ->@matcher.extract it
	handlers: ->[@handler]
	(@matcher,@handler)->

class Matcher
	~>
		throw "#{@constructor.display-name} is abstract and can't be instantiated."
	match:  ->
		throw TypeError "#{@constructor.display-name} does not implement match"
	extract: ->
		throw TypeError "#{@constructor.display-name} does not implement extract"

class StringMatcher extends Matcher
	(@method,@path,@handler)~>
		@params = []
		@reg = path.replace /:([a-z$_][a-z0-9$_]*)/i (m,param)~>
			@params.push param
			/([^\/]+)/$
		|> ->"^#{it}"+(if '/' is last path then '' else \$)
		|> RegExp _,\i

	#match :: Request -> Boolean
	match: (req)->@reg.test req.pathname

	#extract :: Request -> Map String Any
	extract: (req)->
		(@reg.exec req.pathname) ? []
		|> tail
		|> zip @params
		|> list-to-obj


# exports.use = -> Route \ANY true, it

# exports.use ->
# 	@status-code = 404
# 	"404 #{@pathname}"

exports.app = (req,res)->
	sync ~>
		try
			aug-req = Request req

			tap = (fn,a)-->fn a; a

			fns = for route in Route.route req then let aug-req,res
				aug-req.params import route.extract aug-req
				->route.func.sync aug-req,(Response res),it

			fns
			|> fold (<|),"404 #{req.pathname}"
			|> (.pipe aug-res)
			|> (.on \error Route.error res)
		catch
			Route.error res,e