require! [sync,url]

require! {
	"./router".Router
	"./routerfactory".RouterFactory
	"./matcher".Matcher
	"./response".Response
	"./responses/emptyresponse".EmptyResponse
	"./handlercontext".HandlerContext
}

global import require \prelude-ls

class Livewire
	use: -> Router.create \ANY true, it
	log: (res)-> console.log "#{res.status-code} #{@pathname}"

	app: (req,res)~>
		ctx = new HandlerContext req
		sync do
			:fiber ~>
				@factory.route ctx
				|> each (.extract ctx)>>(ctx.params import)
				|> concat-map (.handlers ctx)>>map (.bind ctx .async!)
				|> fold Response~handle, EmptyResponse ctx.path
				|> (.respond res)
				|> (.on \error Router.handle res,ctx)

			:handler (err)-> if err? then sync do
				:handler-fiber -> Router.handle res,ctx,err
				handler

	remove: (spec)->
		@routers = reject (.routes spec), @routers

	->
		@routers = []
		@factory = new RouterFactory this

		import map @factory~make-router, {\ANY \GET \POST \PUT \DELETE \OPTIONS \TRACE \CONNECT \HEAD}

module.exports = new Livewire import {
	Matcher
	Response
	HandlerContext
	Router
	async: (.async!)
	Context: Livewire
	magic:
		sync: (fun)->(...args)->fun.sync null,...args
		async: (.async!)
}