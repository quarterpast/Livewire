require! \require-folder
export class Response
	status-code: 404

	@subclasses = []
	@extended = @subclasses~push

	@to-response = (res)->
		if res instanceof Response then res
		else @create res

	@create = (spec)->
		if spec? and find (.supports spec), @subclasses
			that spec
		else
			throw new TypeError "No responses can handle #{spec}."

	@add = (a, b)->
		res-a = @to-response a
		res-b = @to-response b

		new Response
			.. import res-a
			.. import res-b

			..status-code = res-b.status-code ? res-a.status-code
			..headers = res-a.headers import res-b.headers
			..body = res-a.body.pipe res-b.body

	@handle = (res,handler)->
		if res.final then res
		else res `@add` handler res

	@final = (res)->
		(Response.to-response res) import {+final}

	respond: (res)->
		res.write-head @status-code,@reason ? '',@headers
		res import this
		@body.pipe res


	(@body)~>
		@headers = {}
		@reason = null


require-folder "./responses"