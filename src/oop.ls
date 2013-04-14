require! 'prelude-ls'.map

export abstract = map (method)->
	-> throw new TypeError "#{@constructor.display-name} does not implement #method"