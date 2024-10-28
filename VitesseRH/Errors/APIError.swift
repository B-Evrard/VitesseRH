enum APIError: Error {
    case invalidResponse(message: String = "Une erreur est survenue.")
    case invalidData(message: String = "Une erreur est survenue.")
    case invalidURL(message: String = "Une erreur est survenue.")
    case authenticationFailed(message: String = "Authentification invalide.")
    case unauthorized(message: String = "Une erreur est survenue.")
    case genericError(message: String = "Une erreur est survenue.")
    
    var message: String {
        switch self {
        case .invalidResponse(let message),
                .invalidData(let message),
                .invalidURL(let message),
                .authenticationFailed(let message),
                .unauthorized(let message),
                .genericError(let message):
            return message
        }
    }
}