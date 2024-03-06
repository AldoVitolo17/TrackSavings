//
//  ContentView.swift
//  TrackSavings
//
//  Created by Aldo Vitolo on 13/02/24.
//
import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var newGoalModal = false
    @State private var addSavingModal = false
    
    @Environment(\.modelContext) private var modelContext
    @Query private var goals: [Goal]
    @Query private var savings: [Saving]
    
    private var totalAmount: Double {
        return savings.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        NavigationStack {
            ZStack{
                Color("BackgroundColor").zIndex(-1.0)
                
                
                VStack {
                    
                    ZStack{
                        Color("PrimaryColor")
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            .ignoresSafeArea(.all)
                            .frame(height: 200)
                            .zIndex(-1.0)

                        VStack{
                            Text("TotalSaved")
                                .bold()
                            Text("$\(totalAmount, specifier: "%.2f")")
                        }
                        .font(.title)
                        .foregroundStyle(Color("TextTertiaryColor"))
                        .padding()
                    }
                    
                    
                    VStack{
                        HStack{
                            Text("MyGoals")
                                .font(.title)
                                .foregroundStyle(Color("TextPrimaryColor"))
                                .bold()
                            Spacer()
                            Button(action: { newGoalModal.toggle() }) {
                                Image(systemName: "plus")
                                    .foregroundStyle(Color("TextPrimaryColor"))
                            }
                            .fullScreenCover(isPresented: $newGoalModal) {
                                NewGoalView(isPresented: $newGoalModal)
                            }

                        }
                        
                        if goals.isEmpty {
                            Text("AddGoalPlaceholder")
                                .frame(maxHeight: 500,alignment: .center)
                                .font(.title3)
                            
                            Button(action: { addSavingModal.toggle() }) {
                                Text("AddSaving")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("TextPrimaryColor").opacity(0.33))
                                    .foregroundStyle(Color("TextTertiaryColor"))
                                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            }
                            .fullScreenCover(isPresented: $addSavingModal) {
                                AddSavingView(isPresented: $addSavingModal)
                            }
                            .disabled(true)


                        } else {
                            List(goals) { goal in
                                NavigationLink(destination: GoalDetailView(goal: goal)) {
                                    HStack {
                                        Image(systemName: goal.image)

                                        Text(goal.item)
                                        Spacer()
                                        Text("$\(goal.cost, specifier: "%.2f")")
                                    }
                                }
                                .foregroundStyle(Color("TextPrimaryColor"))
                                .listRowBackground(Color.clear)
                                .listRowSeparatorTint(Color("TextPrimaryColor"))
                            }
                            .listStyle(.plain)
                            .background(Color.clear)

                            Button(action: { addSavingModal.toggle() }) {
                                Text("AddSaving")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("PrimaryColor"))
                                    .foregroundStyle(Color("TextTertiaryColor"))
                                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            }
                            .fullScreenCover(isPresented: $addSavingModal) {
                                AddSavingView(isPresented: $addSavingModal)
                            }

                        }
                        
                    }
                    .padding()
                    .padding([.bottom,.horizontal], 20)
                    .background(Color("BackgroundColor"))
                    
                }
                .fontDesign(.rounded)
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .onAppear{
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
