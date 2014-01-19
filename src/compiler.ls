{Some, None} = require \fantasy-options
{parse: parse-url} = require \url

last = -> it[it.length - 1]

# compile-path :: Path → Request → Option Params
export compile-path = (path)->
	ident = '[a-z$_][a-z0-9$_]*'
	sigil = ':'
	params = []
	param-reg = path.replace //#sigil(#ident)//i (m,param)->
		params.push param # yay side effects
		/([^\/]+)/$

	reg = switch
	| path is '/'      => /^\/$/
	| '/' is last path => //^#{param-reg}?//i
	| otherwise        => //^#param-reg\/?$//i # optional trailing slash

	(url)->
		{pathname} = parse-url url
		if (reg.exec pathname)?
			[route, ...vals] = that
			Some {[params[i], val] for val,i in vals}
		else None
