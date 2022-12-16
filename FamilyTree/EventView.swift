//
//  EventView.swift
//  FamilyTree
//
//  Created by Amini on 08/06/22.
//

import SwiftUI

struct EventView: View {
    
    @State var currentDate: Date = Date()
    @StateObject var eventModel: EventViewModel = EventViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                CustomDatePicker(currentDate: $currentDate)
                EventsView()
                    .padding()
            }
        }
//        .navigationTitle("Bani")
//        .navigationBarHidden(false)
//        .navigationBarTitleDisplayMode(.automatic)
        .onChange(of: eventModel.currentWeek) { newValue in
            eventModel.filterTodayEvents()
        }
    }
    
    func EventCardView(event: Event) -> some View {
        HStack(alignment: .top, spacing: 30) {
            VStack(spacing: 10) {
                Circle()
                    .fill(Color("oldleaves"))
                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                            .stroke(Color("tree"), lineWidth: 1)
                            .padding(-3)
                    )
                Rectangle()
                    .fill(.blue)
                    .frame(width: 3)
            }
            
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(event.eventTitle)
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        
                        Text(event.eventDescription)
                            .font(.callout)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .hLeading()
                    
                    Text(event.eventDate.formatted(date: .omitted, time: .shortened))
                        .font(.callout)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding()
            .hLeading()
            .background(
                Color("tree")
                    .cornerRadius(25)
            )
        }
        .hLeading()
    }
    
    func EventsView() -> some View {
        LazyVStack(spacing: 18) {
            
//            if let events = eventModel.filteredEvent {
//
//                if events.isEmpty {
//                    Text("No Events Found.")
//                        .font(.system(size: 16))
//                        .fontWeight(.light)
//                        .offset(y: 100)
//                }
//                else {
//                    ForEach(events) { event in
//                        EventCardView(event: event)
//                    }
//                }
//            }
//            else {
//                ProgressView()
//                    .offset(y: 100)
//
//            }
            ForEach(eventModel.storedEvent) { event in
                EventCardView(event: event)
            }
        }
    }
}

class EventViewModel: ObservableObject {
    @Published var filteredEvent: [Event]?

    @Published var storedEvent: [Event] = [
        Event(eventTitle: "Family Gathering", eventDescription: "Discuss things", eventDate: .init(timeIntervalSince1970: 1641645497)),
        Event(eventTitle: "Family Gathering", eventDescription: "Discuss things", eventDate: .init(timeIntervalSince1970: 1641645497))
    ]
    
    func filterTodayEvents() {
        
        DispatchQueue.global(qos: .userInteractive).async {
            let calendar = Calendar.current
            
            let filtered = self.storedEvent.filter {
                return calendar.isDate($0.eventDate, inSameDayAs: Date())
            }
            
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredEvent = filtered
                }
            }
        }
    }
    
    @Published var currentWeek: [Date] = []
    
    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (1...7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }
}

struct CustomDatePicker: View {
    @Binding var currentDate: Date
    @State var currentMonth: Int = 3
    
    var body: some View {
        
        VStack(spacing: 35) {
            let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            
            HStack (spacing: 20) {
                
                VStack (alignment: .leading) {
                    Text(extractDateToString()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(extractDateToString()[1])
                        .font(.title.bold())
                }
                
                Spacer(minLength: 0)
                
                Button(action: {
                    withAnimation {
                        currentMonth -= 1
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                Button(action: {
                    withAnimation {
                        currentMonth += 1
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDate()) { value in
                    Text("\(value.day)")
                        .font(.title3.bold())
                }
            }
        }
        .onChange(of: currentMonth) { newValue in
            // updating month..
            currentDate = getCurrentMonth()
        }
        
    }
    
    func extractDateToString() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    func extractDate()-> [DateValue] {
        let calendar = Calendar.current
        // getting current month date ..
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        let firstWeekDay = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekDay - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}

struct Event: Identifiable {
    var id = UUID().uuidString
    var eventTitle: String
    var eventDescription: String
    var eventDate: Date
}

extension Date {
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        var range = calendar.range(of: .day, in: .month, for: startDate)!
        range.removeLast()
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day == 1 ? 0 : day, to: startDate)!
        }
    }
}

extension View {
    
    func hLeading() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView()
    }
}
