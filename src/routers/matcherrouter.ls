require! {
	"../router".Router
	"../meta".delegate
	"../meta".instance-tracker
}

export class MatcherRouter extends Router implements delegate <[match extract]> \matcher
	@supports = (spec)->
		spec instanceof Matcher or any (.supports spec), Matcher.subclasses
	handlers: ->[@handler]
	constructor$$: instance-tracker (@matcher,@handler)~>
		if matcher not instanceof Matcher then @matcher = Matcher.create matcher
		