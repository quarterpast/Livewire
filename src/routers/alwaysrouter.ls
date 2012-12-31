require! {
	"../router".Router
}

export class AlwaysRouter extends Router
	@supports = (is true)
	handlers: -> []+++@handler
	match: -> yes
	extract:  -> {}
	(method,void,@handler)~>