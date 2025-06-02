// Note.swift
import Foundation
import FirebaseFirestore

struct Note: Identifiable {
    var id: String
    var title: String
    var content: String
    var createdAt: Date

    init(id: String = UUID().uuidString,
         title: String,
         content: String,
         createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
    }

    func toDict() -> [String: Any] {
        return [
            "title": title,
            "content": content,
            "createdAt": Timestamp(date: createdAt)
        ]
    }

    static func from(_ doc: DocumentSnapshot) -> Note? {
        let data = doc.data()
        guard let title = data?["title"] as? String,
              let content = data?["content"] as? String,
              let createdAt = (data?["createdAt"] as? Timestamp)?.dateValue()
        else { return nil }

        return Note(id: doc.documentID, title: title, content: content, createdAt: createdAt)
    }
}
