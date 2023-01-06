//
//  eventDetails.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 03/01/2023.
//

import SwiftUI

struct EventDetails: View {
    
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
    @ObservedObject var eventDetailsModel = ExpenseCalculatorModel.shared.eventDetailsModel
    let sidebarSize: CGFloat = 0.35
    
    var landscape: some View {
        GeometryReader { geometry in
            HStack {
                //MARK left
                VStack(alignment: .center) {
                    
                    HStack {
                        Text("Event")
                            .font(.title)
                            .fontWeight(.medium)
                        Spacer()
                        HStack {
                            Button(action: eventDetailsModel.saveDetails) {
                                Text("save")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("basecolor"))
                            }
                            .padding(8)
                            .background(.white)
                            .cornerRadius(5)
                            .foregroundColor(Color("basecolor"))
                        }
                    }
                    
                    //name and description
                    VStack {
                        HStack {
                            Text("Event Name")
                                .font(.headline)
                            Spacer()
                        }
                        TextField("", text: $eventDetailsModel.eventname)
                            .padding(.all,5)
                            .foregroundColor(.black)
                            .background(.white)
                            .cornerRadius(5)
                        HStack {
                            Text("Description")
                                .font(.headline)
                            Spacer()
                        }
                        .padding(.top, 10)
                        TextEditor(text: $eventDetailsModel.eventdescription)
                            .padding(.all,5)
                            .foregroundColor(.black)
                            .background(.white)
                            .cornerRadius(5)
                            .frame(height: 75)
                    }
                    
                    Spacer()
                    HStack {
                        Spacer()
                        ArrowButton(text:"back",basecolor:.white,accentcolor:Color("basecolor")) {
                            model.navigateBack()
                        }
                        .frame(width: 80)
                        .padding(.trailing,-4)
                    }
                    .padding(.bottom,15)
                    
                }
                .padding(.top,15)
                .padding(.leading, 40.0)
                .padding(.trailing, 15.0)
                .ignoresSafeArea()
                .frame(width: geometry.size.width * sidebarSize,height: geometry.size.height)
                .background(Color("basecolor"))
                .foregroundColor(.white)
                
                //MARK right
                VStack(alignment: .center) {
                    //users headline
                    HStack {
                        Text("Users")
                            .font(.title2)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    
                    //list
                    ScrollView {
                        //add
                        HStack {
                            InvertedTextField(text: $eventDetailsModel.newUser, placeholder: "name", id: "1")
                            Spacer()
                            IconButton(
                                icon:"plus",
                                basecolor: Color("accentcolor"),
                                accentcolor: .white,
                                action: eventDetailsModel.addPerson,
                                font:.title)
                        }
                        .padding(.all, 10)
                        .background(Color("accentcolor"))
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .padding(.bottom,10)
                        //list
                        ForEach(eventDetailsModel.persons) { person in
                            Person(name:person.name,id:person.id)
                                .padding(.bottom,10)
                        }
                    }
                }
                .padding(.leading,10)
                .padding(.top,15)
                .padding(.trailing,45)
                .ignoresSafeArea()
                .frame(width: geometry.size.width * (1-sidebarSize),height: geometry.size.height)
            }
        }
    }
    
    var portrait: some View {
        VStack(alignment: .center) {
            
            //event Headline
            HStack {
                Text("Event")
                    .font(.title)
                    .fontWeight(.medium)
                Spacer()
                HStack {
                    Button(action: eventDetailsModel.saveDetails) {
                        Text("save")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(8)
                    .background(Color("accentcolor"))
                    .cornerRadius(5)
                    .foregroundColor(.white)
                    
                    ArrowButton(text:"back",basecolor:Color("accentcolor"),accentcolor:.white) {
                        model.navigateBack()
                    }
                    .frame(width: 80)
                }
            }
            
            //name and description
            VStack {
                HStack {
                    Text("Event Name")
                        .font(.headline)
                    Spacer()
                }
                TextField("", text: $eventDetailsModel.eventname)
                    .padding(.horizontal, 15)
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color("accentcolor"), lineWidth: 2)
                            .frame(height: 50)
                    )
                HStack {
                    Text("Description")
                        .font(.headline)
                    Spacer()
                }
                .padding(.top, 10)
                TextEditor(text: $eventDetailsModel.eventdescription)
                    .padding(.horizontal, 15)
                    .frame(height: 75)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color("accentcolor"), lineWidth: 2)
                            .frame(height: 75)
                    )
            }
            
            //users headline
            HStack {
                Text("Users")
                    .font(.title2)
                    .fontWeight(.medium)
                Spacer()
            }
            
            //list
            ScrollView {
                //add
                HStack {
                    InvertedTextField(text: $eventDetailsModel.newUser, placeholder: "name", id: "1")
                    Spacer()
                    IconButton(
                        icon:"plus",
                        basecolor: Color("accentcolor"),
                        accentcolor: .white,
                        action: eventDetailsModel.addPerson,
                        font:.title)
                }
                .padding(.all, 10)
                .background(Color("accentcolor"))
                .foregroundColor(.white)
                .cornerRadius(5)
                .padding(.bottom,10)
                //list
                ForEach(eventDetailsModel.persons) { person in
                    Person(name:person.name,id:person.id)
                        .padding(.bottom,10)
                }
            }

            
        }
        .padding(.horizontal,15)
    }
}

struct Person: View, Identifiable {
    var name: String
    var id: String
    
    var body: some View {
        HStack {
            Text(name)
            
            Spacer()
        }
        .padding(.all, 10)
        .background(Color("accentcolor"))
        .foregroundColor(.white)
        .cornerRadius(5)
    }
}

struct EventDetails_Previews: PreviewProvider {
    static var previews: some View {
        EventDetails().environmentObject(ExpenseCalculatorModel.shared)
    }
}
