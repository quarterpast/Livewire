require! {
	"../response".Response
	"stream".Stream
	"stream".Duplex
}

export class StreamResponse extends Response
	@supports = (instanceof Stream)

	status-code: 200

	(body)~>
		super match body
		| (.writable) and (.readable) => body
		| (.writable) => new class extends Duplex
			_write: body~_write
			_read: (size)->
				if @push ""
					@push null # end the stream
		| (.readable) => new class extends Duplex
			_write: (chunk,encoding,callback)->
				callback null # disregard input
			_read: (size)->
				@push body.read size