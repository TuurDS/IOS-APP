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
    
    @EnvironmentObject var model: ExpenseCalculatorModel
    @ObservedObject var registerModel = ExpenseCalculatorModel.shared.registerModel
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

                    Button(action: model.navigateBack) {
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
                            text: $registerModel.login,
                            placeholder: "Username",
                            isSecure: false,
                            focusedField: $registerModel.focusedField ,
                            id: "1")
                        .frame(maxWidth: 300)
                        HighlightableTextField(
                            text: $registerModel.password,
                            placeholder: "Password",
                            isSecure: true,
                            focusedField: $registerModel.focusedField,
                            id: "2")
                        .frame(maxWidth: 300)
                        HighlightableTextField(
                            text: $registerModel.passwordConfirm,
                            placeholder: "Confirm Password",
                            isSecure: true,
                            focusedField: $registerModel.focusedField,
                            id: "3")
                        .frame(maxWidth:300)
                    }
                    .padding(.horizontal, 16)
                    
                    Text(registerModel.errorText)
                        .font(.callout)
                        .foregroundColor(.red)
                        .padding(.bottom, 16)
                        .opacity(registerModel.errorText.isEmpty ? 0 : 1)
                    
                    Button(action: registerModel.Register) {
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
                    text: $registerModel.login,
                    placeholder: "Username",
                    isSecure: false,
                    focusedField: $registerModel.focusedField ,
                    id: "1")
                    .frame(maxWidth: 400)
                HighlightableTextField(
                    text: $registerModel.password,
                    placeholder: "Password",
                    isSecure: true,
                    focusedField: $registerModel.focusedField,
                    id: "2")
                    .frame(maxWidth: 400)
                HighlightableTextField(
                    text: $registerModel.passwordConfirm,
                    placeholder: "Confirm Password",
                    isSecure: true,
                    focusedField: $registerModel.focusedField,
                    id: "3")
                    .frame(maxWidth: 400)
            }
            .padding(.horizontal, 16)

            Text(registerModel.errorText)
                .font(.callout)
                .foregroundColor(.red)
                .padding(.bottom, 16)
                .opacity(registerModel.errorText.isEmpty ? 0 : 1)

            Button(action: registerModel.Register) {
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
                Button(action: model.navigateBack) {
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
}


struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register().environmentObject(ExpenseCalculatorModel.shared)
    }
}
