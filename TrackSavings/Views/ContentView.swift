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
                            .frame(width: .infinity, height: 200)
                            .zIndex(-1.0)

                        VStack{
                            Text("Total saved:")
                                .bold()
                            Text("$\(totalAmount, specifier: "%.2f")")
                        }
                        .font(.title)
                        .foregroundStyle(Color("TextPrimaryColor"))
                        .padding()
                    }
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
                            .fullScreenCover(isPresented: $newGoalModal) {
                                NewGoalView(isPresented: $newGoalModal)
                            }

                        }
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
                            Text("Add Savings")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("PrimaryColor"))
                                .foregroundStyle(Color("TextPrimaryColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        }
                        .fullScreenCover(isPresented: $addSavingModal) {
                            AddSavingView(isPresented: $addSavingModal)
                        }
                        .shadow(color: .gray, radius: 2, x: 0.0, y: 2)
                    }
                    .padding()
                    .padding([.bottom,.horizontal], 20)
                    .background(Color("BackgroundColor"))
                    
                }
                .fontDesign(.rounded)
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
