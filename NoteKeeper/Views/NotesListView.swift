import SwiftUI

struct NotesListView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var showAddNote = false
    @State private var selectedNote: Note? = nil

    var body: some View {
        NavigationStack {
            List {
                // 🌟 Дәйексөз блогы + Жаңарту батырмасы
                if let quote = viewModel.quote {
                    Section {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(quote)
                                .font(.callout)
                                .foregroundColor(.blue)

                            Button("🔁 Жаңарту") {
                                Task {
                                    await viewModel.loadQuote()
                                }
                            }
                            .font(.caption)
                            .foregroundColor(.gray)
                        }
                        .padding(.vertical, 6)
                    }
                }

                // 📋 Жазбалар тізімі
                if viewModel.notes.isEmpty {
                    Text("Жазбалар жоқ")
                        .foregroundColor(.gray)
                } else {
                    ForEach(viewModel.notes) { note in
                        NavigationLink(destination: EditNoteView(viewModel: viewModel, note: note)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(note.title)
                                    .font(.headline)
                                Text(note.content)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(note.createdAt.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete { indexSet in
                        Task {
                            for index in indexSet {
                                let note = viewModel.notes[index]
                                await viewModel.deleteNote(note)
                            }
                        }
                    }
                }
            }
            .navigationTitle("📒 Жазбалар")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddNote = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddNote) {
                AddNoteView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchNotes()
                await viewModel.loadQuote()
            }
        }
    }
}
