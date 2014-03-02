require! {
	'karma-sinon-expect'.expect
	'../lib/respond'
	'fantasy-options'.Some
	'fantasy-options'.None
	'../lib/compiler'
}

export 'Responder':

	"should create dsl methods": ->
		expect respond
		.to.have.keys <[get post put delete patch options head trace connect]>

	'returns None if method doesn\'t match': ->
		r = respond \GET '/' ->
		expect (r method:\POST url:'/') .to.be None

	'returns None if compile doesn\'t match': ->
		r = respond \GET '/' ->
		expect (r method:\GET url:'/nope') .to.be None

	'calls responder with request, returns a Some': ->
		resp = expect.sinon.stub!
		resp.returns \response
		route = respond \GET '/' resp
		request = method:\GET url:'/'
		response = route request

		expect resp .to.be.called!
		expect resp.last-call.args.0 .to.eql request
		expect resp.last-call.args.0 .to.have.property \params
		expect response .to.be.a Some
		expect response .to.have.property \x \response