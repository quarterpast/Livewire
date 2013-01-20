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

exports.use = -> Router.create \ANY true, it

exports.use (res)->
	@status-code = 404
	end$ = res.end
	res.end = ~>
		console.log "#{res.status-code} #{@pathname}"
		end$.apply res,&

	"404 #{@pathname}"

export function app req,res
	augs =
		req: Request req
		res: Response res
	sync do
		:fiber ~>
			Router.route augs.req
			|> each (.extract augs.req)>>(augs.req.params import)
			|> concat-map (.handlers req)>>map (func,last)-->
				augs.res.status-code = 200
				func.(if func.to-string! == /.async()$/ then \sync else \call) augs.req,augs.res,last
			|> fold (|>),""
			|> (.pipe augs.res)
			|> (.on \error Router.error augs.res)

		Router.error augs.res


[\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \CONNECT \HEAD] |> each (method)->
	exports[method] = (...spec)~>Router.create method,...spec

export async = (.async!)