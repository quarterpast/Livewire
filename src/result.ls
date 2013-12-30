{STATUS_CODES} = require \http
{Readable} = require \stream
require \fantasy-streams
Promise = require \fantasy-promises

module.exports = class Result
	(@body, @status-code, @status, @headers)~>

	@simple = (code, body)-->
		Promise.of Result (Readable.of body), code, STATUS_CODES[code], {
			'content-length': body.length
			'content-type': 'text/plain'
		}

	@ok = @simple 200
	@not-found = @simple 404
	@error = @simple 500
	@redirect = (url, code = 302)->
		Result Readable.empty!, code, null, location: url

	with-headers: (@headers import)