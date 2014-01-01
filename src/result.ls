{STATUS_CODES} = require \http
{Readable} = require \stream
require \fantasy-streams
Promise = require \fantasy-promises

module.exports = class Result
	(@body, @status-code, @status, @headers)~>

	@simple = (code, body)-->
		Result (Readable.of body), code, STATUS_CODES[code], {
			'content-length': body.length
			'content-type': 'text/plain'
		}

	@ok = Promise.of . @simple 200
	@not-found = Promise.of . @simple 404
	@error = Promise.of . @simple 500
	@redirect = (url, code = 302)->
		Promise.of Result Readable.empty!, code, null, location: url

	with-headers: (@headers import)