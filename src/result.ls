{STATUS_CODES} = require \http
{Readable} = require \stream
require \fantasy-streams

export class Result
	(@body, @status-code = 200, @status = STATUS_CODES[status-code], headers)~>
		@headers = {
			'content-length': body.length
			'content-type': 'text/plain'
		} import headers

	@simple = (code, body)-->
		Result (Readable.of body), code
	@ok = @simple 200
	@not-found = @simple 404
	@redirect = (url, code = 302)->
		Result Readable.empty!, code, null, location: url

	with-headers: (@headers import)