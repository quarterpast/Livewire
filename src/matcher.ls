require! {
	"./oop".abstract
	\require-folder
}

export class Matcher implements abstract {\match \extract \constructor}
	@subclasses = []
	@extended = @subclasses~push

	@create = (spec)->
		if spec? and find (.supports spec), @subclasses
			that spec
		else throw new TypeError "No matchers can handle #{spec}."

	~> @constructor ...

require-folder "./matchers"