//
//  TagsView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/26/22.
//

import SwiftUI

struct CreateTagsView: View {
    @Binding var task: UserTask
    @Binding var addedTags: [String]
    @Binding var changedTags: Bool
    var token: String
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var description = false
    @State var addTag = false
    @State var newTag = Tag(id: "", name: "", color: SelectedColor(red: 1, green: 0, blue: 0))
    @State var newColor = Color.yellow
    @State var processing = false
    @State var showSuccess = false
    @State var showError = false
    
    var body: some View {
        NavigationView{
            VStack{
                if task.tags.isEmpty{
                    Text("No tags for this task")
                    
                } else {
                    ForEach(task.tags, id:\.self) {tag in
                        TagRow(tag: tag, token: token, task: $task, addedTags: $addedTags)
                    }
                }
                
                // Add New Tags
                Button(action: {
                    changedTags = true
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
            //.padding(.horizontal, 15)
            .preferredColorScheme(.dark)
        }
        .alert("Success", isPresented: $showSuccess){
            Button("Done", role: .cancel){}
        } message: {
            Text("The tag has been successfully created")
        }
        .alert("Error", isPresented: $showSuccess){
            Button("Okay", role: .cancel){}
        } message: {
            Text("An error occurred while creating the tag")
        }
        .sheet(isPresented: $addTag){
            ZStack {
                if processing {
                    ProgressView()
                }
                VStack {
                    Button(action: {
                        newTag.color.red = newColor.components.red
                        newTag.color.green = newColor.components.green
                        newTag.color.blue = newColor.components.blue
                        
                        Task {
                            processing = true
                            await addTag(tag: newTag)
                            
                            // Add the new tag to the task array
                            task.tags.append(newTag)
                            if newTag.id != "" {
                                addedTags.append(newTag.id)
                            }
                        }
                        
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
    
    func addTag(tag: Tag) async {
        let url = RequestBase().url + "/api/Tags"
        
        let bodyObject : [String: Any] = [
            "name" : tag.name,
            "color" : [
                "red" : tag.color.red,
                "green" : tag.color.green,
                "blue" : tag.color.blue
            ]
        ]
        
        let body = try! JSONSerialization.data(withJSONObject: bodyObject)
        
        let (data, status) = await API().sendPostRequest(requestUrl: url, requestBodyComponents: body, token: token)
            print(String(decoding: data, as: UTF8.self))
            
        do {
            // If successful, decode the tag
            print("Status code: \(status)")
            if status == 200 || status == 201{
                newTag = try JSONDecoder().decode(Tag.self, from: data)
                processing = false
                showSuccess = true
            }else{
                newTag = try JSONDecoder().decode(Tag.self, from: data)
                processing = false
                showError = true
            }
        } catch {
            print(error)
        }
    }
}

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
//                        Task {
//                            await deleteTag(id: tag.id, token: token)
//                        }
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
                HStack{
                    Circle()
                        .strokeBorder(Color.blue, lineWidth: 2)
                        .background(Circle().foregroundColor(tagColor))
                        .frame(width: 30, height: 30)
                    TextField("", text: $tagName)
                        .keyboardType(.default)
                        .onChange(of: tagName, perform: {newValue in
                            Task {
                                await editTag(id: tag.id, newColor: tagColor, newName: tagName, token: token)
                            }
                        })
                    ColorPicker("", selection: $tagColor, supportsOpacity: false)
                        .onChange(of: tagColor, perform: { newValue in
                            Task {
                                await editTag(id: tag.id, newColor: tagColor, newName: tagName, token: token)
                            }
                        })

                }
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

func editTag(id: String, newColor: Color, newName: String, token: String) async {
    let url = RequestBase().url + "/api/Tags/" + id
    
    let bodyObject : [String: Any] = [
        "name" : newName,
        "color" : [
            "red" : newColor.components.red,
            "green" : newColor.components.green,
            "blue" : newColor.components.blue
        ]
    ]
    
    let body = try! JSONSerialization.data(withJSONObject: bodyObject)
    
    let (data, status) = await API().sendPutRequest(requestUrl: url, requestBodyComponents: body, token: token)
    print(String(decoding: data, as: UTF8.self))

    print("Status code: \(status)")
    if status == 200 || status == 201{
        print("Success updating the tag")
    }else{
        print("An error occurred updating the tag")
    }
}

struct CreateTagsView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTagsView(task: .constant(UserTask(id: "", name: "Example", isTimeSensitive: true, startDateTime: "", endDateTime: "", repeatDays: [], weatherRequirement: "none", isCompleted: false, tags: [Tag(id: "", name: "Sports", color: SelectedColor(red: 1, green: 0, blue: 0)), Tag(id: "", name: "Personal", color: SelectedColor(red: 0, green: 0, blue: 1))])), addedTags: .constant([]), changedTags: .constant(false), token: "")
            .preferredColorScheme(.dark)
    }
}
