//
//  Expense.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 03/01/2023.
//

import SwiftUI

struct Expense: View {
    let id: Int
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.height > geometry.size.width {
                portrait
            } else {
                landscape
            }
        }
    }
    
    let sidebarSize: CGFloat = 0.50
    @ObservedObject var model = ExpenseModel()
    
    var landscape: some View {
        GeometryReader { geometry in
            HStack {
                //MARK left
                VStack(alignment: .center) {
                   
                    HStack {
                        HStack {
                            Text("Expense")
                                .font(.title)
                                .fontWeight(.medium)
                            Spacer()
                            HStack {
                                Button(action: {
                                    //TODO
                                }) {
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
                    }
                    
                    //INPUT FIELDS PRICE AND DATE
                    HStack(spacing:25) {
                        VStack(alignment:.leading,spacing: 3) {
                            Text("Price")
                                .fontWeight(.medium)
                            TextField("", value: $model.price, formatter: numberFormatter)
                                .padding(.all,5)
                                .foregroundColor(.black)
                                .background(.white)
                                .cornerRadius(5)
                        }
                        VStack(alignment:.leading,spacing: 3) {
                            Text("Date")
                                .fontWeight(.medium)
                            
                            DatePicker("", selection: $model.date, displayedComponents: .date)
                                .labelsHidden()
                                .accentColor(Color("basecolor"))
                                .background(.white)
                                .cornerRadius(5)
                        }
                        
                    }
                    
                    //INPUT DESCRIPTION
                    VStack(alignment:.leading,spacing: 3) {
                        Text("Description")
                            .fontWeight(.medium)
                        
                        TextEditor(text: $model.description)
                            .padding(.all,5)
                            .foregroundColor(.black)
                            .background(.white)
                            .cornerRadius(5)
                            .frame(height: 75)
                    }
                    
                    //SPLIT TYPE COMPONENT
                    VStack(alignment:.leading,spacing: 3) {
                        Text("Split Type")
                            .fontWeight(.medium)
                        
                        SplitTypeButtons(splitType: $model.splitType, basecolor:Color("basecolor"),strokeColor: .white)
                            
                    }
                    
                    Spacer()
                    HStack {
                        Spacer()
                        ArrowButton(text:"back",basecolor:.white,accentcolor:Color("basecolor")) {
                            
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

                    //list of users
                    ScrollView {
                        ForEach($model.persons) { ep in
                            HStack {
                                Text(ep.name.wrappedValue)
                                
                                Spacer()
                                TextField("", value: ep.value, formatter: numberFormatter)
                                    .padding(.all,5)
                                    .foregroundColor(.black)
                                    .background(.white)
                                    .cornerRadius(5)
                                    .frame(maxWidth: 70)
                                    .multilineTextAlignment(.center)
                                    .disabled(model.splitType == "equal")
                                    .opacity(model.splitType == "equal" ? 0.85 : 1)
                            }
                            .padding(.all, 10)
                            .background(Color("accentcolor"))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            
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
                Text("Expense")
                    .font(.title)
                    .fontWeight(.medium)
                Spacer()
                HStack {
                    Button(action: {
                        print(self.model)
                    }) {
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
                        
                    }
                    .frame(width: 80)
                    .padding(.trailing,-5)
                }
            }
            //INPUT FIELDS PRICE AND DATE
            HStack(spacing:25) {
                VStack(alignment:.leading,spacing: 3) {
                    Text("Price")
                        .foregroundColor(Color("basecolor"))
                    TextField("", value: $model.price, formatter: numberFormatter)
                        .padding(.horizontal, 15)
                        .frame(height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color("accentcolor"), lineWidth: 2)
                                .frame(height: 40)
                        )
                }
                VStack(alignment:.leading,spacing: 3) {
                    Text("Date")
                        .foregroundColor(Color("basecolor"))
                    
                    DatePicker("", selection: $model.date, displayedComponents: .date)
                        .labelsHidden()
                        .accentColor(Color("basecolor"))
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                
            }
            
            //INPUT DESCRIPTION
            VStack(alignment:.leading,spacing: 3) {
                Text("Description")
                    .foregroundColor(Color("basecolor"))
                
                TextEditor(text: $model.description)
                    .padding(.horizontal, 15)
                    .frame(height: 75)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color("accentcolor"), lineWidth: 2)
                            .frame(height: 75)
                    )
            }
            
            //SPLIT TYPE COMPONENT
            VStack(alignment:.leading,spacing: 3) {
                Text("Split Type")
                    .foregroundColor(Color("basecolor"))
                
                SplitTypeButtons(splitType: $model.splitType, basecolor: Color("accentcolor"), strokeColor: Color("accentcolor"))
                    
            }
            
            //users headline
            HStack {
                Text("Users")
                    .font(.title2)
                    .fontWeight(.medium)
                Spacer()
            }

            //list of users
            ScrollView {
                ForEach($model.persons) { ep in
                    HStack {
                        Text(ep.name.wrappedValue)
                        
                        Spacer()
                        TextField("", value: ep.value, formatter: numberFormatter)
                            .padding(.all,5)
                            .foregroundColor(.black)
                            .background(.white)
                            .cornerRadius(5)
                            .frame(maxWidth: 70)
                            .multilineTextAlignment(.center)
                            .disabled(model.splitType == "equal")
                            .opacity(model.splitType == "equal" ? 0.85 : 1)
                    }
                    .padding(.all, 10)
                    .background(Color("accentcolor"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    
                }

            }

            
        }
        .padding(.horizontal,15)
    }
    
}

let numberFormatter: NumberFormatter = {
  let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
  return formatter
}()

class ExpenseModel: ObservableObject {
    
    @Published var price: Double{
        didSet {
            if splitType == "equal" {
                distributeAmountEqual()
            }
        }
    }
    var description: String
    @Published var splitType: String {
        didSet {
            if splitType == "equal" {
                distributeAmountEqual()
            }
        }
    }
    var date: Date
    var persons: [ExpensePerson]
    
    init() {
        price = 102.54
        description = "this is the description of the expense"
        splitType = "percentage"
        date = Date()
        persons = [
            ExpensePerson(name: "Alice", value: 30.20),
            ExpensePerson(name: "Bob", value: 30.20),
            ExpensePerson(name: "Eve", value: 42.14)
        ]
    }
    
    func distributeAmountEqual() {
        let totalAmount = self.price
        let numPersons = self.persons.count
        let equalAmount = totalAmount / Double(numPersons)

        for person in self.persons {
            person.value = equalAmount
        }
    }
}


class ExpensePerson: Identifiable {
    var value: Double
    var name: String
    
    init(name:String,value:Double) {
        self.name = name
        self.value = value
    }
}


struct Expense_Previews: PreviewProvider {
    static var previews: some View {
        Expense(id:1)
    }
}
