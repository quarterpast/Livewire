Result = require './result'
{Left, Right} = require \fantasy-eithers

# handle-error :: (Error → Response) → (a → Response) → EitherT Promise Error Response → Promise Response
exports.handle-error = (f, g, e)-->
	e.fold f, g

# dev-result :: EitherT Promise Error Response → Promise Response
exports.dev-result = exports.handle-error do
	(err)-> Result.error err.stack .extract!
	(res)-> Result.ok res .extract!

exports.handle-exception = (f)-> ->
	try Right f ...
	catch e => Left e

# ignore curry in coverage
/* istanbul ignore next */