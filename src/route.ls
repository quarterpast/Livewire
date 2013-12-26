{Some, None} = require \fantasy-options

# alt :: (a → Option b) → (a → Option b) → a → Option b
alt = (f, g, a)-->
	f a .fold id, (-> g a)

# compact :: [a → Option b] → a → Option B
compact = (.reduce alt, None)

# route :: (Option Promise Response → Promise Response) → [Request → Option Promise Response] → Request → Promise Response
export route = (fallback, rs)-->
	fallback compact rs
