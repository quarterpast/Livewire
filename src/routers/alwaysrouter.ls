require! {
	"../router".Router
}

export class AlwaysRouter extends Router
	@supports = (is true)
	match: -> yes
	extract:  -> {}
	handlers: -> [] ++ @handler
	has: -> no # doesn't make sense to reverse these
	reverse: -> # never gets called
	(method,void,@handler)~>
