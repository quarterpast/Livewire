require! {
	"../response".Response
	"stream".Stream
}

export class StreamResponse extends Response
	@supports = ->it instanceof Stream and it.readable
	status-code: 200
	~> super it