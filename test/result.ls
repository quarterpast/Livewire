require! {
	'../test'
	'../lib'.Result
}

test do
	"constructor": new Result instanceof Result
	"newless constructor": Result! instanceof Result
	"simple should create a stream": Result.simple null "hello" .body.readable
	"simple should set code": Result.simple 200 "" .status-code is 200
	"simple should set status": Result.simple 200 "" .status is \OK
	"simple should set default headers": do
		h = Result.simple 200 "hello" .headers
		h.'content-length' is 5 and h.'content-type' is 'text/plain'
	"with-headers should override": do
		Result.simple 200 "hello"
		.with-headers 'content-type':'text/html'
		.headers.'content-type' is 'text/html'
	"ok should return a promise for a simple": do
		r = Result.ok "hello" .extract!
		r instanceof Result and r.status-code is 200
	"error should return a promise for a simple": do
		r = Result.error "hello" .extract!
		r instanceof Result and r.status-code is 500
	"not-found should return a promise for a simple": do
		r = Result.not-found "hello" .extract!
		r instanceof Result and r.status-code is 404
	"redirect should return a promise for a 302": do
		r = Result.redirect "/hello" .extract!
		r instanceof Result
		and r.status-code is 302
		and r.headers.location is "/hello"