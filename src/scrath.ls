# type Router = Request → Option Responder
# type Responder = Request → Promise Response

# type Response = { body :: Readable Buffer
#                 , status-code :: Int
#                 , status :: String
#                 , headers :: Map String String }


# Option Request → Option (Request → Promise Response) → Option Promise Response  # looks an awful lot like <**>

# alt :: (a → Option b) → (a → Option b) → a → Option b
alt = (f, g)->
	(a)-> f a .fold id, (-> g a)

module.exports = listen 8000 serve handler

# type Router = Request → Option (Request → Promise Response)
# serve :: (Request → Promise Response) → Server

# getOrElse :: Option (Request → Promise Response) -> (Request → Promise Response) -> (Request → Promise Response)
