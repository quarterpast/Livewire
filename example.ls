require "./livewire"
	..get "/" ->"hello world"
	..get "/:name" [
		->"hello #{@params.name}"
		->"hello #{&1}"
	]
	..listen 8000, ->console.log \listening