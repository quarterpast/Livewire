id = -> it

# handle-error :: (Error → Response) → EitherT Promise Error Response → Promise Response
export handle-error = (f, e)-->
	e.fold f, id