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
    @State private var amount: Double = Double()
    @FocusState private var keyboardFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack{
                TextField("$0,00", value: $amount, format: .number)
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
