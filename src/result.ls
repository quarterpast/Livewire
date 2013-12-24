{STATUS_CODES} = require \http

export class Result
	(@body, @status-code, @status = STATUS_CODES[status-code], headers)~>
		@headers = {
			'content-length': body.length
			'content-type': 'text/plain'
		} import headers

	@ok = (body)-> Result body, 200
	@not-found = (body)-> Result body, 404
	@redirect = (url, code = 302)->
		Result "", code, null, location: url

	with-headers: (@headers import)