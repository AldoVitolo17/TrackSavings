//
//  GoalDetailView.swift
//  TrackSavings
//
//  Created by Gustavo Isaac Lopez Nunez on 20/02/24.
//
import SwiftUI
import SwiftData



struct GoalDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var amountText: String = ""

    @Query private var savingsEntries : [Saving]
    @State private var amount: Double = Double()

    let goal: Goal
    
    var body: some View {
        NavigationView {
            ScrollView {
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

                            SemiCircularProgressView(progress: totalSavings/goal.cost, image: goal.image)
                                .frame(width: 150, height: 150) // Adjust size as needed
                                .padding(.top, 60)

                                HStack{
                                    TextField("", text: $amountText, prompt: Text("$0,00")
                                        .foregroundColor(Color("TextPrimaryColor").opacity(0.36))) // Bind to the String
                                        .foregroundStyle(Color("TextPrimaryColor"))
                                        .font(.title)
                                        .multilineTextAlignment(.center)
                                        .font(.title)
                                        .keyboardType(.decimalPad)
                                        .onChange(of: amountText) { oldValue, newValue in
                                            self.amount = Double(newValue) ?? 0 // Convert the input to Double
                                        }

                                    
                                    Button(action: { saveSaving() }) {
                                        Text("Add Savings")
                                            .bold()
                                            .padding()
                                            .lineLimit(1)
                                            .scaledToFill()
                                            .frame(maxWidth: .infinity)
                                            .background(Color("PrimaryColor"))
                                            .foregroundStyle(Color("TextTertiaryColor"))
                                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                    }
                                    .padding(.horizontal, 8)
                                }
                                .frame(width: 300, height: 70, alignment: .center)
                                .background(Color("TextPrimaryColor").opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
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
                            
                            VStack(alignment: .leading) {
                                Divider()
                                Text(LocalizedStringKey("Savings History"))
                                    .font(.title3)
                                    .foregroundStyle(Color.secondary)
                                    .padding(.leading)
                            }
                            
                            if savings.isEmpty{
                                Text("You have no savings yet")
                                    .font(.caption)
                                    .foregroundStyle(Color.secondary)
                                    .frame(maxHeight: 500,alignment: .center)

                            }
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
                                    Text("$\(saving.amount, specifier: "%.2f")")
                                }
                                .padding(.horizontal)
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
                .onTapGesture {
                    self.hideKeyboard()
                }

            }

        }
        .navigationBarBackButtonHidden(true)
        .padding(.bottom) // If necessary, to avoid clipping on some devices
        .fontDesign(.rounded)
    }
    
    
    //MARK: - private mehods
    private func saveSaving() {
        if !amount.isZero{
            let newSaving = Saving(amount: amount, date: Date(), goal: goal.item)
            modelContext.insert(newSaving)
            try? modelContext.save()
        }
    }
    
    // Function to hide the keyboard
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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



