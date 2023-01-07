//
//  Events.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 02/01/2023.
//

import SwiftUI

struct Events: View {
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
    @ObservedObject var eventsModel = ExpenseCalculatorModel.shared.eventsModel
    let sidebarSize: CGFloat = 0.40
    
    var landscape: some View {
        GeometryReader { geometry in
            HStack {
                //MARK left
                VStack(alignment: .center) {
                    
                    // title and plus
                    HStack {
                        Text("Events")
                            .font(.title)
                            .fontWeight(.medium)
                        Spacer()
                        Button(action: eventsModel.addEvent) {
                            Image(systemName: "plus")
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 200)
                    
                    //pinned unpinned
                    PinnedUnpinnedButtons(isPinned: $eventsModel.isPinned, basecolor:Color("basecolor"),strokeColor: .white)
                    
                    Spacer()
                    
                    //logout button
                    HStack {
                        Spacer()
                        ArrowButton(text:"Logout",basecolor: .white, accentcolor: Color("basecolor")) {
                            model.loginModel.Logout()
                        }
                    }
                    .padding(.bottom, 16)
                    
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
                    
                    ScrollView {
                        ForEach(eventsModel.items.enumerated().map { $0 }, id: \.element.id) { index, item in
                            RoundedRectangleCard(title: item.title, number: String(index + 1), description: item.description, icon: item.icon, isPinned: item.isPinned, id: item.id, PinEvent: {
                                eventsModel.pinEvent(id: item.id)
                            })
                                .padding(.bottom,10)
                                .onTapGesture {
                                    eventsModel.navigateToSingleEvent(id:item.id)
                                }
                        }

                    }
                    
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
            //logout button
            HStack {
                Spacer()
                ArrowButton(text:"Logout",basecolor: Color("accentcolor"), accentcolor: .white) {
                    model.loginModel.Logout()
                }
            }
            .padding(.trailing, 8)
            
            // title and plus
            HStack {
                Text("Events")
                    .font(.title)
                    .fontWeight(.medium)
                Spacer()
                Button(action: eventsModel.addEvent) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(Color("basecolor"))
                }
            }
            .padding(.horizontal, 8)
            
            //pinned unpinned
            PinnedUnpinnedButtons(isPinned: $eventsModel.isPinned,basecolor:Color("accentcolor"), strokeColor: Color("basecolor"))
            
            ScrollView {
                ForEach(eventsModel.items.enumerated().map { $0 }, id: \.element.id) { index, item in
                    RoundedRectangleCard(title: item.title, number: String(index + 1), description: item.description, icon: item.icon,isPinned: item.isPinned, id: item.id, PinEvent: {
                        eventsModel.pinEvent(id: item.id)
                    })
                        .padding(.bottom,10)
                        .onTapGesture {
                            eventsModel.navigateToSingleEvent(id:item.id)
                        }
                }

            }
            .padding(.all,10)
        }
    }
}

//switch pinned button
struct PinnedUnpinnedButtons: View {
    @Binding var isPinned: Bool
    var basecolor: Color
    var strokeColor: Color

    var body: some View {
        HStack(spacing: 0) {
            Text("Pinned")
                .frame(width: 80)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .font(.headline)
                .background(isPinned ? basecolor : Color.white)
                .foregroundColor(isPinned ? .white : basecolor)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.isPinned = true
                    }
                }
            Text("Unpinned")
                .frame(width: 80)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .font(.headline)
                .background(!isPinned ? basecolor : Color.white)
                .foregroundColor(!isPinned ? .white : basecolor)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.isPinned = false
                    }
                }
        }
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(strokeColor, lineWidth: 1.5)
        )
    }
}

//rounded rectangle
struct RoundedRectangleCard: View,Identifiable {
    var title: String
    var number: String
    var description: String
    var icon: String
    var isPinned: Bool
    var id: String
    var PinEvent: () -> Void
    
    var body: some View {
        VStack(spacing:10) {
            HStack {
                Text(title)
                    .font(.title)
                    .foregroundColor(.white)
                Spacer()
                Text(number)
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
            }
            HStack(alignment:.top) {
                Text(description)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Spacer()
                VStack {
                    Spacer()
                    IconButton(
                        icon:"pin.fill",
                        basecolor: isPinned ? .white: Color("accentcolor"),
                        accentcolor: isPinned ? Color("accentcolor"): .white,
                        action: PinEvent,
                        font:.title2)
                    
                }
                .frame(height: 80)
            }
        }
        .padding(10)
        .background(Color("accentcolor"))
        .cornerRadius(10)
        .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.25),
                radius: 4, x: 0, y: 4)
    }
}


struct Events_Previews: PreviewProvider {
    static var previews: some View {
        Events().environmentObject(ExpenseCalculatorModel.shared)
    }
}
