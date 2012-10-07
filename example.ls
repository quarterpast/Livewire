with require "./livewire"
	@GET "/" ->"hello world"
	@GET "/:name" [
		->"hello #{@params.name}"
		->"hello #{&1}"
	]
	@listen 8000, ->console.log \listening