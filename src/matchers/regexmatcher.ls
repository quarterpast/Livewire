require! "../matcher".Matcher

export class RegexMatcher extends Matcher
	(@path)~>
		{@params ? []} = path

	@supports = (instanceof RegExp)

	#match :: Request -> Boolean
	match: (req)->@path.test req.pathname

	#extract :: Request -> Map String Any
	extract: (req)->
		vals = tail (@path.exec req.pathname) ? []

		if empty @params then vals
		else list-to-obj zip @params,vals