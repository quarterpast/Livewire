require! {
	"../router".Router
	"../matcher".Matcher
}

export class MatcherRouter extends Router
	@supports = (spec)->
		spec instanceof Matcher or any (.supports spec), Matcher.subclasses
	match:    -> super ... and @matcher.match it
	extract:  -> @matcher.extract it
	(method,@matcher,handler)~>
		super method

		@handlers = []+++handler
		if matcher not instanceof Matcher then @matcher = Matcher.create matcher
