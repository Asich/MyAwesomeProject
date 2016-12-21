import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import MongoDB

//// Create HTTP server.
//let server = HTTPServer()
//
//// Register your own routes and handlers
//var routes = Routes()
//
//routes.add(method: .get, uri: "/", handler: { request, response in
//    
//    response.setHeader(.contentType, value: "text/html")
//    response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, bro!</body></html>")
//    response.completed()
//    
//}
//)
//
//routes.add(method: .post, uri: "/print", handler: { request, response in
//    print(request.postParams)
//    
//})
//
//// Add the routes to the server.
//server.addRoutes(routes)
//
//// Set a listen port of 8181
//server.serverPort = 8181
//
//do {
//    // Launch the HTTP server.
//    try server.start()
//} catch PerfectError.networkError(let err, let msg) {
//    print("Network error thrown: \(err) \(msg)")
//}


// open a connection
let client = try! MongoClient(uri: "mongodb://localhost")

// set database, assuming "test" exists
let db = client.getDatabase(name: "test")

// define collection
let collection = db.getCollection(name: "myCollection")
// Here we clean up our connection,
// by backing out in reverse order created


let ins = try! BSON.init(json: "{\"name\" : \"Murich\"}")

let rst : MongoResult = (collection?.insert(document: ins))!

//if case .success = rst {
//    print("success writing to mdb base")
//}

switch rst {
    case .success: print ("success writing to mdb base")
    case .error(let domain, let code, let message): print("Error writing to base: \(message)")
    default: break
}

// Perform a "find" on the perviously defined collection
let fnd = collection?.find(query: BSON())

// Initialize empty array to receive formatted results
var arr = [String]()

// The "fnd" cursor is typed as MongoCursor, which is iterable
for x in fnd! {
    arr.append(x.asString)
}

// return a formatted JSON array.
let returning = "{\"data\":[\(arr.joined(separator: ","))]}"

print(returning)


collection?.close()
db.close()
client.close()
