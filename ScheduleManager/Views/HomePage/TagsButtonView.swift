//
//  TagsButtonView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/10/23.
//

import SwiftUI

struct TagsButtonView: View {
    var tags: [Tag]
    @Binding var selectedTag: String
    
    var body: some View {
        ForEach(tags, id: \.self) { tag in
            Button(action: {
                if selectedTag == tag.name {
                    selectedTag = ""
                }else {
                    selectedTag = tag.name
                }
            }, label: {
                Text(tag.name).bold()
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 7).fill(Color(red: tag.color.red, green: tag.color.green, blue: tag.color.blue)))
                    .border((selectedTag == tag.name) ? .black : Color(red: tag.color.red, green: tag.color.green, blue: tag.color.blue))
                    
            })
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct TagsButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TagsButtonView(tags: [], selectedTag: .constant(""))
            .preferredColorScheme(.dark)
    }
}
