require! [sync,url]

require! {
	"./router".Router
	"./matcher".Matcher
}

export Router
export Matcher

String::pipe = ->it.end @constructor this; it
Buffer::pipe = ->it.end this; it

export class Request
	params: {}
	(req)~>
		for k,v of req
			@[k] = if v instanceof Function then v.bind req else v
		import url.parse req.url,yes

export class Response
	(res)~>
		for k,v of res
			@[k] = if v instanceof Function then v.bind res else v

# exports.use = -> Route \ANY true, it

# exports.use ->
# 	@status-code = 404
# 	"404 #{@pathname}"

export function app req,res
#	sync ~>
		try
			augs =
				req: Request req
				res: Response res

			fns = for route in Router.route req then let augs.req,res
				augs.req.params import route.extract augs.req
				->route.func.call augs.req,res,it

			fns
			|> fold (<|),"404 #{augs.req.pathname}"
			|> (.pipe res)
			|> (.on \error Router.error res)
		catch
			Router.error res,e

[\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \CONNECT \HEAD] |> each (method)->
	exports[method] = (...spec)~>Router.create method,...spec
