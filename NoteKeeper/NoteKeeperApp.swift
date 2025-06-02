import SwiftUI
import FirebaseCore

@main
struct NoteKeeperApp: App {
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            NotesListView() 
        }
    }
}
