require! "../matcher".Matcher

export class RegexMatcher extends Matcher
	(@path)~>
		{@params ? []} = path

	@supports = (instanceof RegExp)

	#match :: Request -> Boolean
	match: (req)->@path.test req.pathname

	#extract :: Request -> Map String Any
	extract: (req)->
		[route,...vals] = (@path.exec req.pathname) ? []

		req import {route}

		if empty @params then vals
		else list-to-obj zip @params,vals

	reverse: -> # sure you can construct strings matching regexes but like hell am i doing it now