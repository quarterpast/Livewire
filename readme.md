#Livewire
is a routing library for [Node.js](https://github.com/joyent/node) written in [LiveScript](https://github.com/gkz/LiveScript). It ships with a bare minimum configuration, and hooks to extend it how you will.

##Installation

```bash
npm install livewire
```

##Usage

```coffeescript
let @ = require \livewire
	@GET "/" ->"hello world"

	require \http .create-server @app .listen 8000
```

```bash
$ curl http://localhost:8000
hello world
```

##Extending

```coffeescript
class AwesomeRouter extends livewire.Router
	@supports (instanceof Awesome)
	match:   -> it is @awesome
	extract: -> super @awesome

	(method,@awesome,handler)->
		super method
		@handlers = [] ++ handler
```

##Licence
[MIT.](https://github.com/quarterto/Livewire/blob/master/licence.md)

&copy;2012-2013 Matt Brennan