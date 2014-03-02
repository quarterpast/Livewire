require! {
	'karma-sinon-expect'.expect
	'../lib'.Result
}

export
	"constructor": ->
		expect new Result .to.be.a Result
	"newless constructor": ->
		expect Result! .to.be.a Result
	"simple should create a stream": ->
		expect (Result.simple null "hello" .body.readable) .to.be.ok!
	"simple should set code": ->
		expect (Result.simple 200 "" .status-code) .to.be 200
	"simple should set status": ->
		expect (Result.simple 200 "" .status) .to.be \OK
	"simple should set default headers": ->
		h = Result.simple 200 "hello" .headers
		expect h'content-length' .to.be 5
		expect h'content-type' .to.be 'text/plain'
	"with-headers should override": ->
		{headers} = Result.simple 200 "hello" .with-headers 'content-type':'text/html'
		expect headers.'content-type' .to.be 'text/html'
	"ok should return a promise for a simple": ->
		r = Result.ok "hello" .extract!
		expect r .to.be.a Result
		expect r.status-code .to.be 200
	"error should return a promise for a simple": ->
		r = Result.error "hello" .extract!
		expect r .to.be.a Result
		expect r.status-code .to.be 500
	"not-found should return a promise for a simple": ->
		r = Result.not-found "hello" .extract!
		expect r .to.be.a Result
		expect r.status-code .to.be 404
	"redirect should return a promise for a 302": ->
		r = Result.redirect "/hello" .extract!
		expect r .to.be.a Result
		expect r.status-code .to.be 302
		expect r.headers.location .to.be "/hello"