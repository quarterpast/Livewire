require! [sync,url]

require! {
	"./router".Router
	"./matcher".Matcher
	"./response".Response
	"./responses/emptyresponse".EmptyResponse
}

global import require \prelude-ls

export Router
export Matcher
export Response

String::pipe = ->it.end @constructor this; it
Buffer::pipe = ->it.end this; it

export class Request
	(req)~>
		@params = {}
		import url.parse req.url,yes

exports.use = -> Router.create \ANY true, it
exports.log = (res)-> console.log "#{res.status-code} #{@pathname}"

export function app req,res
	req import Request req
	sync do
		:fiber ~>
			Router.route req
			|> each (.extract req)>>(req.params import)
			|> concat-map (.handlers req)>>map (.bind req)
			|> fold Response~handle, new EmptyResponse req.path
			|> (.respond res)
			|> (.on \error Router.error res)

		Router.error res


[\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \CONNECT \HEAD] |> each (method)->
	exports[method] = (...spec)~>Router.create method,...spec

export async = (.async!)