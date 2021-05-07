
import SwiftUI
import AuthenticationServices


struct AppleUser: Codable {
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    
    init?(credentials: ASAuthorizationAppleIDCredential) {
        guard
            let firstName = credentials.fullName?.givenName,
            let lastName = credentials.fullName?.familyName,
            let email = credentials.email
        else { return nil }
        
        self.userId = credentials.user
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}

struct QuickStartView: View {
    @Environment(\.colorScheme) var colorScheme
   
    
    var body: some View {
        NavigationView {
        ZStack {
            colorScheme == .light ? Color(UIColor.secondarySystemBackground) : Color(UIColor.systemBackground)
            
            VStack(spacing: 0) {
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {
                            Text("👋")
                                .font(.system(size: 94, weight: .semibold))
                                .frame(width: 225, height: 222)
                               
                                .cornerRadius(8)
                                .offset(x: 0, y: 0)
                            
                            VStack(spacing: 10) {
                           
                               
                            }
                         
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .frame(height: 380)
                .clipShape(Rectangle())
                
                VStack(spacing: 16) {
                    Spacer()
                    Text("Let's Begin")
                        .font(.system(size: 32, weight: .bold))
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Spacer()
                        Text("LifePath brings you closer to your life goals by inspiring you to become the best version of yourself and make memories whilst doing so. Your journey starts now.")
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.callout)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    
                    Spacer()
                    
            
                    SignInWithAppleButton(
                        .signIn,
                        onRequest: configure,
                        onCompletion: handle
                    )
                    .signInWithAppleButtonStyle(
                        colorScheme == .dark ? .white : .black
                    )
                    .frame(height: 45)
                    .padding()
                
                    
                    Spacer()
                }
                
                .padding()
                .background(colorScheme == .light ? Color.white : Color(UIColor.secondarySystemBackground))
            }
                
        }
        .edgesIgnoringSafeArea(.all)
        }
        
        
    }
}
func configure(_ request: ASAuthorizationAppleIDRequest) {
    request.requestedScopes = [.fullName, .email]
}

func handle(_ authResult: Result<ASAuthorization, Error>) {
   
    switch authResult {
    case .success(let auth):
        print(auth)
    
        switch auth.credential {
        case let appleIdCredentials as ASAuthorizationAppleIDCredential:
            if let appleUser = AppleUser(credentials: appleIdCredentials),
               let appleUserData = try? JSONEncoder().encode(appleUser) {
                UserDefaults.standard.setValue(appleUserData, forKey: appleUser.userId)
                
                print("saved apple user", appleUser)
            } else {
                print("missing some fields", appleIdCredentials.email, appleIdCredentials.fullName, appleIdCredentials.user)
                
                guard
                    let appleUserData = UserDefaults.standard.data(forKey: appleIdCredentials.user),
                    let appleUser = try? JSONDecoder().decode(AppleUser.self, from: appleUserData)
                else { return }
                
                print(appleUser)
            }
            
        default:
            print(auth.credential)
        }
        
    case .failure(let error):
        print(error)
    }
}

struct QuickStartView_Previews: PreviewProvider {
    static var previews: some View {
        QuickStartView()
    }
}
