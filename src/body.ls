async = require \fantasy-async
get-body = async require \raw-body

# body-params :: (String → Params) → Request → EitherT Promise Error Params
export body-params = (parser, req)-->
	get-body req, {
		length: req.headers.'content-length'
		encoding: \utf8
		limit: \1mb
	} .map parser