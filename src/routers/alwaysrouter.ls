require! {
	"../router".Router
}

export class AlwaysRouter extends Router
	@supports = (is true)
	match: -> yes
	extract:  -> {}
	(method,void,handler)~>
		@handlers = [] ++ handler
