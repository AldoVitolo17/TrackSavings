//
//  NewGoalView.swift
//  TrackSavings
//
//  Created by Gustavo Isaac Lopez Nunez on 18/02/24.
//

import SwiftUI

struct NewGoalView: View {
    @Binding var isPresented: Bool
    @Environment(\.dismiss) var dismiss
    @State private var amountString: String = "" // Use a String for user input
    @State private var amount: Double? // Optional to handle non-numeric inputs gracefully
    @FocusState private var keyboardFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack{
                TextField("$0.00", text: $amountString) // Bind to the String
                    .padding()
                    .background(Color("PrimaryColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: 300, height: 200, alignment: .center)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .focused($keyboardFocused)
                    .keyboardType(.numberPad)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            keyboardFocused = true
                        }
                    }
                     .onChange(of: amountString) { newValue in
                         self.amount = Double(newValue) // Convert the input to Double
                    }

                List{
                    Button(action: {
                        
                    }, label: {
                        HStack{
                            Image(systemName: "calendar")
                            Text("Calendar")
                        }
                    })
                    Button(action: {
                        
                    }, label: {
                        HStack{
                            Image(systemName: "bell.fill")
                            Text("Notification")
                        }
                    })
                    Button(action: {
                        
                    }, label: {
                        HStack{
                            Image(systemName: "tag.fill")
                            Text("Tag")
                        }
                    })
                }.listStyle(.plain)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        HStack{
                            Image(systemName:  "chevron.left")
                            Text("Back")
                        }
                    })
                }
                ToolbarItem(placement: .automatic) {
                    Button("Add") {
                        
                    }
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("PrimaryColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)


        }
    }
}

#Preview {
    NewGoalView(isPresented: .constant(false))
}
