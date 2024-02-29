//
//  GoalDetailView.swift
//  TrackSavings
//
//  Created by Gustavo Isaac Lopez Nunez on 20/02/24.
//
import SwiftUI
import SwiftData



struct GoalDetailView: View {
    @State private var addSavingModal = false
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var amountText: String = ""

    @Query private var savingsEntries : [Saving]
    @State private var amount: Double = Double()

    let goal: Goal
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                DynamicQueryView( filterByTitle: goal.item) {(savings: [Saving], totalSavings: Double) in
                    
                    VStack {
                        //Top Icon
                        Text("$\(goal.cost, specifier: "%.2f")")
                            .font(.title)
                            .padding(.top)
                            .bold()
                        Text(LocalizedStringKey("Goal"))
                            .padding(.top, -18)
                            .font(.subheadline)
                            .foregroundStyle(Color.secondary)

                        CircularProgressView(progress: totalSavings/goal.cost, image: goal.image)
                            .frame(width: 150, height: 150) // Adjust size as needed
                        
                        HStack{
                            VStack{
                                Text(LocalizedStringKey("Balance"))
                                    .bold()
                                Text("$\(totalSavings, specifier: "%.2f")")
                            }
                            .padding()
                            Spacer()
                            VStack{
                                Text(LocalizedStringKey("Savings Target"))
                                    .bold()
                                Text("$\(totalSavings, specifier: "%.2f")")
                            }
                            .padding()
                            Spacer()
                            VStack{
                                Text(LocalizedStringKey("Deadline"))
                                    .bold()
                                Text("\(goal.date, formatter: dateFormatter)")
                            }
                            .padding()
                        }
                        
                        //General info of Goal
                        VStack{
                            HStack{
                                TextField("", text: $amountText, prompt: Text("$0,00")
                                    .foregroundColor(Color("TextSecondaryColor").opacity(0.36))) // Bind to the String
                                    .foregroundStyle(Color("TextTertiaryColor"))
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                    .font(.title)
                                    .keyboardType(.decimalPad)
                                    .onChange(of: amountText) { oldValue, newValue in
                                        self.amount = Double(newValue) ?? 0 // Convert the input to Double
                                    }

                                
                                Button(action: { addSavingModal.toggle() }) {
                                    Text("Add Savings")
                                        .bold()
                                        .padding()
                                        .lineLimit(1)
                                        .frame(maxWidth: .infinity)
                                        .background(Color("PrimaryColor"))
                                        .foregroundStyle(Color("TextTertiaryColor"))
                                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                }
                                .padding()
                            }
                            .frame(width: 300, height: 200, alignment: .center)
                            .background(Color("TextSecondaryColor").opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                        }
                        
                        VStack(alignment: .leading) {
                            Divider()
                            Text(LocalizedStringKey("Savings History"))
                                .font(.caption)
                                .foregroundStyle(Color.secondary)
                                .padding(.leading)
                        }
                        
                        ScrollView {
                            ForEach(savings) { saving in
                                HStack(alignment: .center){
                                    Image(systemName: "dollarsign.circle.fill")
                                        .foregroundStyle(Color("PrimaryColor"))
                                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                    
                                    VStack(alignment: .leading){
                                        Text("\(saving.date, formatter: dateFormatter)")
                                        
                                        Text("\(saving.date, formatter: timeFormatter)")
                                            .foregroundStyle(Color.secondary)
                                    }
                                    
                                    Spacer()
                                    Text("£\(saving.amount, specifier: "%.2f")")
                                }
                                .padding(.horizontal)
                            }
                        }
                        //                        .onDelete(perform: deleteSaving)
                        // Delete Goal Button
                        Button("DeleteGoal", role: .destructive){
                            deleteItem(goal: goal)
                            dismiss()
                        }
                        .padding([.bottom, .horizontal])
                    }
                    
                }
                .navigationTitle(goal.item)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarColorScheme(.light, for: .navigationBar)
                .toolbarBackground(Color("PrimaryColor"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .background(Color("BackgroundColor"))
                .navigationBarItems(
                    leading: Button(LocalizedStringKey("Back")) { dismiss() })
            }
        }
        .navigationBarBackButtonHidden(true)
        .padding(.bottom) // If necessary, to avoid clipping on some devices
        .fontDesign(.rounded)
    }
    
    
    private func saveChanges() {
        // Implement save functionality
    }
    
    private func deleteItem(goal: Goal) {
        modelContext.delete(goal)
    }
    
    //    private func deleteSaving(offsets: IndexSet) {
    //        withAnimation {
    //            offsets.map { savings[$0] }.forEach(modelContext.delete)
    //            // Save the context after deletion
    //        }
    //    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
}()


// A helper view to create a consistent layout for detail rows
struct DetailRow: View {
    var label: Text
    var value: String
    
    var body: some View {
        HStack {
            label.padding(.leading)
            Spacer()
            Text(value)
        }
        .padding(.vertical, 4)
    }
}



//MARK: - Query for filtering and calculating savings
public struct DynamicQueryView<T: PersistentModel, Content: View>: View {
    @Query var query: [T]
    let content: ( [T], Double ) -> Content
    
    public var body: some View {
        // Compute total savings here
        let totalSavings = query.reduce(0) { $0 + ($1 as! Saving).amount }
        self.content(query, totalSavings)
    }
    
    public init(descriptor: FetchDescriptor<T>, @ViewBuilder content: @escaping ([T], Double)  -> Content) {
        _query = Query(descriptor)
        self.content = content
    }
}

extension DynamicQueryView where T: Saving {
    init(filterByTitle searchTitle: String, @ViewBuilder content: @escaping ([T], Double)  -> Content) {
        
        let filter = #Predicate<T> { $0.goal.contains(searchTitle) }
        let sort = [SortDescriptor(\T.date)]
        self.init(descriptor: FetchDescriptor(predicate: filter, sortBy: sort), content: content)
    }
}

#Preview {
    ModelPreview{ goal in
        GoalDetailView(goal: goal)
    }
}



