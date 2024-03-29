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
    @State private var showToast = false // State to control toast visibility
    @State private var toastMessage = "" // State to hold the toast message
    @Query private var savingsEntries : [Saving]
    @State private var amount: Double = Double()
    @State private var savingsTarget = 0.0
    @State private var showingDeleteAlert = false
    @State var pros: Bool = true
    let ringDiameter = 250.0
    let width = 20.0
    
    let goal: Goal
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                    .zIndex(-1.0)
                DynamicQueryView( filterByTitle: goal.item) {(savings: [Saving], totalSavings: Double) in
                    GeometryReader { geometry in
                        ScrollView(.vertical) {
                            
                            VStack {
                                //Top Icon
                                
                                ZStack {
                                    Path { path in
                                        path.addArc(center: CGPoint(x: ringDiameter / 2, y: ringDiameter / 2),
                                                    radius: CGFloat(ringDiameter / 2),
                                                    startAngle: .degrees(0),
                                                    endAngle: .degrees(180),
                                                    clockwise: true)
                                    }
                                    .stroke(Color(Color.gray.opacity(0.4)), style: StrokeStyle(lineWidth: width, lineCap: .round))
                                    .overlay() {
                                        VStack {
                                            Image(systemName: "\(goal.image)")
                                                .font(.system(size: ringDiameter/3.2, weight: .bold, design:.rounded))
                                                .padding(.top, -20)
                                            
//                                            Text("\((totalSavings/goal.cost)*100, specifier: "%.f")%")
                                            Text("$\(totalSavings, specifier: "%.f")/**$\(goal.cost, specifier: "%.f")**")
                                                .font(.title)
                                        }
                                    }
                                    
                                    Path { path in
                                        path.addArc(center: CGPoint(x: ringDiameter / 2, y: ringDiameter / 2),
                                                    radius: CGFloat(ringDiameter / 2),
                                                    startAngle: .degrees(180),
                                                    endAngle: .degrees(180 - (min(totalSavings/goal.cost, 1.0) * 180)),
                                                    clockwise: true)
                                    }
                                    .stroke(Color("PrimaryColor"),
                                            style: StrokeStyle(lineWidth: width, lineCap: .round)
                                    )
                                    .rotationEffect(Angle(degrees: 180))
                                    .scaleEffect(x: -1, y: 1, anchor: .center)
                                }
                                .frame(width: ringDiameter, height: ringDiameter)
                                .frame(width: 150, height: 130) // Adjust size as needed
                                .padding(.top, 80)
                                
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
                                    
                                    
                                    Button(action: { 
                                        saveSaving()
                                        pros.toggle()
                                        toastMessage = "Saving added correctly"
                                        withAnimation { showToast = true }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            withAnimation { showToast = false }
                                        }})
                                    {
                                        Text("Add Savings")
                                            .bold()
                                            .padding()
                                            .lineLimit(1)
                                            .scaledToFill()
                                            .background(Color("PrimaryColor"))
                                            .foregroundStyle(Color("TextTertiaryColor"))
                                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                    }
                                    .padding(.horizontal, 8)
                                    .disabled(!isAmountValid) // Disable the button if isAmountValid is false
                                }
                                .frame(width: 300, height: 70, alignment: .center)
                                .background(Color("TextPrimaryColor")
                                    .opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                HStack{
                                    VStack{
                                        Text(LocalizedStringKey("Missing"))
                                            .bold()
                                        Text("$\(goal.cost - totalSavings, specifier: "%.2f")")
                                    }
                                    .padding()
                                    
                                    Spacer()
                                    
                                    VStack{
                                        Text(LocalizedStringKey("Savings Target"))
                                            .bold()
                                        Text("$\(savingsTarget, specifier: "%.2f/day")")
                                            .onChange(of: pros) {
                                                savingsTarget = (goal.cost - totalSavings)/Double(calculatePeriods(end: goal.date))
                                            }
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
                                
                                HStack{
                                    Text(LocalizedStringKey("Savings History"))
                                        .font(.subheadline)
                                        .foregroundStyle(Color.secondary)
                                        .padding(.leading)
                                    
                                    Spacer()
                                }
                                .padding(.leading)
                                .padding(.bottom, 8)
                                
                                if savings.isEmpty{
                                    VStack{
                                        Spacer()
                                        Text("You have no savings yet")
                                            .font(.caption)
                                            .foregroundStyle(Color.secondary)
                                            .frame(maxHeight: 500,alignment: .center)
                                        Spacer()
                                    }
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
                                Spacer()
                                // Delete Goal Button
                                
                                Button(action: {
                                    showingDeleteAlert = true
                                }) {
                                    Text("Delete Goal")
                                }
                                .padding()
                                .foregroundStyle(.red)
                                .alert(isPresented: $showingDeleteAlert) {
                                    Alert(title: Text("Confirm Deletion"), message: Text("Are you sure you want to delete this goal?"), primaryButton: .destructive(Text("Delete")) {
                                        deleteGoal()
                                    }, secondaryButton: .cancel())
                                }
                            }
                            .frame(minHeight: geometry.size.height)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .onAppear(perform: {
                        savingsTarget = (goal.cost - totalSavings)/Double(calculatePeriods(end: goal.date))
                    })
                }
                .overlay(showToast ? Toast(message: toastMessage) : nil, alignment: .bottom)
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
        .navigationBarBackButtonHidden(true)
        .padding(.bottom) // If necessary, to avoid clipping on some devices
        .fontDesign(.rounded)
    }
    
    
    //MARK: - private mehods
    func calculatePeriods(end: Date) -> Int {
        let start = Date()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: start, to: end)
                
        if components.day == 0 {
            return 1
        }
        return components.day ?? 0
    }
    
    private func deleteGoal() {
        deleteItem(goal: goal)
        dismiss()
        NotificationManager.instance.deleteGoalNotifications(goal: goal.item)
    }

    private func saveSaving() {
        // Ensure the amountText is valid and not just whitespace
        guard let newAmount = Double(amountText.trimmingCharacters(in: .whitespacesAndNewlines)), !newAmount.isZero else {
            // Handle invalid input or zero amount appropriately
            return
        }
        
        // Fetch savings for the goal to recalculate totalSavings
        let totalSavings = savingsEntries.filter { $0.goal == goal.item }.reduce(0) { $0 + $1.amount }
        
        if totalSavings + newAmount > goal.cost {
            // Notify the user that the saving would exceed the goal's cost
            print("Cannot save more than the goal's target amount.")
            return
        }
        
        let newSaving = Saving(amount: newAmount, date: Date(), goal: goal.item)
        modelContext.insert(newSaving)
        try? modelContext.save()
        
        hideKeyboard()
    }

    private var isAmountValid: Bool {
        guard let newAmount = Double(amountText.trimmingCharacters(in: .whitespacesAndNewlines)), newAmount > 0 else {
            return false
        }
        
        // Assuming you have a way to calculate or access `totalSavings` within this view. If not, you might need to recalculate it here.
        let totalSavings = savingsEntries.filter { $0.goal == goal.item }.reduce(0) { $0 + $1.amount }
        let remaining = goal.cost - totalSavings
        
        return newAmount <= remaining
    }

    
    // Function to hide the keyboard
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
        
    private func deleteItem(goal: Goal) {
        for saving in savingsEntries {
            if saving.goal == goal.id {
                modelContext.delete(saving)
            }
        }
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



