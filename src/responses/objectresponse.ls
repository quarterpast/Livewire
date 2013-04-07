require! "../response".Response

export class ObjectResponse extends Response
	@supports = (obj)->
		obj.body? and Response.subclasses
		|> reject (is ObjectResponse)
		|> any (.supports obj.body)

	(res)~>
		body = delete res.body
		return (Response.create body) import res