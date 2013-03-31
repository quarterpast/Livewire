require! "../matcher".Matcher

export class FunctionMatcher extends Matcher
	(@path)~>

	@supports = (instanceof Function)

	#match :: Request -> Boolean
	match: (req)->false isnt @path req

	#extract :: Request -> Map String Any
	extract: ->
		it.route = it.pathname
		@path it

	reverse: -> # can't reverse a function