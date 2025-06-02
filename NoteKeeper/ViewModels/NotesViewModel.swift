import Foundation
import FirebaseFirestore

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var quote: String? = nil
    
    private let db = Firestore.firestore()

    init() {
        Task {
            await fetchNotes()
            await loadQuote()
        }
    }

    //  Жазбаларды жүктеу
    func fetchNotes() async {
        do {
            let snapshot = try await db.collection("notes")
                .order(by: "createdAt", descending: true)
                .getDocuments()
            let notes = snapshot.documents.compactMap { Note.from($0) }
            await MainActor.run {
                self.notes = notes
            }
        } catch {
            print("⚠️ fetchNotes қатесі: \(error.localizedDescription)")
        }
    }

    //  Жаңа жазба қосу
    func addNote(title: String, content: String) async {
        let note = Note(title: title, content: content)
        do {
            try await db.collection("notes").document(note.id).setData(note.toDict())
            await fetchNotes()
        } catch {
            print("⚠️ addNote қатесі: \(error.localizedDescription)")
        }
    }

    //  Жазбаны жаңарту
    func updateNote(note: Note, newTitle: String, newContent: String) async {
        let updatedData: [String: Any] = [
            "title": newTitle,
            "content": newContent,
            "createdAt": Timestamp(date: note.createdAt)
        ]
        
        do {
            try await db.collection("notes").document(note.id).setData(updatedData)
            await fetchNotes()
        } catch {
            print("⚠️ updateNote қатесі: \(error.localizedDescription)")
        }
    }

    //  Жазбаны өшіру
    func deleteNote(_ note: Note) async {
        do {
            try await db.collection("notes").document(note.id).delete()
            await fetchNotes()
        } catch {
            print("⚠️ deleteNote қатесі: \(error.localizedDescription)")
        }
    }

    //  Дәйексөз (quote) жүктеу
    func loadQuote() async {
        do {
            let result = try await QuoteService.fetchQuote()
            await MainActor.run {
                self.quote = result
            }
        } catch {
            print("⚠️ quote қатесі: \(error.localizedDescription)")
        }
    }
}
