//
//  UIcomponents.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 01/01/2023.
//

import SwiftUI

//Image(systemName:"pin.fill")
//Image(systemName:"plus")
//Image(systemName:"trash")
//Image(systemName:"arrow.backward")
//Image(systemName:"calendar")
//Image(systemName:"arrow.right")
//Image(systemName:"square.and.pencil")
//Image(systemName:"chart.bar.xaxis")

//MARK textfield
struct HighlightableTextField: View {
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool
    @Binding var focusedField : String
    var id: String
    
    var body: some View {
        if isSecure {
            SecureField("", text: $text, onCommit: { self.focusedField = "" })
            .onTapGesture { self.focusedField = id }
            .modifier(TextFieldStyle(
                placeholder: placeholder,
                focusedField: focusedField,
                id:id,
                text:text))
        } else {
            TextField("", text: $text, onCommit: { self.focusedField = "" })
            .onTapGesture { self.focusedField = id }
            .modifier(TextFieldStyle(
                placeholder: placeholder,
                focusedField: focusedField,
                id:id,
                text:text))
        }
    }
}


//textfield style
struct TextFieldStyle: ViewModifier {
    var placeholder: String
    var focusedField: String
    var id: String
    var text: String
    
    func body(content: Content) -> some View {
        content
        .padding(.bottom, 16)
        .foregroundColor(focusedField == id ? Color("accentcolor") : Color("darkgrey"))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .offset(y: 8)
                .foregroundColor(focusedField == id ? Color("basecolor") : Color("darkgrey"))
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .placeholder(when: text.isEmpty) {
            Text(placeholder).foregroundColor(Color("darkgrey")).padding([.leading, .bottom], 16)
        }
    }
}

//logout button
struct ArrowButton: View {
    let text: String
    let basecolor: Color
    let accentcolor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "arrow.backward")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(accentcolor)
                Text(text)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(accentcolor)
            }
        }
        .padding(8)
        .background(basecolor)
        .cornerRadius(5)
        .foregroundColor(accentcolor)
    }
}

struct IconButton: View {
    let font: Font?
    let icon: String
    let basecolor: Color
    let accentcolor: Color
    let action : () -> Void
    
    init(icon: String, basecolor: Color, accentcolor: Color, action: @escaping () -> Void, font: Font? = .body) {
        self.icon = icon
        self.basecolor = basecolor
        self.accentcolor = accentcolor
        self.action = action
        self.font = font
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
            .font(font ?? .body) // use .body as the default font
            .foregroundColor(accentcolor)
        }
        .frame(width: 30,height:30)
        .background(basecolor)
        .cornerRadius(5)
        .foregroundColor(accentcolor)
    }
}


struct InvertedTextField: View {
    @Binding var text: String
    var placeholder: String
    var id: String
    
    var body: some View {
        TextField("", text: $text)
            .placeholder(when: text.isEmpty) {
                Text(placeholder).foregroundColor(Color("darkgrey"))
            }
            .padding(.all,5)
            .foregroundColor(.black)
            .background(.white)
            .cornerRadius(5)
    }
}


struct SplitTypeButtons: View {
    @Binding var splitType: String
    var basecolor: Color
    var strokeColor: Color

    var body: some View {
        HStack(spacing: 0) {
            HStack{
                Spacer()
                Text("Equal")
                Spacer()
            }
                .padding(.vertical, 5)
                .fontWeight(.medium)
                .background(splitType == "equal" ? basecolor : Color.white)
                .foregroundColor(splitType == "equal" ? .white : basecolor)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        splitType = "equal"
                    }
                }
            HStack{
                Spacer()
                Text("Percentage")
                    .frame(width: 100)
                Spacer()
            }
                .padding(.vertical, 5)
                .fontWeight(.medium)
                .background(splitType == "percentage" ? basecolor : Color.white)
                .foregroundColor(splitType == "percentage" ? .white : basecolor)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        splitType = "percentage"
                    }
                }
            HStack{
                Spacer()
                Text("Amount")
                Spacer()
            }
                .padding(.vertical, 5)
                .fontWeight(.medium)
                .background(splitType == "amount" ? basecolor : Color.white)
                .foregroundColor(splitType == "amount" ? .white : basecolor)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        splitType = "amount"
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
