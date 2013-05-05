require! {"../response".Response, http, stream.Stream}

export class ObjectResponse extends Response
	@supports = (obj)->
		obj.body? and Response.subclasses
		|> reject (is ObjectResponse)
		|> any (.supports obj.body)

	(res)~>
		body = delete res.body
		res.reason ?= http.STATUS_CODES[that] if res.status-code?
		return (Response.create body) import res