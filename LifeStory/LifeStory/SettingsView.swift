

import SwiftUI
import UserNotifications

struct SettingsView: View {
    
    
    var body: some View {
    
        NavigationView{
            Form{
                Section{
                    HStack{
                        Image(systemName: "star")
                        Text("Top Features").padding()
                    }.frame(height: 40)
                    HStack{
                        Image(systemName: "desktopcomputer")
                        Text("More Health News").padding()
                    }.frame(height: 40)
                }
                
                Section{
                    HStack{
                        Image(systemName: "app.gift")
                        Text("Change App Icon").padding()
                    }.frame(height: 40)

                    HStack{
                        Image(systemName: "info.circle")
                        Text("Help").padding()
                    }.frame(height: 40)
                   
                }
                
                Section{
                
                    HStack{
                        Image(systemName: "suit.heart")
                        Text("Give us A Review").padding()
                    }.frame(height: 40)
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing:
                                           Button(action: {
                                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                                if success {
                                                    print("All set!")
                                                } else if let error = error {
                                                    print(error.localizedDescription)
                                                }
                                            }
                                           }, label: {
                                               Image(systemName: "bell").font(.headline)
                                            
                                           })
        )
        }
    }
}

func notifyme() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("All set!")
        } else if let error = error {
            print(error.localizedDescription)
        }
    }
}


struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
