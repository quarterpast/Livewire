require! "../matcher".Matcher

export class StringMatcher extends Matcher
	(@path)~>
		@params = []
		@reg = path.replace /:([a-z$_][a-z0-9$_]*)/i (m,param)~>
			@params.push param
			/([^\/]+)/$
		|> ->"^#{it}"+(if '/' is last path then '' else \$)
		|> RegExp _,\i

	@supports = ->typeof it is \string

	#match :: Request -> Boolean
	match: (req)->@reg.test req.pathname

	#extract :: Request -> Map String Any
	extract: (req)->
		(@reg.exec req.pathname) ? []
		|> tail
		|> zip @params
		|> list-to-obj
