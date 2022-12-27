//
//  TagsView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/26/22.
//

import SwiftUI

struct CreateTagsView: View {
    var task: Task
    
    @State var description = false
    @State var addTag = false
    @State var newTag = Tag(name: "", color: SelectedColor(red: 1, green: 0, blue: 0))
    @State var newColor = Color.yellow
    
    var body: some View {
        NavigationView{
            VStack{
                if task.tags.isEmpty{
                    Text("No tags for this task")
                    
                } else {
                    ForEach(task.tags, id:\.self) {tag in
                        TagRow(tag: tag)
                    }
                }
                
                
                Button(action: {
                    addTag = true
                }){
                    Text("Create a tag")
                        .font(.title3)
                        .padding()
                        .underline()
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }
            .navigationTitle("Tags")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $addTag){
            VStack {
                Button(action: {
                    
                    // TODO: add new tag to the database
                    newTag.color.red = newColor.components.red
                    newTag.color.green = newColor.components.green
                    newTag.color.blue = newColor.components.blue
                    //task.tags.append(newTag)
                    addTag.toggle()
                }){
                    // Dismiss arrow
                    Image(systemName: "chevron.down")
                        .resizable()
                        .frame(width: 40, height: 25)
                }
                Spacer()
                // Text field for name and color picker for new tag
                HStack{
                    TextField("Name", text: $newTag.name)
                        .modifier(InputField(fieldColor: .gray))
                    ColorPicker("", selection: $newColor, supportsOpacity: false)
                }
                
                Spacer()
            }
        }
    }
}

struct TagRow: View{
    var tag: Tag
    //@Binding var description: Bool
    //@Binding var selectedColor: Color
    @State var description = false
    @State var tagColor = Color.blue
    @State var selectedColor = Color.yellow
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
                }
                .padding(.horizontal, 10)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Edit tag
            if description {
                HStack{
                    Circle()
                        .strokeBorder(Color.blue, lineWidth: 2)
                        .background(Circle().foregroundColor(tagColor))
                        .frame(width: 30, height: 30)
                    TextField("", text: $tagName)
                        .keyboardType(.default)
                    ColorPicker("", selection: $selectedColor, supportsOpacity: false)
                        .onChange(of: selectedColor, perform: { newValue in
                            tagColor = selectedColor
                        })
                    //Spacer()
                }
            }
            
            Divider()
                .frame(minWidth: 1)
                .background(Color.gray)
        } //VStack
        .onAppear(perform: {
            tagColor = Color(red: tag.color.red, green: tag.color.green, blue: tag.color.blue)
            tagName = tag.name
            //TODO: Send edit request on color change or name change
        })
    }
    
}

struct CreateTagsView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTagsView(task: Task(name: "Example", start_time: "", end_time: "", recurring: "no", weather: "none", tags: [Tag(name: "Sports", color: SelectedColor(red: 1, green: 0, blue: 0)), Tag(name: "Personal", color: SelectedColor(red: 0, green: 0, blue: 1))]))
            .preferredColorScheme(.dark)
    }
}
