{Some, None} = require \fantasy-options
{parse: parse-url} = require \url

# compile-path :: Path → Request → Option Params
compile-path = (path)->
	ident = '[a-z$_][a-z0-9$_]*'
	sigil = ':'
	params = []
	param-reg = path.replace //#sigil(#ident)//i (m,param)->
		params.push param # yay side effects
		/([^\/]+)/$
	end = if '/' is path[path.length - 1] and path isnt '/' then '' else \$
	reg = RegExp \^ + param-reg + end, \i

	(req)->
		{pathname} = parse-url req.url

		if (reg.exec pathname)?
			[route, ...vals] = that
			Some {[param[i], val] for val,i of vals}
		else None
