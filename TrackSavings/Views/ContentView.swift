//
//  ContentView.swift
//  TrackSavings
//
//  Created by Aldo Vitolo on 13/02/24.
//
import SwiftData
import SwiftUI

struct ContentView: View {
    @State var totalAmountSaved: Double
    @State private var newGoalModal = false
    @State private var addSavingModal = false
    @Query private var purchases: [Purchase]
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color("PrimaryColor")
                    .ignoresSafeArea(edges: .all)
                VStack {
                    VStack{
                        Text("Total **saved:**")
                        Text("$\(totalAmountSaved, specifier: "%.2f")")
                    }
                    .font(.title)
                    .foregroundStyle(Color("TextPrimaryColor"))
                    .padding()
                    
                    VStack{
                        HStack{
                            Text("My Goals")
                                .font(.title)
                                .foregroundStyle(Color("TextPrimaryColor"))
                                .bold()
                            Spacer()
                            Button(action: { newGoalModal.toggle() }) {
                                Image(systemName: "plus")
                                    .foregroundStyle(Color("TextPrimaryColor"))
                            }
                            .sheet(isPresented: $newGoalModal) {
                                NewGoalView(isPresented: $newGoalModal)
                            }

                        }
                        List(purchases) { purchase in
                            HStack {
                                Text(purchase.item) //This will be changed for the progress circle
                                Text("$\(purchase.cost, specifier: "%.2f")")
                            }
                            .foregroundStyle(Color("TextPrimaryColor"))
                            .listRowBackground(Color.clear)
                            .listRowSeparatorTint(Color("TextPrimaryColor"))
                        }
                        .listStyle(.plain)
                        .background(Color.clear)
                        
                        Button(action: { addSavingModal.toggle() }) {
                            Text("Add Savings")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("PrimaryColor"))
                                .foregroundStyle(Color("TextPrimaryColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        }
                        .sheet(isPresented: $addSavingModal) {
                            AddSavingView(isPresented: $addSavingModal)
                        }
                        .shadow(color: .gray, radius: 2, x: 0.0, y: 2)
                    }
                    .padding()
                    .padding([.bottom,.horizontal], 20)
                    .background(Color("BackgroundColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
                .ignoresSafeArea(edges: .bottom)
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        print("Configuration button was tapped")
                    } label: {
                        Image(systemName: "gear")
                            .foregroundStyle(Color("TextPrimaryColor"))
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(totalAmountSaved: 0)
}
