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
    
    @Query private var savingsEntries : [Saving]
    
    let goal: Goal
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                DynamicQueryView( filterByTitle: goal.item) {(savings: [Saving], totalSavings: Double) in
                    
                    VStack(spacing: 20) {
                        //Top Icon
                        Text("$\(totalSavings, specifier: "%.2f")")
                            .font(.title)
                            .padding(.top)
                            .bold()
                        Text("Goal")
                            .padding(.top, -15)
                            .font(.subheadline)
                        
                        CircularProgressView(progress: totalSavings, image: goal.image)
                            .frame(width: 150, height: 250) // Adjust size as needed
                        
                        //General info of Goal
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("General")
                                .font(.caption)
                                .foregroundStyle(Color.secondary)
                                .padding(.leading)
                            
                            DetailRow(label: Text(LocalizedStringKey("TotalCost")), value: String(format: "£%.2f", goal.cost))
                            Divider()
                            
                            DetailRow(label: Text(LocalizedStringKey("TotalSaved")), value: String(format: "£%.2f", totalSavings))
                            Divider()
                            
                        }
                        .padding([.top, .horizontal])
                        
                        // New Saving Button
                        Button(action: { addSavingModal.toggle() }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                                Text("NewSaving")
                                    .foregroundStyle(Color("TextPrimaryColor"))
                            }
                        }                        .fullScreenCover(isPresented: $addSavingModal) {
                            AddSavingView(isPresented: $addSavingModal)
                        }
                        .padding([.horizontal, .top])
                        
                        
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
                        
                    }
                    
                    // Delete Goal Button
                    Button("DeleteGoal", role: .destructive){
                        deleteItem(goal: goal)
                        dismiss()
                    }
                    .padding([.bottom, .horizontal])
                }
                .navigationTitle(goal.item)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarColorScheme(.light, for: .navigationBar)
                .toolbarBackground(Color("PrimaryColor"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .background(Color("BackgroundColor"))
                .navigationBarItems(
                    leading: Button("Done") { dismiss() })
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



