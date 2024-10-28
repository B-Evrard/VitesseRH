struct RegisterUser : Decodable {
    var email: String
    var password: String
    var firstName: String
    var lastName: String
}

struct Candidate : Decodable {
    var id: String?
    var isFavorite: Bool
    var email: String
    var note: String?
    var linkedinURL: String?
    var firstName: String
    var lastName: String
    var phone: String
}