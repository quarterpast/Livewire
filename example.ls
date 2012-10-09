with require "./livewire.ls"
	@GET "/" ->"hello world"
	@GET "/:name" [
		->"hello #{@params.name}"
		->"hello #{&1}"
	]
	@GET /^\/test\/(\w+)/, ->"test #{@params.0}"
	@GET (->if it.split '/' .1 is 'other' then "hello"), ->"other #{@params}"
	@listen 8000, ->console.log \listening