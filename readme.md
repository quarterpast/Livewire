#Livewire
Purely functional HTTP routing for Node.js.

[![Build Status](https://travis-ci.org/quarterto/Livewire.png?branch=develop)](https://travis-ci.org/quarterto/Livewire)

##Installation

```bash
npm install livewire
```

##Usage

```livescript
{route, get, post, ok, not-found, body-params, redirect} = require \livewire
User = require \theoretical-user-model
templates = require \theoretical-templater

route do
  -> "404 #{it.path}"
  [
    get '/' -> ok "hello"
    get '/user/:id' - > User.get it.params.id .chain templates.user
    post '/user/:id' (req)->
      params <- body-params JSON.parse, req .chain
      model <- User.get req.params.id .chain
      <- model.update params .save! .chain
      redirect '/user/#id'
  ]
```

##API
### Handlers

#### `respond : Method → Path → (Request → Promise Response) → Request → Option Promise Response`

Takes a string method and path, a handler, and a request, and maybe gives back a promise for a response. The `Option` is `Some` if the method and path match and `None` if they don't.

#### `get`, `post` *et al*
Are just `respond` partially applied with the method.

###TODO doc more



##Licence
[MIT.](https://github.com/quarterto/Livewire/blob/master/licence.md)

&copy;2012-2014 Matt Brennan
