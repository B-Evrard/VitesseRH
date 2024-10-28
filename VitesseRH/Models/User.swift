struct User : Decodable {
    var email: String
    var password: String
    var infoUser: InfoUser?
}

struct InfoUser : Decodable {
    var token: String?
    var isAdmin: Bool
}