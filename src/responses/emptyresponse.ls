require! "./stringresponse".StringResponse

export class EmptyResponse extends StringResponse
	status-code: 404

	(path)~> super "404 #path"