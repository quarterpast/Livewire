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
	@extended = @subclasses~push

	#create :: Method -> ...Stuff -> Maybe Route
	@create = (method, ...spec)->
		if find (.supports? ...spec), @subclasses
			that method,...spec
		else throw new TypeError "No routers can handle #{spec}."

	#route :: Request -> List Function
	@route = (req)->
		concat-map (.find req), @@subclasses

	#error :: Response -> Error -> Nothing
	@error = (res,err)-->
		if err?
			res.status-code = 500
			res.end!

			console.error err.stack ? err.to-string!

	@find = (req)-> # default impl, override me plz (or implement .handlers)
		filter (.match req), @instances
		|> concat-map (.handlers!)

	match:  ->
		throw new TypeError "#{@constructor.display-name} does not implement match"
	handlers: ->
		throw new TypeError "#{@constructor.display-name} does not implement handlers"
	extract: ->
		throw new TypeError "#{@constructor.display-name} does not implement extract"
	~>
		throw new TypeError "#{@constructor.display-name} is abstract and can't be instantiated."

function delegate methods,unto
	methods |> map ((method)->(method): ->@[unto][method] ...) |> fold1 (import)

instance-tracker = (constr)->->
	obj = constr ...
	@constructor[]instances.push obj
	obj

class MatcherRouter extends Router implements delegate <[match extract]> \matcher
	@supports = (spec)->
		spec instanceof Matcher or any (.supports spec), Matcher.subclasses
	handlers: ->[@handler]
	constructor$$: instance-tracker (@matcher,@handler)~>
		if matcher not instanceof Matcher then @matcher = Matcher.create matcher

class Matcher
	@subclasses = []
	@extended = @subclasses~push

	@create = (spec)->
		if find (.supports spec), @subclasses
			that spec
		else throw new TypeError "No matchers can handle #{spec}."

	~>
		throw new TypeError "#{@constructor.display-name} is abstract and can't be instantiated."
	match:  ->
		throw new TypeError "#{@constructor.display-name} does not implement match"
	extract: ->
		throw new TypeError "#{@constructor.display-name} does not implement extract"

class StringMatcher extends Matcher
	(@path)~>
		@params = []
		@reg = path.replace /:([a-z$_][a-z0-9$_]*)/i (m,param)~>
			@params.push param
			/([^\/]+)/$
		|> ->"^#{it}"+(if '/' is last path then '' else \$)
		|> RegExp _,\i

	@supports = ->typeof it is \string

	#match :: Request -> Boolean
	match: (req)->@reg.test req.pathname

	#extract :: Request -> Map String Any
	extract: (req)->
		(@reg.exec req.pathname) ? []
		|> tail
		|> zip @params
		|> list-to-obj

[\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \CONNECT \HEAD] |> each (method)->
	exports[method] = (...spec)~>Router.create method,...spec

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