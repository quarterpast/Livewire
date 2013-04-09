require! "../matcher".Matcher

export class RegexMatcher extends Matcher
	(@path)~>
		{@params ? []} = path

	@supports = (instanceof RegExp)

	#match :: Request -> Boolean
	match: (ctx)->@path.test ctx.pathname

	#extract :: Request -> Map String Any
	extract: (ctx)->
		[route,...vals] = (@path.exec ctx.pathname) ? []

		ctx import {route}

		if empty @params then vals
		else list-to-obj zip @params,vals

	reverse: -> # sure you can construct strings matching regexes but like hell am i doing it now