require! \require-folder

export class Matcher
	@subclasses = []
	@extended = @subclasses~push

	@create = (spec)->
		if spec? and find (.supports spec), @subclasses
			that spec
		else throw new TypeError "No matchers can handle #{spec}."

	~>
		throw new TypeError "#{@constructor.display-name} is abstract and can't be instantiated."
	match:  ->
		throw new TypeError "#{@constructor.display-name} does not implement match"
	extract: ->
		throw new TypeError "#{@constructor.display-name} does not implement extract"

require-folder "./matchers"