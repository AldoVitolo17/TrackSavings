//
//  NewGoalView.swift
//  TrackSavings
//
//  Created by Gustavo Isaac Lopez Nunez on 18/02/24.
//
import SwiftData
import SwiftUI

struct NewGoalView: View {
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var modelContext
    @Environment (\.dismiss) private var dismiss
    @Query private var purchases: [Purchase]
    @State private var item: String = ""
    @State private var image: String = ""
    @State private var costText: String = ""
    @State private var cost: Double = Double()
    @State private var savings: Double = Double()
    @State private var date: Date = Date()
    @State private var notificationType: Int = 0
    //@State private var amount: Double = Double()
    @FocusState private var keyboardFocused: Bool
    
    
    
    var body: some View {
        NavigationView {
            VStack{
                TextField("", text: $costText, prompt: Text("Goal Amount").foregroundColor(Color("TextSecondaryColor").opacity(0.36))) // Bind to the String
                    .foregroundStyle(Color("TextPrimaryColor"))
                    .padding()
                    .background(Color("PrimaryColor"))
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
                    .onChange(of: costText) { newValue in
                        self.cost = Double(newValue) ?? 0 // Convert the input to Double
                    }

                List{
                    HStack{
                        Image(systemName: "target")
                        TextField("", text: $item, prompt: Text("Goal Name").foregroundColor(Color("TextSecondaryColor").opacity(0.36)))
                    }
                    .foregroundStyle(Color("TextPrimaryColor"))
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(Color("TextSecondaryColor").opacity(0.66))
                    
                    Button(action: {
                        
                    }, label: {
                        DatePicker(selection: $date, in: Date.now..., displayedComponents: .date) {
                            HStack{
                                Image(systemName: "calendar")
                                Text("Calendar")
                            }
                        }
                    })
                    .foregroundStyle(Color("TextPrimaryColor"))
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(Color("TextSecondaryColor").opacity(0.66))
                    
                    Button(action: {
                        
                    }, label: {
                        HStack{
                            Image(systemName: "bell.fill")
                            Text("Reminder")
                            Spacer()
                            Picker("", selection: $notificationType) {
                                Text("Daily")
                                Text("Weekly")
                                Text("Monthly")
                            }
                        }
                    })
                    .foregroundStyle(Color("TextPrimaryColor"))
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(Color("TextSecondaryColor").opacity(0.66))
                    
                    Button(action: {
                        
                    }, label: {
                        HStack{
                            Image(systemName: "tag.fill")
                            Text("Tag")
                            Spacer()
                            Picker("", selection: $image) {
                                Image(systemName: "car")
                                Image(systemName: "phone")
                                Image(systemName: "car")
                            }

                        }
                    })
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
                        if !item.isEmpty {
                            withAnimation{
                                savePurchase()
                                dismiss()
                            }
                        }
                    }.disabled(item.isEmpty)
                }

            }
            .toolbarColorScheme(.light, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("PrimaryColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .background(Color("BackgroundColor"))
            
        }
    }
    
    
    //MARK: - private mehods
    private func savePurchase() {
        let newPurchase = Purchase(item: item, image: image, cost: cost, savings: cost, date: date)
        modelContext.insert(newPurchase)
        try? modelContext.save()
    }
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
}

#Preview {
    NewGoalView(isPresented: .constant(false))
}
