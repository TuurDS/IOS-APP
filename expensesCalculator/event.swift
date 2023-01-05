//
//  Event.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 02/01/2023.
//

import SwiftUI

struct Event: View {
    
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
                            .frame(width:72)
                        Spacer()
                        HStack {
                            IconButton(icon:"pencil",basecolor:.white,accentcolor:Color("basecolor")) {
                                model.eventModel.navigateToEventDetails(id:model.eventModel.id)
                            }
                            IconButton(icon:"chart.bar.xaxis",basecolor:.white,accentcolor:Color("basecolor")) {
                                model.eventModel.navigateToReport(id:model.eventModel.id)
                            }
                            IconButton(icon:"trash",basecolor:.white,accentcolor:Color("basecolor")) {
                                model.eventModel.deleteEvent(id:model.eventModel.id)
                            }
                        }
                    }
                    
                    VStack(spacing: 10) {
                        HStack {
                            Text(model.eventModel.name)
                                .font(.headline)
                                .underline()
                            Spacer()
                        }
                        HStack {
                            Text(model.eventModel.description)
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        ArrowButton(text:"back",basecolor:.white,accentcolor:Color("basecolor")) {
                            model.navigateBack()
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
                        Button(action: model.eventModel.addExpense) {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(Color("basecolor"))
                        }
                        Spacer()
                    }
                    //list
                    ScrollView {
                        ForEach(model.eventModel.items) { item in
                            ExpenseCard(amount: item.amount, username: item.person, description: item.description, id: item.id, deleteExpense: {
                                model.eventModel.deleteEvent(id: item.id)
                            })
                            .padding(.bottom,10)
                            .onTapGesture {
                                model.eventModel.navigateToExpense(id: item.id)
                            }
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
                        model.eventModel.navigateToEventDetails(id:model.eventModel.id)
                    }
                    IconButton(icon:"chart.bar.xaxis",basecolor:Color("accentcolor"),accentcolor:.white) {
                        model.eventModel.navigateToReport(id:model.eventModel.id)
                    }
                    IconButton(icon:"trash",basecolor:Color("accentcolor"),accentcolor:.white) {
                        model.eventModel.deleteEvent(id:model.eventModel.id)
                    }
                    
                    ArrowButton(text:"back",basecolor:Color("accentcolor"),accentcolor:.white) {
                        model.navigateBack()
                    }
                    .frame(width: 80)
                }
            }
            
            //name and description
            VStack(spacing: 10) {
                HStack {
                    Text(model.eventModel.name)
                        .font(.headline)
                        .underline()
                        .foregroundColor(Color("lightgrey"))
                    Spacer()
                }
                HStack {
                    Text(model.eventModel.description)
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
                Button(action: model.eventModel.addExpense) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(Color("basecolor"))
                }
            }
            //list
            ScrollView {
                ForEach(model.eventModel.items) { item in
                    ExpenseCard(amount: item.amount, username: item.person, description: item.description, id: item.id, deleteExpense: {
                        model.eventModel.deleteEvent(id: item.id)
                    })
                    .padding(.bottom,10)
                    .onTapGesture {
                        model.eventModel.navigateToExpense(id: item.id)
                    }
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
    var deleteExpense: () -> Void
    
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
                    deleteExpense()
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
        Event().environmentObject(ExpenseCalculatorModel.shared)
    }
}
