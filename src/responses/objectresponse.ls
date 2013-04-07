require! "../response".Response

export class ObjectResponse extends Response
	@supports = (.body?)

	(res)~>
		body = delete res.body
		return (Response.create body) import res