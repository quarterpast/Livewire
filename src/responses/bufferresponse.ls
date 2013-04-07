require! "./stringresponse".StringResponse

export class BufferResponse extends StringResponse
	@supports = (instanceof Buffer)
