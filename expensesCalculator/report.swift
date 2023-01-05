//
//  report.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 04/01/2023.
//

import SwiftUI

struct Report: View {
    
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
                   
                    Text("Report")
                        .font(.title)
                        .fontWeight(.medium)
                    Spacer()
                    
                    ArrowButton(text:"back",basecolor:.white,accentcolor:Color("basecolor")) {
                        model.navigateBack()
                    }
                    .frame(width: 80)
                    .padding(.trailing,-5)
                    .padding(.bottom,15)
                    
                }
                .padding(.top,15)
                .padding(.leading, 15.0)
                .padding(.trailing,45.0)
                .ignoresSafeArea()
                .frame(width: geometry.size.width * sidebarSize,height: geometry.size.height)
                .background(Color("basecolor"))
                .foregroundColor(.white)
                
                //MARK right
                VStack(alignment: .center) {
                    
                    HStack {
                        Text("Transactions")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(Color("accentcolor"))
                        Spacer()
                    }

                    //list of users
                    ScrollView {
                        ForEach($model.reportModel.reports) { report in
                            HStack {
                                Text(report.from.wrappedValue)
                                    .frame(width: 100)
                                
                                Spacer()
                                
                                Image(systemName: "arrow.right")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text(report.to.wrappedValue)
                                    .frame(width: 100)
                                
                                Spacer()
                                
                                TextField("", value: report.amount, formatter: numberFormatter)
                                    .padding(.all,5)
                                    .foregroundColor(.black)
                                    .background(.white)
                                    .cornerRadius(5)
                                    .frame(maxWidth: 70)
                                    .multilineTextAlignment(.center)
                                    .disabled(true)
                            }
                            .padding(.all, 10)
                            .background(Color("accentcolor"))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .padding(.top,5)
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
                Text("Report")
                    .font(.title)
                    .fontWeight(.medium)
                Spacer()
                
                ArrowButton(text:"back",basecolor:Color("accentcolor"),accentcolor:.white) {
                    model.navigateBack()
                }
                .frame(width: 80)
                .padding(.trailing,-5)
            }
            HStack {
                Text("Transactions")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color("accentcolor"))
                Spacer()
            }

            //list of users
            ScrollView {
                ForEach($model.reportModel.reports) { report in
                    HStack {
                        Text(report.from.wrappedValue)
                            .frame(width: 100)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(report.to.wrappedValue)
                            .frame(width: 100)
                        
                        Spacer()
                        
                        TextField("", value: report.amount, formatter: numberFormatter)
                            .padding(.all,5)
                            .foregroundColor(.black)
                            .background(.white)
                            .cornerRadius(5)
                            .frame(maxWidth: 70)
                            .multilineTextAlignment(.center)
                            .disabled(true)
                    }
                    .padding(.all, 10)
                    .background(Color("accentcolor"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding(.top,5)
                }
            }

            
        }
        .padding(.horizontal,15)
    }
    
}

struct Report_Previews: PreviewProvider {
    static var previews: some View {
        Report().environmentObject(ExpenseCalculatorModel.shared)
    }
}
