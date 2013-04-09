require! "../matcher".Matcher

export class RegexMatcher extends Matcher
	(@path)~>
		{@params ? []} = path

	@supports = (instanceof RegExp)

	#match :: Request -> Boolean
	match: (req)->@path.test req.pathname

	#extract :: Request -> Map String Any
	extract: (ctx)->
		[route,...vals] = (@path.exec ctx.request.pathname) ? []

		ctx import {route}

		if empty @params then vals
		else list-to-obj zip @params,vals

	reverse: -> # sure you can construct strings matching regexes but like hell am i doing it now