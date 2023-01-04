//
//  report.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 04/01/2023.
//

import SwiftUI

struct Report: View {
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
    
    let sidebarSize: CGFloat = 0.35
    @ObservedObject var model = ReportModel()
    
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
                        ForEach($model.reports) { report in
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
                ForEach($model.reports) { report in
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

class ReportModel: ObservableObject {
    
    var reports: [SingleReport]
    
    init() {
        reports = [
            SingleReport(from: "Alice",to: "Bob",amount: 14.68, id: "1"),
            SingleReport(from: "jNic",to: "leah",amount: 145.54, id: "2"),
            SingleReport(from: "jonas",to: "jeff",amount: 23.16, id: "3"),
            SingleReport(from: "thomas",to: "arthur",amount: 0.68, id: "4"),
        ]
    }
}

class SingleReport: Identifiable {
    var from: String
    var to: String
    var amount: Double
    var id: String
    
    init(from: String, to: String, amount: Double, id:String) {
        self.from = from
        self.to = to
        self.amount = amount
        self.id = id
    }
}

struct Report_Previews: PreviewProvider {
    static var previews: some View {
        Report(id:1)
    }
}
