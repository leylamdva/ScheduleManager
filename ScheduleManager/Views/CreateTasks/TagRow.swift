//
//  TagRow.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/10/23.
//

import SwiftUI

struct TagRow: View{
    var tag: Tag
    var token: String
    @Binding var task: UserTask
    @Binding var addedTags: [String]
    
    @State var description = false
    @State var tagColor = Color.blue
    @State var tagName = ""
    
    var body: some View{
        
        // Pencil icon + tag
        VStack{
            Button(action: {
                description.toggle()
            }){
                HStack {
                    // Pencil image
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 15, height: 15)
                    // Tag with background
                    Text("\(tagName)").bold()
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 7).fill(tagColor))
                    Spacer()
                    // Delete tag button
                    Button(action: {
                        for i in 0..<task.tags.count {
                            if task.tags[i].id == tag.id {
                                print("Deleting tag \(task.tags[i].name)")
                                task.tags.remove(at: i)
                            }
                        }
                        
                        for j in 0..<addedTags.count {
                            if addedTags[j] == tag.id {
                                print("Deleting tag \(addedTags[j]) from addedTags")
                                addedTags.remove(at: j)
                            }
                        }
                    }, label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                    })
                }
                .padding(.horizontal, 10)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Edit tag
            if description {
                TagDescriptionView(tagName: $tagName, tagColor: $tagColor, token: token, tagId: tag.id)
            }
            
            Divider()
                .frame(minWidth: 1)
                .background(Color.gray)
        } //VStack
        .padding(.horizontal, 15)
        .onAppear(perform: {
            tagColor = Color(red: tag.color.red, green: tag.color.green, blue: tag.color.blue)
            tagName = tag.name
        })
    }
    
}

struct TagRow_Previews: PreviewProvider {
    static var previews: some View {
        TagRow(tag: Tag(id: "", name: "ExampleTag", color: SelectedColor(red: 1, green: 0, blue: 0)), token: "", task: .constant(UserTask(id: "", name: "ExampleTask", isTimeSensitive: false, startDateTime: "", endDateTime: "", repeatDays: [], weatherRequirement: "None", isCompleted: false, tags: [])), addedTags: .constant([]))
            .preferredColorScheme(.dark)
    }
}
