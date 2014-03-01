async = require \fantasy-async
get-body = async require \raw-body
{EitherT, Left} = require \fantasy-eithers
Promise = require \fantasy-promises

EitherPromise = EitherT Promise

# body-params :: (String → Params) → Request → EitherT Promise Error Params
exports.body-params = (parser, req)-->
	get-body req, {
		length: req.headers.'content-length'
		encoding: \utf8
		limit: \1mb
	} .chain (body)->
		try
			EitherPromise.of parser body
		catch err
			EitherPromise new Promise (<| Left err)