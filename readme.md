#Ultra-light LiveScript routing library
Exports an ```http.Server```.

Sugar for HTTP methods ```get: String → (Response → String → String)```.

All matching routes are called with context as Request, with the last argument the return value of the last. The final return value is spit out at the server.