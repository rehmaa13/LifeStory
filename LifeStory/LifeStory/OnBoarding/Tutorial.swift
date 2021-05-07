
import SwiftUI

struct Tutorial: View {
  
    //Properties
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var addstory: Bool = false
    @State var showCreateTicket = false
    @ObservedObject var control = TicketCardView_Control()
    
    var body: some View {
                
                ZStack {
                    
                        
                        HomeView(showCreateTicket: $showCreateTicket)
                            .navigationBarHidden(true)
                            .environmentObject(self.control)
                            .navigationBarTitle("Tickets")
                    
                    .statusBar(hidden: self.control.anyTicketTriggered)
                }
               
                
            
        }
}


struct Tutorial_Previews: PreviewProvider {
    static var previews: some View {
        Tutorial()
    }
}

let screen = UIScreen.main.bounds

