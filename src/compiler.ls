{Some, None} = require \fantasy-options
{parse: parse-url} = require \url

# compile-path :: Path → Request → Option Params
export compile-path = (path)->
	ident = '[a-z$_][a-z0-9$_]*'
	sigil = ':'
	params = []
	param-reg = path.replace //#sigil(#ident)//i (m,param)->
		params.push param # yay side effects
		/([^\/]+)/$
	end = if '/' is path[path.length - 1] and path isnt '/' then '' else \$
	reg = //^#param-reg#end//i

	(url)->
		{pathname} = parse-url url
		if (reg.exec pathname)?
			[route, ...vals] = that
			Some {[params[i], val] for val,i in vals}
		else None
