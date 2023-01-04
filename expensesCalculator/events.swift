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
    
    @State private var isPinned: Bool = false
    
    let sidebarSize: CGFloat = 0.40
    
    let cards = [
        RoundedRectangleCard(title: "Title 1", number: "1", description: "Description 1", icon: "pin.fill", iconColor: .red, isPinned: true, id: "1"),
        RoundedRectangleCard(title: "Title 2", number: "2", description: "Description 2", icon: "pin.fill", iconColor: .yellow, isPinned: false, id: "2"),
        RoundedRectangleCard(title: "Title 3", number: "3", description: "Description 3", icon: "pin.fill", iconColor: .blue, isPinned: true, id: "3"),
        RoundedRectangleCard(title: "Title 4", number: "4", description: "Description 4", icon: "pin.fill", iconColor: .green, isPinned: true, id: "4"),
        RoundedRectangleCard(title: "Title 5", number: "5", description: "Description 5", icon: "pin.fill", iconColor: .purple, isPinned: false, id: "5")
    ]


    
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
                        Button(action: {
                            // Perform add event action
                        }) {
                            Image(systemName: "plus")
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 200)
                    
                    //pinned unpinned
                    PinnedUnpinnedButtons(isPinned: $isPinned, basecolor:Color("basecolor"),strokeColor: .white)
                    
                    Spacer()
                    
                    //logout button
                    HStack {
                        Spacer()
                        ArrowButton(text:"Logout",basecolor: .white, accentcolor: Color("basecolor")) {
                            // Perform logout action
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
                    
                    List(cards) { card in
                        RoundedRectangleCard(title: card.title, number: card.number, description: card.description, icon: card.icon, iconColor: card.iconColor, isPinned: card.isPinned, id: card.id)
                    }
                    .listRowBackground(Color.clear)
                    .listStyle(PlainListStyle())
                    
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
                    // Perform logout action
                }
            }
            .padding(.trailing, 8)
            
            // title and plus
            HStack {
                Text("Events")
                    .font(.title)
                    .fontWeight(.medium)
                Spacer()
                Button(action: {
                    // Perform add event action
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(Color("basecolor"))
                }
            }
            .padding(.horizontal, 8)
            
            //pinned unpinned
            PinnedUnpinnedButtons(isPinned: $isPinned,basecolor:Color("accentcolor"), strokeColor: Color("basecolor"))
            
            ScrollView {
                ForEach(cards) { card in
                    RoundedRectangleCard(title: card.title, number: card.number, description: card.description, icon: card.icon, iconColor: card.iconColor, isPinned: card.isPinned, id: card.id)
                        .padding(.bottom,10)
                        .onTapGesture {
                            print("tapped card")
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
    var iconColor: Color
    var isPinned: Bool
    var id: String
    
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
                        basecolor: isPinned ? Color("accentcolor"): .white,
                        accentcolor: isPinned ? .white: Color("accentcolor"),
                        action:  {
                            print("tapped icon")
                            
                        },
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
        Events()
    }
}
