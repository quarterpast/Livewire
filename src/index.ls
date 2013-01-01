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
	sync ~>
		try
			augs =
				req: Request req
				res: Response res

			Router.route augs.req
			|> each (.extract augs.req)>>(augs.req.params import)
			|> concat-map (.handlers!)>>map (.async!)>>(func,last)-->
				res.status-code = 200
				func.sync augs.req,augs.res,last
			|> fold (|>),""
			|> (.pipe augs.res)
			|> (.on \error Router.error augs.res)
		catch
			Router.error augs.res,e

[\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \CONNECT \HEAD] |> each (method)->
	exports[method] = (...spec)~>Router.create method,...spec
