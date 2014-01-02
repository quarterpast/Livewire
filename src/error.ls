Result = require './result'
{Left, Right} = require \fantasy-eithers

# handle-error :: (Error → Response) → (a → Response) → EitherT Promise Error Response → Promise Response
export handle-error = (f, g, e)-->
	e.fold f, g

# dev-result :: EitherT Promise Error Response → Promise Response
export dev-result = handle-error do
	(err)-> Result.error e.stack .extract!
	(res)-> Result.ok res .extract!

export handle-exception = (f)-> ->
	try Right f ...
	catch e => Left e
