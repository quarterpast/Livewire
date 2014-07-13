# Livewire [![Build Status](https://travis-ci.org/quarterto/Livewire.png?branch=develop)](https://travis-ci.org/quarterto/Livewire)

Streaming HTTP routing for Node.js. Best served with [Oban](https://github.com/quarterto/Oban) and a dash of water. Built on [Highland](https://github.com/quarterto/Highland).

```bash
npm install livewire
```

## Example

```livescript
{route, get, post, ok, not-found, body-params, redirect} = require \livewire
User = require \theoretical-user-model
templates = require \theoretical-templater

route [
  get '/' -> ok "hello"
  get '/user/:id' (req)-> User.get req.params.id .chain templates.user
  post '/user/:id' (req)->
    params <- body-params JSON.parse, req .chain
    model <- User.get req.params.id .chain
    <- model.update params .save! .chain
    redirect '/user/#id'
]
```

`route` returns a function that takes a request and returns a result Stream. Funnily enough, that's exactly the kind of function you serve with [Oban](https://github.com/quarterto/Oban). Have a look at [Peat](https://github.com/quarterto/Peat) and [Dram](https://github.com/quarterto/Dram) if you need fancy responses.

## Documentation
### Routing
#### `route : ∀a,b. [a → Stream b] → a → Stream b
Calls the functions in turn and returns the first nonempty stream. Given our handlers return empty streams for non-matching routes, this is sufficient to call the first matching route handler.

### Handlers
#### `respond : ∀a. Method → Path → (Request → Stream a) → Request → Stream a`
Takes a string method and path, a handler, and a request, and gives back a stream for a response. If the method or the path don't match, the stream is empty, and you can switch to an alternate stream with `.otherwise`

#### `get`, `post` [*et al*](/src/route.ls#L16)
Are just `respond` partially applied with the method.

### Request body
Body handlers buffer up the request body, parse it with something, and stream the result. There are 3 parsers: `raw`, `json` and `query`, which do what you expect, or you can call `body-params` with a parser of your own (which takes a string body and returns whatever).

### Paths
A simple string path matches exactly. If the last character is `/`, it matches a path prefix, unless the path is `/` exactly. Paths can contain parameters, which are of the form `:ident`. This match any non-`/` string, and extract the value into `req.params` under the key given by the identifier.

## Licence
[MIT.](https://github.com/quarterto/Livewire/blob/master/licence.md)

&copy;2012-2014 Matt Brennan
