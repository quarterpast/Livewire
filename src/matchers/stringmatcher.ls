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
	match: (req)->
		@reg.test req.pathname

	#extract :: Request -> Map String Any
	extract: (req)->
		(@reg.exec req.pathname) ? []
		|> tail
		|> zip @params
		|> list-to-obj

	#reverse :: Function -> Map String Any -> Path
	reverse: (fn,params)->
		route-params = @params

		unless (in route-params) `all` keys params
			bad = keys params |> reject (in route-params)
			throw new TypeError "Parameters #{join ', ' bad} not in StringMatcher #{@path}"

		[@path.replace /:([a-z$_][a-z0-9$_]*)/i (m,key)->params[key]]