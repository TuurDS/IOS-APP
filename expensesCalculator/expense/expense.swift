//
//  Expense.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 03/01/2023.
//

import SwiftUI

struct Expense: View {
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                if geometry.size.height > geometry.size.width {
                    portrait
                } else {
                    landscape
                }
            }
            PopUpWindow(title: "Error", message: "make sure the values add up to the total amount or percetage!", buttonText: "OK", show: $expenseModel.showErrorPopup)
        }
    }
    @EnvironmentObject var model: ExpenseCalculatorModel
    @ObservedObject var expenseModel = ExpenseCalculatorModel.shared.expenseModel
    let sidebarSize: CGFloat = 0.50
    

    
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
                                Button(action: expenseModel.saveExpense) {
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
                    HStack(spacing:15) {
                        VStack(alignment:.leading,spacing: 3) {
                            Text("Price")
                                .fontWeight(.medium)
                            TextField("", value: $expenseModel.price, formatter: numberFormatter)
                                .padding(.all,5)
                                .foregroundColor(.black)
                                .background(.white)
                                .cornerRadius(5)
                                .frame(height: 40)
                        }
                        
                        VStack(alignment:.leading,spacing: 3) {
                            Text("Paid")
                            
                                .fontWeight(.medium)
                            Picker(selection: $expenseModel.paidPerson, label: Text("")) {
                                ForEach(expenseModel.persons.indices) { index in
                                    Text(expenseModel.persons[index].name)
                                }
                            }
                            .accentColor(.black)
                            .pickerStyle(.menu)
                            .background(.white)
                            .cornerRadius(5)
                            .foregroundColor(Color("basecolor"))
                            .frame(height: 40)
                        }
                        
                        VStack(alignment:.leading,spacing: 3) {
                            Text("Date")
                                .fontWeight(.medium)
                            
                            DatePicker("", selection: $expenseModel.date, displayedComponents: .date)
                                .labelsHidden()
                                .accentColor(Color("basecolor"))
                                .background(.white)
                                .cornerRadius(5)
                                .frame(height: 40)
                        }
                        
                    }
                    
                    //INPUT DESCRIPTION
                    VStack(alignment:.leading,spacing: 3) {
                        Text("Description")
                            .fontWeight(.medium)
                        
                        TextEditor(text: $expenseModel.description)
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
                        
                        SplitTypeButtons(splitType: $expenseModel.splitType, basecolor:Color("basecolor"),strokeColor: .white)
                            
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

                    //list of users
                    ScrollView {
                        ForEach($expenseModel.persons) { ep in
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
                                    .disabled(expenseModel.splitType == "equal")
                                    .opacity(expenseModel.splitType == "equal" ? 0.85 : 1)
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
                    Button(action: expenseModel.saveExpense) {
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
                    .padding(.trailing,-5)
                }
            }
            //INPUT FIELDS PRICE AND DATE
            HStack(spacing:10) {
                VStack(alignment:.leading,spacing: 3) {
                    Text("Price")
                        .foregroundColor(Color("basecolor"))
                    TextField("", value: $expenseModel.price, formatter: numberFormatter)
                        .padding(.horizontal, 15)
                        .frame(height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color("accentcolor"), lineWidth: 2)
                                .frame(height: 40)
                        )
                }
                
                VStack(alignment:.leading,spacing: 3) {
                    Text("Paid")
                        .foregroundColor(Color("basecolor"))
                    Picker(selection: $expenseModel.paidPerson, label: Text("")) {
                        ForEach(expenseModel.persons.indices) { index in
                            Text(expenseModel.persons[index].name)
                        }
                    }
                    .accentColor(.black)
                    .pickerStyle(.menu)
                    .foregroundColor(Color("basecolor"))
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
                    
                    DatePicker("", selection: $expenseModel.date, displayedComponents: .date)
                        .labelsHidden()
                        .accentColor(Color("basecolor"))
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .frame(height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color("accentcolor"), lineWidth: 2)
                                .frame(height: 40)
                        )
                }
                
            }
            
            //INPUT DESCRIPTION
            VStack(alignment:.leading,spacing: 3) {
                Text("Description")
                    .foregroundColor(Color("basecolor"))
                
                TextEditor(text: $expenseModel.description)
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
                
                SplitTypeButtons(splitType: $expenseModel.splitType, basecolor: Color("accentcolor"), strokeColor: Color("accentcolor"))
                    
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
                ForEach($expenseModel.persons) { ep in
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
                            .disabled(expenseModel.splitType == "equal")
                            .opacity(expenseModel.splitType == "equal" ? 0.85 : 1)
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


struct Expense_Previews: PreviewProvider {
    static var previews: some View {
        Expense().environmentObject(ExpenseCalculatorModel.shared)
    }
}
