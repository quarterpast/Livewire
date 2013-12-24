id = -> it

# handle-error :: (Error → Response) → (a → Response) → EitherT Promise Error Response → Promise Response
export handle-error = (f, g, e)-->
	e.fold f, g

# dev-result :: EitherT Promise Error Response → Promise Response
export dev-result = handle-error do
	(err)-> Result.error e.stack
	(res)-> Result.ok res
