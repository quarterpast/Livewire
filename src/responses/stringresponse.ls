require! {
	"../response".Response
	"stream".Duplex
}

export class StringResponse extends Response
	@supports = (.constructor is String)

	status-code: 200

	(body)->
		super new class extends Duplex
			_read: (size)->
				if @push body
					@push null # end the stream
			_write: (chunk,encoding,callback)->
				callback null # disregard input