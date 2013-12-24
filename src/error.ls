id = -> it

# handle-error :: (Error → Response) → (a → Response) → EitherT Promise Error Response → Promise Response
export handle-error = (f, g, e)-->
	e.fold f, g

# simple-result :: EitherT Promise Error Response → Promise Response
export simple-result = handle-error do
	(err)-> Result.error e.stack
	(res)-> Result.ok res
