//
//  ContentView.swift
//  TrackSavings
//
//  Created by Aldo Vitolo on 13/02/24.
//
import SwiftData
import SwiftUI


//Struct for dummy data purposes
//private struct Goal: Identifiable {
//    let id = UUID() // Using ObjectIdentifier to generate a unique ID
//    let name: String
//    let tag: String
//    var date: Date
//    var goalAmount: Double
//    var savedAmount: Double
//    var notificationType: Int
//}

//Dummy data for testing purposes
//private let Goals: [Goal] = [
//    Goal(name: "Buy a new laptop", tag: "Electronics", date: Date(), goalAmount: 1500.0, savedAmount: 0.0, notificationType: 1),
//    Goal(name: "Take a vacation to Hawaii", tag: "Travel", date: Date(), goalAmount: 5000.0, savedAmount: 2000.0, notificationType: 2),
//    Goal(name: "Purchase a new car", tag: "Automobile", date: Date(), goalAmount: 30000.0, savedAmount: 10000.0, notificationType: 3)
//]

struct ContentView: View {
    @State var totalAmountSaved: Double
    @State private var addNewModalView = false
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
                    .padding()
                    
                    VStack{
                        Text("My Goals")
                            .font(.title)
                            .bold()
                        List(purchases) { purchase in
                            HStack {
                                Text(purchase.item) //This will be changed for the progress circle
                                Text("$\(purchase.cost)")
                            }
                        }
                        .listStyle(.plain)
                        .background(Color.clear)
                        Button(action: {                            addNewModalView.toggle()
                        }) {
                            Text("Add Goal")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("PrimaryColor"))
                                .foregroundColor(.primary) // Use foregroundColor for text color
                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        }
                        .sheet(isPresented: $addNewModalView) {
                            NewGoalView(isPresented: $addNewModalView)
                        }
                        .shadow(color: .gray, radius: 2, x: 0.0, y: 2)
                    }
                    .padding()
                    .padding([.bottom,.horizontal], 20)
                    .background(Color("BackgroundColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))                }
                .ignoresSafeArea(edges: .bottom)
                
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        print("Configuration button was tapped")
                    } label: {
                        Image(systemName: "gear")
                            .foregroundStyle(Color.primary)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(totalAmountSaved: 0)
}
