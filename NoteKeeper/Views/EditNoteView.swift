import SwiftUI

struct EditNoteView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: NotesViewModel

    var note: Note

    @State private var title: String
    @State private var content: String

    init(viewModel: NotesViewModel, note: Note) {
        self.viewModel = viewModel
        self.note = note
        _title = State(initialValue: note.title)
        _content = State(initialValue: note.content)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Тақырып")) {
                    TextField("Мысалы: Сабақ конспекті", text: $title)
                }

                Section(header: Text("Мазмұны")) {
                    TextEditor(text: $content)
                        .frame(height: 150)
                }

                Section {
                    Button("Жаңарту") {
                        Task {
                            await viewModel.updateNote(note: note, newTitle: title, newContent: content)
                            dismiss()
                        }
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
            .navigationTitle("Жазбаны өңдеу")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Болдырмау") {
                        dismiss()
                    }
                }
            }
        }
    }
}
