//
//  NewGoalView.swift
//  TrackSavings
//
//  Created by Gustavo Isaac Lopez Nunez on 18/02/24.
//
import SwiftData
import SwiftUI
import NotificationCenter
import UserNotifications

struct NewGoalView: View {
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var modelContext
    @Environment (\.dismiss) private var dismiss
    @Query private var goals: [Goal]
    @State private var item: String = ""
    @State private var image: String = ""
    @State private var costText: String = ""
    @State private var cost: Double = Double()
    @Query private var savings: [Saving]
    private var totalAmount: Double {
        return savings.reduce(0) { $0 + $1.amount }
    }
    @State private var date: Date = Date()
    @State private var notificationType: Int = 0
    @FocusState private var keyboardFocused: Bool
    @State private var selectedItem: Item = .car
    enum Item: String, CaseIterable, Identifiable{
        case car, phone, gamecontroller
        var id: Self {self}
    }
    
    @State private var selectedReminder: Reminder = .morning
    enum Reminder: String, CaseIterable, Identifiable{
        case morning, afternoon, night
        var id: Self {self}
    }
    
    var body: some View {
        NavigationView {
            VStack{
                TextField("", text: $costText, prompt: Text("Goal Amount")
                    .font(.title)
                    .foregroundColor(Color("TextSecondaryColor")
                        .opacity(0.36))) // Bind to the String
                .foregroundStyle(Color("TextPrimaryColor"))
                .padding()
                .background(Color("PrimaryColor"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 300, height: 200, alignment: .center)
                .multilineTextAlignment(.center)
                .focused($keyboardFocused)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        keyboardFocused = true
                    }
                }
                .keyboardType(.decimalPad)
                .onChange(of: costText) { newValue in
                    self.cost = Double(newValue) ?? 0 // Convert the input to Double
                }
                
                List{
                    HStack{
                        Image(systemName: "target")
                        TextField("", text: $item, prompt: Text("Goal Name")
                            .foregroundColor(Color("TextSecondaryColor")
                                .opacity(0.36)))
                    }
                    .foregroundStyle(Color("TextPrimaryColor"))
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(Color("TextSecondaryColor").opacity(0.66))
                    
                    DatePicker(selection: $date, in: Date.now..., displayedComponents: .date) {
                        HStack{
                            Image(systemName: "calendar")
                            Text("Calendar").fontDesign(.rounded)
                        }
                    }
                    .foregroundStyle(Color("TextPrimaryColor"))
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(Color("TextSecondaryColor").opacity(0.66))
                    
                    HStack{
                        Image(systemName: "bell.fill")
                        Text("Reminder")
                        Spacer()
                        Picker("", selection: $selectedReminder) {
                            Text("Mornings").tag(Reminder.morning)
                            Text("Afternoons").tag(Reminder.afternoon)
                            Text("Nights").tag(Reminder.night)
                        }
                    }
                    .foregroundStyle(Color("TextPrimaryColor"))
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(Color("TextSecondaryColor").opacity(0.66))
                    
                    HStack{
                        Image(systemName: "tag.fill")
                        Text("Tag")
                        Spacer()
                        
                        Picker("", selection: $selectedItem){
                            Image(systemName: "car").tag(NewGoalView.Item.car)
                            Image(systemName: "phone").tag(NewGoalView.Item.phone)
                            Image(systemName: "gamecontroller").tag(NewGoalView.Item.gamecontroller)
                        }
                        
                    }
                    .foregroundStyle(Color("TextPrimaryColor"))
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(Color("TextSecondaryColor").opacity(0.66))
                }
                .listStyle(.plain)
                .background(Color.clear)
            }
            .navigationTitle("New Goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        HStack{
                            Text("Cancel")
                        }
                    })
                }
                ToolbarItem(placement: .automatic) {
                    Button("Add") {
                        if !item.isEmpty && !costText.isEmpty {
                            withAnimation{
                                saveGoal()
                            }
                        }
                    }.disabled(item.isEmpty && costText.isEmpty)
                }
                
            }
            .fontDesign(.rounded)
            .toolbarColorScheme(.light, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("PrimaryColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .background(Color("BackgroundColor"))
            
        }
    }
    
    
    //MARK: - private mehods
    // In NewGoalView
    private func saveGoal() {
        let existingGoal = goals.first { $0.item == item }
        
        if let existingGoal = existingGoal {
            // Prompt the user that the goal name is already used
            // You can show an alert or handle this situation as per your UI/UX design
            print("A goal with the same name already exists. Please choose a different name.")
        } else {
            // Save the goal if the item name is unique
            let newGoal = Goal(item: item, image: image, cost: cost, date: date, reminder: selectedReminder.rawValue)
            modelContext.insert(newGoal)
            try? modelContext.save()
            dismiss()
        }
        NotificationManager.instance.requestNotifications(reminder: selectedReminder.rawValue)
    }
}

#Preview {
    NewGoalView(isPresented: .constant(false))
}
