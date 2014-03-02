require! {
	http.STATUS_CODES
	from
	Promise: \fantasy-promises
}

module.exports = class Result
	(@body, @status-code, @status, @headers)~>

	@simple = (code, body)-->
		Result (from [body]), code, STATUS_CODES[code], {
			'content-length': body.length
			'content-type': 'text/plain'
		}

	@ok = Promise.of . @simple 200
	@not-found = Promise.of . @simple 404
	@error = Promise.of . @simple 500
	@redirect = (url, code = 302)->
		Promise.of Result (from []), code, null, location: url

	with-headers: (more)->
		@headers import more
		return this

# ignore curry in coverage
/* istanbul ignore next */