require! {
	"../response".Response
	"stream".Duplex
}

export class StringResponse extends Response
	@supports = ->it.constructor is String or it instanceof Buffer

	status-code: 200

	(body)~>
		super new class extends Duplex
			_read: (size)->
				if @push body
					@push null # end the stream
			_write: (chunk,encoding,callback)->
				callback null # disregard input