require! {"./stringresponse".StringResponse, http}

export class ErrorResponse extends StringResponse
	@supports = (instanceof Error)

	(error)->
		[@status-code,body] = match error.message
		| (> 0) => [error.message, http.STATUS_CODES[error.message]]
		| otherwise => [500 error.message]

		super body
		@reason = body
