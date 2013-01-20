require! {
	"../router".Router
}

export class AlwaysRouter extends Router
	@supports = (is true)
	match: -> yes
	extract:  -> {}
	handlers: -> [] ++ @handler
	(method,void,@handler)~>
