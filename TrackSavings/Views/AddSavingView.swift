//
//  AddSavingView.swift
//  TrackSavings
//
//  Created by Gustavo Isaac Lopez Nunez on 20/02/24.
//

import SwiftUI
import SwiftData

struct AddSavingView: View {
    @Binding var isPresented: Bool
    
    @Environment(\.modelContext) private var modelContext
    @Environment (\.dismiss) private var dismiss
    
    @Query private var savings: [Saving]
    @Query private var goals: [Goal]
    @State private var amountText: String = ""
    @State private var selectedGoal: String = ""
    @State private var amount: Double = Double()
    @State private var date: Date = Date()
    @FocusState private var keyboardFocused: Bool

    var body: some View {
        NavigationView {
            VStack{
                TextField("", text: $amountText, prompt: Text("SavedAmount")
                    .foregroundColor(Color("TextSecondaryColor").opacity(0.36))) // Bind to the String
                    .foregroundStyle(Color("TextTertiaryColor"))
                    .padding()
                    .background(Color("SecondaryColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: 300, height: 200, alignment: .center)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .focused($keyboardFocused)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            keyboardFocused = true
                        }
                    }
                    .keyboardType(.decimalPad)
                    .onChange(of: amountText) { oldValue, newValue in
                        self.amount = Double(newValue) ?? 0 // Convert the input to Double
                    }

                List{
                    HStack{
                        Image(systemName: "list.bullet.circle")
                        Picker("Select Goal", selection: $selectedGoal) {
                            ForEach(goals, id: \.id) { goal in
                                Text(goal.item).tag(goal.item)
                            }
                        }
                        .onAppear {
                            if selectedGoal == "" {
                                selectedGoal = goals.first?.item ?? ""
                            }
                        }
                    }
                    .foregroundStyle(Color("TextPrimaryColor"))
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(Color("TextSecondaryColor").opacity(0.66))

                    DatePicker(selection: $date, in: ...Date.now, displayedComponents: .date) {
                        HStack{
                            Image(systemName: "calendar.circle")
                            Text("Saved Date")
                        }
                    }
                    .foregroundStyle(Color("TextPrimaryColor"))
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(Color("TextSecondaryColor").opacity(0.66))
                    
                }
                .listStyle(.plain)
                .background(Color.clear)
            }
            .navigationTitle("AddSaving")
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
                        if !amountText.isEmpty {
                            withAnimation{
                                saveSaving()
                                dismiss()
                            }
                        }
                    }.disabled(amountText.isEmpty || selectedGoal.isEmpty)
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
    private func saveSaving() {
        let newSaving = Saving(amount: amount, date: date, goal: selectedGoal)
        modelContext.insert(newSaving)
        try? modelContext.save()
    }

}

#Preview {
    AddSavingView(isPresented: .constant(false))
}
