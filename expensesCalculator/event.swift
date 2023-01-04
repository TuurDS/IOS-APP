//
//  Event.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 02/01/2023.
//

import SwiftUI

struct Event: View {
    var id: Int
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.height > geometry.size.width {
                portrait
            } else {
                landscape
            }
        }
    }
    
    let sidebarSize: CGFloat = 0.35
    
    let expenseCards = [
        ExpenseCard(amount: 12.99, username: "Jane", description: "Grocery Shopping", id: "1"),
        ExpenseCard(amount: 56.34, username: "Bob", description: "Dinner at Restaurant", id: "2"),
        ExpenseCard(amount: 78.45, username: "Alice", description: "Rent for August", id: "3"),
        ExpenseCard(amount: 156.34, username: "Thomas", description: "Food", id: "4"),
        ExpenseCard(amount: 72.49, username: "Jake", description: "Utilities", id: "5"),
    ]
    
    var landscape: some View {
        GeometryReader { geometry in
            HStack {
                //MARK left
                VStack(alignment: .center) {
                    
                    HStack {
                        Text("Event")
                            .font(.title)
                            .fontWeight(.medium)
                            .frame(width:72)
                        Spacer()
                        HStack {
                            IconButton(icon:"pencil",basecolor:.white,accentcolor:Color("basecolor")) {
                                
                            }
                            IconButton(icon:"chart.bar.xaxis",basecolor:.white,accentcolor:Color("basecolor")) {
                                
                            }
                            IconButton(icon:"trash",basecolor:.white,accentcolor:Color("basecolor")) {
                                
                            }
                        }
                    }
                    
                    VStack(spacing: 10) {
                        HStack {
                            Text("this is the name")
                                .font(.headline)
                                .underline()
                            Spacer()
                        }
                        HStack {
                            Text("this is the entire discription of this event. Why it is an event. It is the explanation of the event you want to track.")
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        ArrowButton(text:"back",basecolor:.white,accentcolor:Color("basecolor")) {
                            
                        }
                        .frame(width: 80)
                    }
                    .padding(.bottom,20)
                    
                }
                .padding(.top,15)
                .padding(.leading, 40.0)
                .padding(.trailing, 10.0)
                .ignoresSafeArea()
                .frame(width: geometry.size.width * sidebarSize,height: geometry.size.height)
                .background(Color("basecolor"))
                .foregroundColor(.white)
                
                //MARK right
                VStack(alignment: .center) {
                    
                    //expenses headline
                    HStack {
                        Text("Expenses")
                            .font(.title2)
                            .fontWeight(.medium)
                        Button(action: {
                            // Perform add expense add action
                        }) {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(Color("basecolor"))
                        }
                        Spacer()
                    }
                    //list
                    ScrollView {
                        ForEach(expenseCards) { card in
                                ExpenseCard(amount: card.amount, username: card.username, description: card.description, id: card.id)
                                .padding(.bottom,10)
                        }
                    }
                    .padding(.horizontal,10)
                }
                .padding(.top,15)
                .padding(.trailing,35)
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
                    IconButton(icon:"pencil",basecolor:Color("accentcolor"),accentcolor:.white) {
                        
                    }
                    IconButton(icon:"chart.bar.xaxis",basecolor:Color("accentcolor"),accentcolor:.white) {
                        
                    }
                    IconButton(icon:"trash",basecolor:Color("accentcolor"),accentcolor:.white) {
                        
                    }
                    
                    ArrowButton(text:"back",basecolor:Color("accentcolor"),accentcolor:.white) {
                        
                    }
                    .frame(width: 80)
                }
            }
            
            //name and description
            VStack(spacing: 10) {
                HStack {
                    Text("this is the name")
                        .font(.headline)
                        .underline()
                        .foregroundColor(Color("lightgrey"))
                    Spacer()
                }
                HStack {
                    Text("this is the entire discription of this event. Why it is an event. It is the explanation of the event you want to track.")
                        .foregroundColor(Color("lightgrey"))
                    Spacer()
                }
            }
            .padding(.bottom,10)
            
            //expenses headline
            HStack {
                Text("Expenses")
                    .font(.title2)
                    .fontWeight(.medium)
                Spacer()
                Button(action: {
                    // Perform add expense add action
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(Color("basecolor"))
                }
            }
            //list
            ScrollView {
                ForEach(expenseCards) { card in
                        ExpenseCard(amount: card.amount, username: card.username, description: card.description, id: card.id)
                        .padding(.bottom,10)
                }
            }

            
        }
        .padding(.horizontal,15)
    }
}


//rounded rectangle
struct ExpenseCard: View,Identifiable {
    var amount: Double
    var username: String
    var description: String
    var id: String
    
    var body: some View {
        VStack(spacing:10) {
            HStack {
                Text(String(amount) + "$")
                    .font(.headline)
                    .foregroundColor(Color("darkaccent"))
                Text("Paid By: " + username)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Spacer()
                IconButton(icon:"trash",basecolor:Color("accentcolor"),accentcolor:.white) {
                    
                }
            }
            HStack {
                Text(description)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .padding(10)
        .background(Color("accentcolor"))
        .cornerRadius(10)
        .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.25),
                radius: 4, x: 0, y: 4)
    }
}

struct Event_Previews: PreviewProvider {
    static var previews: some View {
        Event(id:1)
    }
}
