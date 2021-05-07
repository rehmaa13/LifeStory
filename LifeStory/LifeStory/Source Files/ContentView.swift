
import SwiftUI

struct ContentView: View {
    
    @State var QuickStartView: Bool = false
    @State var selection: Int = 0
    
    var body: some View {
        if !QuickStartView {
        NavigationView {
            VStack {
                Spacer()
                Text("LifePath")
                    .font(.system(size: 48, weight: .semibold))
                    .padding(.bottom)
                Spacer()
                
                
                // This button to redirect to QUICKSTARTVIEW
                Button(action: { QuickStartView = true })  {
                    Text("Get Started")
                        .font(.headline)
                        
                }
            }}
            .padding()
            
        }
            else {
                // TabView here
                TabView(selection: $selection) {
                    Tutorial()
                        .tag(0)
                    
                    StoryList()
                        .tag(1)
                    
                    VaultView()
                        .tag(2)
                    
                    TalkView(audioRecorder: AudioRecorder())
                        .tag(3)
                    
                }
                .overlay( // Overlay the custom TabView component here
                    Color.white // Base color for Tab Bar
                        .edgesIgnoringSafeArea(.vertical)
                        .frame(height: 50) // Match Height of native bar
                        .overlay(HStack {
                            Spacer()
                            
                            // First Tab Button
                            Button(action: {
                                self.selection = 0
                            }, label: {
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                    .opacity(selection == 0 ? 1 : 0.4)
                            })
                            Spacer()
                            
                            // Second Tab Button
                            Button(action: {
                                self.selection = 1
                            }, label: {
                                Image(systemName: "quote.bubble.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                    .opacity(selection == 1 ? 1 : 0.4)
                            })
                            
                            Spacer()
                            
                            Button(action: {
                                self.selection = 2
                              
                            }, label: {
                                Image(systemName: "photo.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                    .opacity(selection == 2 ? 1 : 0.4)
                            })
                            
                            Spacer()
                            
                            Button(action: {
                                self.selection = 3
                              
                            }, label: {
                                Image(systemName: "badge.plus.radiowaves.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                    .opacity(selection == 3 ? 1 : 0.4)
                            })
                            
                            Spacer()
                            
                        })
                ,alignment: .bottom) // Align the overlay to bottom to ensure tab bar stays pinned.
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
