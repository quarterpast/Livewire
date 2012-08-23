require "./livewire"
	..get "/" ->"hello world"
	..get "/:name" ->"hello #{@params.name}"
	..listen 8000