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
    @Query private var savings: [Saving]
    
    @State private var item: String = ""
    @State private var image: String = ""
    @State private var costText: String = ""
    @State private var cost: Double = Double()
    @State private var date: Date = Date()
    @State private var notificationType: Int = 0
    @FocusState private var keyboardFocused: Bool
    
    @State private var selectedItem: Item = .laptop
    
    enum Currencies: String, CaseIterable, Identifiable {
        //case eur = "EUR", usd = "USD", mxn = "MXN"
        case usd = "USD"
        var id: Self {self}
    }

    @State private var selectedCurrrency: Currencies = .usd

    enum Item: String, CaseIterable, Identifiable{
        case laptop = "laptopcomputer", car = "car", house = "house", gamecontroller = "gamecontroller", food = "fork.knife", dollar = "dollarsign", pencil = "pencil", bus = "bus", bag = "bag", phone = "phone"
        var id: Self {self}
    }
    
    @State private var selectedReminder: Reminder = .morning
    
    enum Reminder: String, CaseIterable, Identifiable{
        case morning = "morning", afternoon = "afternoon", night = "night"
        var id: Self {self}
    }
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
/*
                    Picker("", selection: $selectedCurrrency) {
                        ForEach(Currencies.allCases) { currency in
                            Text(currency.rawValue)
                                .lineLimit(1)
                                .scaledToFit()
                        }
                    }

                    Spacer()
 */
                    TextField("", text: $costText, prompt:
                                Text("Goal Amount")
                                    .foregroundColor(Color("TextSecondaryColor").opacity(0.36))) // Bind to the String
                        .foregroundStyle(Color("TextTertiaryColor"))
                        .scaledToFit()
                        .font(.title)
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
                }
                .padding()
                .background(Color("SecondaryColor"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 300, height: 200, alignment: .center)

                List{
                    HStack{
                        Image(systemName: "target")
                        TextField("", text: $item, prompt: Text("GoalName")
                            .foregroundColor(Color("TextPrimaryColor").opacity(0.5)))
                    }
                    .foregroundStyle(Color("TextPrimaryColor"))
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(Color("TextSecondaryColor").opacity(0.66))
                    
                    DatePicker(selection: $date, in: Date.now..., displayedComponents: .date) {
                        HStack{
                            Image(systemName: "calendar.circle")
                            Text("Deadline").fontDesign(.rounded)
                        }
                    }
                    .foregroundStyle(Color("TextPrimaryColor"))
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(Color("TextSecondaryColor").opacity(0.66))
                    
                    HStack{
                        Image(systemName: "bell.circle")
                        Picker("Notifications", selection: $selectedReminder) {
                            Text("Mornings").tag(Reminder.morning)
                            Text("Afternoons").tag(Reminder.afternoon)
                            Text("Nights").tag(Reminder.night)
                        }
                        .foregroundStyle(Color("TextPrimaryColor"))
                    }
                    .foregroundStyle(Color("TextPrimaryColor"))
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(Color("TextSecondaryColor").opacity(0.66))
                    
                    HStack{
                        Image(systemName: "list.bullet.circle")
                        Picker("Icon", selection: $selectedItem){
                            Image(systemName: "laptopcomputer").tag(NewGoalView.Item.laptop)
                            Image(systemName: "car").tag(NewGoalView.Item.car)
                            Image(systemName: "house").tag(NewGoalView.Item.house)
                            Image(systemName: "gamecontroller").tag(NewGoalView.Item.gamecontroller)
                            Image(systemName: "fork.knife").tag(NewGoalView.Item.food)
                            Image(systemName: "dollarsign").tag(NewGoalView.Item.dollar)
                            Image(systemName: "pencil").tag(NewGoalView.Item.pencil)
                            Image(systemName: "bus").tag(NewGoalView.Item.bus)
                            Image(systemName: "bag").tag(NewGoalView.Item.bag)
                            Image(systemName: "phone").tag(NewGoalView.Item.phone)
                        }
                    }
                    .foregroundStyle(Color("TextPrimaryColor"))
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(Color("TextSecondaryColor").opacity(0.66))
                }
                .listStyle(.plain)
                .background(Color.clear)
            }
            .navigationTitle("NewGoalTitle")
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
                    }.disabled(item.isEmpty || costText.isEmpty)
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
        let trimmedItem = item.trimmingCharacters(in: .whitespacesAndNewlines)
        let existingGoal = goals.first { $0.item == trimmedItem }
        
        if let existingGoal = existingGoal {
            // Prompt the user that the goal name is already used
            // You can show an alert or handle this situation as per your UI/UX design
            print("ExistingGoal")
        } else {
            // Save the goal if the item name is unique
            let newGoal = Goal(item: trimmedItem, image: selectedItem.rawValue, cost: cost, date: date, reminder: selectedReminder.rawValue, currency: selectedCurrrency.rawValue)
            modelContext.insert(newGoal)
            try? modelContext.save()
            dismiss()
            NotificationManager.instance.requestAuthorization()
            NotificationManager.instance.requestNotifications(reminder: selectedReminder.rawValue, goal: item)
        }
    }
}

#Preview {
    NewGoalView(isPresented: .constant(false))
}
