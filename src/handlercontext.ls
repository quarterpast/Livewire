require! url

export class HandlerContext
	(@request)~>
		@params = {}
		import url.parse request.url,yes
