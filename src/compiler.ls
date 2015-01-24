σ = require \highland
{parse: parse-url} = require \url

last = ([..., x])-> x

# compile-path :: Path → Request → Option Params
exports.compile-path = (path)->
	ident = '[a-z$_][a-z0-9$_]*'
	sigil = ':'
	params = []
	param-reg = path.replace //#sigil(#ident)//ig (m,param)->
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
			σ [{[params[i], val] for val,i in vals}]
		else σ []
