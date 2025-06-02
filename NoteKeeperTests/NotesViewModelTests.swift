import XCTest
@testable import NoteKeeper
final class NotesViewModelTests: XCTestCase {
    var viewModel: NotesViewModel!

    override func setUp() async throws {
        try await super.setUp()
        viewModel = NotesViewModel()
        await viewModel.fetchNotes()
    }

    override func tearDown() async throws {
        viewModel = nil
        try await super.tearDown()
    }

    func testAddNoteIncreasesCount() async throws {
        let initialCount = viewModel.notes.count
        await viewModel.addNote(title: "Тест атауы", content: "Тест мазмұны")
        let newCount = viewModel.notes.count
        XCTAssertGreaterThan(newCount, initialCount, "Жазба қосылған соң, сан артуы тиіс")
    }

    func testDeleteNoteRemovesIt() async throws {
        await viewModel.addNote(title: "Өшіру тесті", content: "Өшіру мазмұны")
        guard let noteToDelete = viewModel.notes.first else {
            XCTFail("Жазба табылмады")
            return
        }
        await viewModel.deleteNote(noteToDelete)
        let stillExists = viewModel.notes.contains(where: { $0.id == noteToDelete.id })
        XCTAssertFalse(stillExists, "Жазба өшірілген соң, қайта болмауы керек")
    }

    func testUpdateNoteChangesContent() async throws {
        await viewModel.addNote(title: "Ескі тақырып", content: "Ескі мазмұн")
        guard var note = viewModel.notes.first else {
            XCTFail("Жазба табылмады")
            return
        }

        let newTitle = "Жаңа тақырып"
        let newContent = "Жаңа мазмұн"
        await viewModel.updateNote(note: note, newTitle: newTitle, newContent: newContent)

        await viewModel.fetchNotes()
        note = viewModel.notes.first(where: { $0.id == note.id }) ?? note

        XCTAssertEqual(note.title, newTitle, "Тақырып жаңартылуы керек")
        XCTAssertEqual(note.content, newContent, "Мазмұн жаңартылуы керек")
    }
}
