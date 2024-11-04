//
//  ContentView.swift
//  LiveMonitor
//
//  Created by ANGELM2B on 4/9/24.
//

import SwiftUI
import Combine
import UserNotifications

struct VideoLink: Identifiable, Codable {
    var id = UUID()
    var name: String
    var url: String
}

class VideoLinkStore: ObservableObject {
    @Published var links: [VideoLink] = []

    init() {
        self.links = loadLinks()
    }

    func addLink(name: String, url: String) {
        let newLink = VideoLink(name: name, url: url)
        links.append(newLink)
        saveLinks()
    }

    func removeLink(_ link: VideoLink) {
        links.removeAll { $0.id == link.id }
        saveLinks()
    }

    private func saveLinks() {
        if let data = try? JSONEncoder().encode(links) {
            UserDefaults.standard.set(data, forKey: "videoLinks")
        }
    }

    private func loadLinks() -> [VideoLink] {
        if let data = UserDefaults.standard.data(forKey: "videoLinks"),
           let savedLinks = try? JSONDecoder().decode([VideoLink].self, from: data) {
            return savedLinks
        }
        return []
    }
}

struct ContentView: View {
    @StateObject private var store = VideoLinkStore()
    @State private var newLinkName: String = ""
    @State private var newLinkURL: String = ""
    @State private var isVideoOffline = false
    @State private var selectedLink: VideoLink?
    @State private var showDeleteConfirmation = false
    @State private var linkToDelete: VideoLink?

    var body: some View {
        VStack {
            HStack {
                TextField("Nombre del enlace", text: $newLinkName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("URL del video", text: $newLinkURL)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Agregar") {
                    if !newLinkName.isEmpty && !newLinkURL.isEmpty {
                        store.addLink(name: newLinkName, url: newLinkURL)
                        newLinkName = ""
                        newLinkURL = ""
                    }
                }
                .padding()
            }

            List {
                ForEach(store.links) { link in
                    HStack {
                        Text(link.name)
                        
                        Spacer()

                        // Botón de "Verificar"
                        Button(action: {
                            selectedLink = link
                            checkIfVideoIsLive(url: link.url)
                        }) {
                            Text("Verificar")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(BorderlessButtonStyle())

                        Spacer().frame(width: 40)

                        // Botón de "Eliminar"
                        Button(action: {
                            linkToDelete = link
                            showDeleteConfirmation = true
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .padding(.vertical, 5)
                }
            }

            if let selectedLink = selectedLink {
                if isVideoOffline {
                    Text("\(selectedLink.name) no está disponible.")
                        .foregroundColor(.red)
                } else {
                    Text("\(selectedLink.name) está en vivo.")
                        .foregroundColor(.green)
                }
            }
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Eliminar enlace"),
                message: Text("¿Estás seguro de que deseas eliminar este enlace?"),
                primaryButton: .destructive(Text("Eliminar")) {
                    if let linkToDelete = linkToDelete {
                        store.removeLink(linkToDelete)
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
        }
    }

    private func checkIfVideoIsLive(url: String) {
        guard let videoURL = URL(string: url) else {
            print("URL no válida")
            return
        }

        var request = URLRequest(url: videoURL)
        request.httpMethod = "HEAD"

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error al consultar el estado del video: \(error)")
                videoDidFail()
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("El video está en vivo.")
                    DispatchQueue.main.async {
                        isVideoOffline = false
                    }
                } else {
                    print("El video no está disponible. Código de estado: \(httpResponse.statusCode)")
                    videoDidFail()
                }
            }
        }.resume()
    }

    private func videoDidFail() {
        DispatchQueue.main.async {
            isVideoOffline = true
        }
        sendNotification()
    }

    private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Video Offline"
        content.body = "El video en vivo ha dejado de funcionar."
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
