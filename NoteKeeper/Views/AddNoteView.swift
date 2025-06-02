import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: NotesViewModel

    @State private var title: String = ""
    @State private var content: String = ""

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
                    Button("Сақтау") {
                        Task {
                            await viewModel.addNote(title: title, content: content)
                            dismiss()
                        }
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
            .navigationTitle("Жаңа жазба")
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
