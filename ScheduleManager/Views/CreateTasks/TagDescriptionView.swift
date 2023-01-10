//
//  TagDescriptionView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/10/23.
//

import SwiftUI

struct TagDescriptionView: View {
    @Binding var tagName: String
    @Binding var tagColor: Color
    var token: String
    var tagId: String
    
    var body: some View {
        HStack{
            Circle()
                .strokeBorder(Color.blue, lineWidth: 2)
                .background(Circle().foregroundColor(tagColor))
                .frame(width: 30, height: 30)
            TextField("", text: $tagName)
                .keyboardType(.default)
                .onChange(of: tagName, perform: {newValue in
                    Task {
                        await editTag(id: tagId, newColor: tagColor, newName: tagName, token: token)
                    }
                })
            ColorPicker("", selection: $tagColor, supportsOpacity: false)
                .onChange(of: tagColor, perform: { newValue in
                    Task {
                        await editTag(id: tagId, newColor: tagColor, newName: tagName, token: token)
                    }
                })
            
        }
    }
}

struct TagDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        TagDescriptionView(tagName: .constant("ExampleName"), tagColor: .constant(.yellow), token: "", tagId: "")
            .preferredColorScheme(.dark)
    }
}
