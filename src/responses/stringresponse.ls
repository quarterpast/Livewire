require! {
	"../response".Response
	"readable-stream".Duplex
}

export class StringResponse extends Response
	@supports = ->it.constructor is String or it instanceof Buffer

	status-code: 200

	(body)~>
		super new class extends Duplex
			offset: 0
			_read: (size)->
				@push body.slice @offset,@offset+size-1
				@offset += size
				if @offset > body.length then return @push null # end the stream

			_write: (chunk,encoding,callback)->
				callback null # disregard input