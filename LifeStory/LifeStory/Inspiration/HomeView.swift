

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var control: TicketCardView_Control
    @Binding var showCreateTicket: Bool

    var tickets = cardData
    
    var body: some View {
     
     
        
        
        ZStack {
            ScrollView(.vertical) {
                
                ScrollViewTitleView(showCreateTicket: $showCreateTicket)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    .blur(radius: control.anyTicketTriggered ? 20 : 0)
                
                ForEach(self.tickets) { ticket in
                    ExpandableCardView(ticket: ticket)
                            .environmentObject(self.control)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                }
                
            }
            
            VStack {
                SystemMaterialView(style: .regular)
                    .frame(height: self.control.anyTicketTriggered ? 0 : 40)
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
        }
    
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            HomeView(showCreateTicket: .constant(false))
                .environmentObject(TicketCardView_Control())
                .environment(\.colorScheme, .light)
         
        }
        
    }
    
}

struct ScrollViewTitleView: View {
    @Binding var showCreateTicket: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(Date(), style: .date)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.bottom, -5)
                .foregroundColor(Color(.secondaryLabel))
            
            HStack(alignment: .center) {
                Text("Inspiration")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.label))
                Spacer()
                
             
                
            }
            
        }
        .padding(.bottom, -5)
        
    }
    
}




struct Ticket : Identifiable {
    var id = UUID()
    
    var subtitle: String
    var title: String
    var briefSummary: String
    var description: String
    var image: String
}

let desPlaceholer = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Enim eu turpis egestas pretium aenean pharetra magna ac. Quis enim lobortis scelerisque fermentum. Phasellus faucibus scelerisque eleifend donec pretium. Nec ullamcorper sit amet risus nullam eget. Convallis convallis tellus id interdum velit."

let Elon = "Elon Reeve Musk FRS is a business magnate, industrial designer, and engineer. He is the founder, CEO, CTO, and chief designer of SpaceX; early investor, CEO, and product architect of Tesla, Inc.; founder of The Boring Company; co-founder of Neuralink; and co-founder and initial co-chairman of OpenAI."

let steve = "Steven Paul Jobs was an American inventor, designer and entrepreneur who was the co-founder, chief executive and chairman of Apple Computer. Apple's revolutionary products, which include the iPod, iPhone and iPad, are now seen as dictating the evolution of modern technology.Born in 1955 to two University of Wisconsin graduate students who gave him up for adoption, Jobs was smart but directionless, dropping out of college and experimenting with different pursuits before co-founding Apple with Steve Wozniak in 1976. Jobs left the company in 1985, launching Pixar Animation Studios, then returned to Apple more than a decade later. Jobs died in 2011 following a long battle with pancreatic cancer."

let bill = "Entrepreneur and businessman Bill Gates and his business partner Paul Allen founded and built the world's largest software business, Microsoft, through technological innovation, keen business strategy and aggressive business tactics. In the process, Gates became one of the richest men in the world. In February 2014, Gates announced that he was stepping down as Microsoft's chairman to focus on charitable work at his foundation, the Bill and Melinda Gates Foundation."

let jeff = "Entrepreneur and e-commerce pioneer Jeff Bezos is the founder and CEO of the e-commerce company Amazon, owner of The Washington Post and founder of the space exploration company Blue Origin. His successful business ventures have made him one of the richest people in the world. Born in 1964 in New Mexico, Bezos had an early love of computers and studied computer science and electrical engineering at Princeton University. After graduation, he worked on Wall Street, and in 1990 he became the youngest senior vice president at the investment firm D.E. Shaw. Four years later, Bezos quit his lucrative job to open Amazon.com, an online bookstore that became one of the Internet's biggest success stories. In 2013, Bezos purchased The Washington Post, and in 2017 Amazon acquired Whole Foods. In February 2021, Amazon announced that Bezos will step down as CEO in the third quarter of the year."

let cardData: [Ticket] = [
    Ticket(subtitle: "Apple", title: "Steve Jobs", briefSummary: "Steve was the chairman, the chief executive officer (CEO), and a co-founder of Apple Inc.", description: steve, image: "img3"),
    
    Ticket(subtitle: "Tesla", title: "Elon Musk", briefSummary: "He is the founder, CEO, CTO, and chief designer of SpaceX...", description: Elon, image: "img2"),
  
    Ticket(subtitle: "Microsoft", title: "Bill Gates", briefSummary: "Bill Gates founded the world's largest software business, Microsoft.", description: bill, image: "img4"),
    Ticket(subtitle: "Amazon", title: "Jeff Bezos", briefSummary: "Jeff Bezos is the founder and chief executive officer of Amazon.com", description: jeff, image: "img1"),
]
