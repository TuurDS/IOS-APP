//
//  Register.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 01/01/2022.
//

import SwiftUI

struct Register: View {
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.height > geometry.size.width {
                portrait
            } else {
                landscape
            }
        }
    }
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorText: String = ""
    @State var focusedField: String = "-1"
    
    let sidebarSize: CGFloat = 0.4
    
    var landscape: some View {
        
        GeometryReader { geometry in
            HStack(spacing:0) {
                //MARK left
                VStack(alignment: .center, spacing: 20) {
                    Text("Register")
                        .font(.largeTitle)
                        .fontWeight(Font.Weight.bold)

                    Text("already have an account?")
                        .font(.callout)
                        .fontWeight(Font.Weight.bold)

                    Button(action: navigateToLogin) {
                        Text("Log In")
                            .fontWeight(Font.Weight.bold)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 32)
                            .background(Color.white)
                    }
                    .cornerRadius(10)
                    .foregroundColor(Color("basecolor"))
                }
                .padding(/*@START_MENU_TOKEN@*/.horizontal, 30.0/*@END_MENU_TOKEN@*/)
                .ignoresSafeArea()
                .frame(width: geometry.size.width * sidebarSize,height: geometry.size.height)
                .background(Color("basecolor"))
                .foregroundColor(.white)
                
                //MARK right
                VStack(alignment: .center) {
                    Spacer()
                    
                    Text("Register")
                        .font(.largeTitle)
                        .padding([.top, .bottom], 16)
                    
                    VStack(alignment: .center) {
                        HighlightableTextField(
                            text: $username,
                            placeholder: "Username",
                            isSecure: false,
                            focusedField: $focusedField ,
                            id: "1")
                        .frame(maxWidth: 300)
                        HighlightableTextField(
                            text: $password,
                            placeholder: "Password",
                            isSecure: true,
                            focusedField: $focusedField,
                            id: "2")
                        .frame(maxWidth: 300)
                        HighlightableTextField(
                            text: $confirmPassword,
                            placeholder: "Confirm Password",
                            isSecure: true,
                            focusedField: $focusedField,
                            id: "3")
                        .frame(maxWidth:300)
                    }
                    .padding(.horizontal, 16)
                    
                    Text(errorText)
                        .font(.callout)
                        .foregroundColor(.red)
                        .padding(.bottom, 16)
                        .opacity(errorText.isEmpty ? 0 : 1)
                    
                    Button(action: register) {
                        Text("Register")
                            .padding(.vertical, 16)
                            .padding(.horizontal, 32)
                            .background(Color("accentcolor"))
                    }
                    .cornerRadius(10)
                    .foregroundColor(Color.white)
                    
                    
                    Spacer()
                }
                .frame(width: geometry.size.width * (1-sidebarSize),height: geometry.size.height)
                .ignoresSafeArea()
            }
        }
    }
    
    var portrait: some View {
        VStack(alignment: .center) {
            
            Spacer()
            
            Text("Register")
                .font(.largeTitle)
                .padding([.top, .bottom], 16)

            VStack(alignment: .center) {
                HighlightableTextField(
                    text: $username,
                    placeholder: "Username",
                    isSecure: false,
                    focusedField: $focusedField ,
                    id: "1")
                    .frame(maxWidth: 400)
                HighlightableTextField(
                    text: $password,
                    placeholder: "Password",
                    isSecure: true,
                    focusedField: $focusedField,
                    id: "2")
                    .frame(maxWidth: 400)
                HighlightableTextField(
                    text: $confirmPassword,
                    placeholder: "Confirm Password",
                    isSecure: true,
                    focusedField: $focusedField,
                    id: "3")
                    .frame(maxWidth: 400)
            }
            .padding(.horizontal, 16)

            Text(errorText)
                .font(.callout)
                .foregroundColor(.red)
                .padding(.bottom, 16)
                .opacity(errorText.isEmpty ? 0 : 1)

            Button(action: register) {
                Text("Register")
                    .padding(.vertical, 16)
                    .padding(.horizontal, 32)
                    .background(Color("accentcolor"))
            }
            .cornerRadius(10)
            .foregroundColor(Color.white)


            Spacer()

            HStack {
                Text("Already have an account?")
                Button(action: navigateToLogin) {
                    Text("Log In")
                        .underline(true)
                        .font(.callout)
                        .foregroundColor(Color("accentcolor"))
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.top, 32)
            .padding(.horizontal, 16)
            .background(Color.init(hex: "EFEBF2"))
        }
    }
    
    
    
    private func register() {
        // Perform register here
        errorText = "Invalid login details"
    }

    private func navigateToLogin() {
        // Navigate to login screen here
    }
}


struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
