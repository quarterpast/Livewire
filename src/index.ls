require! [sync,url]

require! {
	"./router".Router
	"./matcher".Matcher
	"./response".Response
	"./responses/emptyresponse".EmptyResponse
	"./handlercontext".HandlerContext
}

global import require \prelude-ls

export Router
export Matcher
export Response
export HandlerContext

String::pipe = ->it.end @constructor this; it
Buffer::pipe = ->it.end this; it

export class Request
	(req)~>

exports.use = -> Router.create \ANY true, it
exports.log = (res)-> console.log "#{res.status-code} #{@pathname}"

export function app req,res
	req import Request req
	ctx = new HandlerContext req
	sync do
		:fiber ~>
			Router.route ctx
			|> each (.extract ctx)>>(ctx.params import)
			|> concat-map (.handlers ctx)>>map (.bind ctx)
			|> fold Response~handle, EmptyResponse ctx.path
			|> (.respond res)
			|> (.on \error Router.error res)

		Router.error res


[\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \CONNECT \HEAD] |> each (method)->
	exports[method] = (...spec)~>Router.create method,...spec

export async = (.async!)