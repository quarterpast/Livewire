require! [sync,url]

require! {
	"./router".Router
	"./matcher".Matcher
}

export Router
export Matcher

String::pipe = (.end @constructor this)
Buffer::pipe = (.end this)

export class Request
	params: {}
	(req)~>
		import req
		import url.parse req.url,yes

export class Response
	(res)~>import res

# exports.use = -> Route \ANY true, it

# exports.use ->
# 	@status-code = 404
# 	"404 #{@pathname}"

export function app req,res
	sync ~>
		try
			aug-req = Request req

			fns = for route in Route.route req then let aug-req,res
				aug-req.params import route.extract aug-req
				->route.func.sync aug-req,(Response res),it

			fns
			|> fold (<|),"404 #{req.pathname}"
			|> (.pipe aug-res)
			|> (.on \error Route.error res)
		catch
			Route.error res,e

[\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \CONNECT \HEAD] |> each (method)->
	exports[method] = (...spec)~>Router.create method,...spec
