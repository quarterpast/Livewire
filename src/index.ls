require! [sync,url]

require! {
	"./router".Router
	"./matcher".Matcher
}

global import require \prelude-ls

export Router
export Matcher

String::pipe = ->it.end @constructor this; it
Buffer::pipe = ->it.end this; it

export class Request
	(req)~>
		@params = {}
		import url.parse req.url,yes

export class Response
	(res)~>

exports.use = -> Router.create \ANY true, it
exports.log = (res)-> console.log "#{res.status-code} #{@pathname}"


exports.use (res)->
	res.status-code = 404
	end$ = res.end
	res.end = ~>
		exports.log.call this,res
		end$.apply res,&

	"404 #{@pathname}"

export function app req,res
	req import Request req
	res import Response res
	sync do
		:fiber ~>
			Router.route req
			|> each (.extract req)>>(req.params import)
			|> concat-map (.handlers req)>>map (func,last)-->
				res.status-code = 200
				func.(if func.to-string! == /.async()$/ then \sync else \call) req,res,last
			|> fold (|>),""
			|> (.pipe res)
			|> (.on \error Router.error res)

		Router.error res


[\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \CONNECT \HEAD] |> each (method)->
	exports[method] = (...spec)~>Router.create method,...spec

export async = (.async!)