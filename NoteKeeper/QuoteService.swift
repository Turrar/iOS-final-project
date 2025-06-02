import Foundation

struct QuoteService {
    static func fetchQuote() async throws -> String {
        let url = URL(string: "https://zenquotes.io/api/random")!
        let (data, _) = try await URLSession.shared.data(from: url)

        if let decoded = try? JSONDecoder().decode([Quote].self, from: data),
           let quote = decoded.first {
            return "\"\(quote.q)\" — \(quote.a)"
        } else {
            throw URLError(.cannotParseResponse)
        }
    }
}

struct Quote: Decodable {
    let q: String  // quote text
    let a: String  // author
}
