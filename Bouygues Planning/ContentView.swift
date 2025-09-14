//
//  ContentView.swift
//  Bouygues Planning
//
//  Created by Houssam  on 15/04/2024.
//

//import SwiftUI
//
//enum DayStatus: String, CaseIterable {
//    case working, off, holiday, sickLeave
//
//    var color: Color {
//        switch self {
//        case .working:
//            return .clear
//        case .off:
//            return .yellow
//        case .holiday:
//            return .green
//        case .sickLeave:
//            return .pink
//        }
//    }
//
//    var label: String {
//        switch self {
//        case .working: return "Travail"
//        case .off: return "RH"
//        case .holiday: return "CP"
//        case .sickLeave: return "AMAJ"
//        }
//    }
//}
//
//struct Employee {
//    var name: String
//    var selectedDays: [Date: DayStatus] = [:]
//}
//
//struct ContentView: View {
//    @State private var employees: [Employee] = [
//        Employee(name: "Dalila"),
//        Employee(name: "Ouizna"),
//        Employee(name: "Goran"),
//        Employee(name: "Chris"),
//        Employee(name: "Salim"),
//        Employee(name: "Wassim"),
//        Employee(name: "Houssam")
//    ]
//    @State private var currentDayStatus: DayStatus = .working
//    @State private var showScheduleView = false
//    @State private var selectedEmployeeIndex = 0
//    @State private var selectedYear = Calendar.current.component(.year, from: Date())
//    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
//    private let years = [2023, 2024, 2025]
//    private let months = Calendar.current.monthSymbols
//
//    var body: some View {
//        NavigationSplitView {
//            Form {
//                Section {
//                    Picker("Mois", selection: $selectedMonth) {
//                        ForEach(1...months.count, id: \.self) { index in
//                            Text(months[index - 1])
//                                .tag(index)
//                        }
//                    }
//                    Picker("Année", selection: $selectedYear) {
//                        ForEach(years, id: \.self) { year in
//                            Text("\(year)")
//                                .tag(year)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//                }
//
//                Section {
//                    Picker("Collègue", selection: $selectedEmployeeIndex) {
//                        ForEach(employees.indices, id: \.self) { index in
//                            Text(employees[index].name)
//                                .tag(index)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//
//                    Picker("Statut", selection: $currentDayStatus) {
//                        ForEach(DayStatus.allCases, id: \.self) { status in
//                            Text(status.label)
//                                .tag(status)
//                        }
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                }
//
//                Section(header: Text("Planning")) {
//                    ForEach(currentMonthDays(), id: \.self) { day in
//                        let isSelected = employees[selectedEmployeeIndex].selectedDays.keys.contains(day)
//                        MultipleSelectionRow(title: dayLabelFor(day: day), isSelected: isSelected, color: employees[selectedEmployeeIndex].selectedDays[day]?.color ?? .clear) {
//                            if let status = employees[selectedEmployeeIndex].selectedDays[day], status == currentDayStatus {
//                                employees[selectedEmployeeIndex].selectedDays.removeValue(forKey: day)
//                            } else {
//                                employees[selectedEmployeeIndex].selectedDays[day] = currentDayStatus
//                            }
//                        }
//                    }
//                }
//
//                Button("Générer le Planning") {
//                    showScheduleView = true
//                }
//            }
//            .navigationTitle("Planning Team Bourbier")
//
//        } detail: {
//            if showScheduleView {
//                ScheduleView(employees: employees, days: currentMonthDays())
//            }
//        }
//    }
//
//    private func dayLabelFor(day: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "fr_FR")
//        dateFormatter.dateFormat = "EEEE dd/MM"
//        return dateFormatter.string(from: day).capitalized
//    }
//
//    private func currentMonthDays() -> [Date] {
//        var dates = [Date]()
//        let calendar = Calendar.current
//        var dateComponents = DateComponents()
//        dateComponents.year = selectedYear
//        dateComponents.month = selectedMonth
//        let startDate = calendar.date(from: dateComponents)!
//        let range = calendar.range(of: .day, in: .month, for: startDate)!
//
//        for day in range {
//            if let date = calendar.date(byAdding: .day, value: day - 1, to: startDate) {
//                dates.append(date)
//            }
//        }
//        return dates
//    }
//}
//
//struct MultipleSelectionRow: View {
//    var title: String
//    var isSelected: Bool
//    var color: Color
//    var action: () -> Void
//
//    var body: some View {
//        HStack {
//            Text(title)
//            Spacer()
//            if isSelected {
//                Image(systemName: "checkmark")
//            }
//        }
//        .onTapGesture {
//            action()
//        }
//        .background(color)
//        .cornerRadius(5)
//    }
//}
//
//struct ScheduleView: View {
//    var employees: [Employee]
//    let days: [Date]
//
//    private func generateWeeklySchedule(for employee: Employee) -> [ScheduleDay] {
//        let fixedSchedule: [String: (start: String, end: String)] = [
//            "Dalila": ("10:00", "18:00"),
//            "Chris": ("11:30", "20:00"),
//            "Goran": ("CadO Matin", "CadO Après-Midi") // Remarque: Vous devez adapter cette partie pour gérer correctement ce cas spécifique
//        ]
//
//        let possibleStartTimes = ["9:30", "10:00", "11:00", "11:30", "12:00"]
//        let dayDuration = 8 // Durée de travail standard en heures
//
//        return days.map { day -> ScheduleDay in
//            let status = employee.selectedDays[day] ?? .off
//            var hours: (start: String, end: String)? = nil
//
//            if status == .working {
//                if let fixedHours = fixedSchedule[employee.name] {
//                    hours = fixedHours
//                } else {
//                    if let startTimeString = possibleStartTimes.randomElement(),
//                       let startTime = timeFromString(startTimeString),
//                       let endTime = Calendar.current.date(byAdding: .hour, value: dayDuration, to: startTime) {
//                        let endTimeString = stringFromTime(endTime)
//                        hours = (startTimeString, endTimeString)
//                    }
//                }
//            }
//
//            return ScheduleDay(date: day, hours: hours, isWorkingDay: status == .working, status: status)
//        }
//    }
//
//    var body: some View {
//        ScrollView(.vertical) {
//            ScrollView(.horizontal) {
//                LazyHGrid(rows: [GridItem(.flexible())], spacing: 20) {
//                    ForEach(employees, id: \.name) { employee in
//                        VStack(alignment: .leading) {
//                            Text(employee.name)
//                                .font(.headline)
//                                .padding(.bottom, 5)
//
//                            ForEach(generateWeeklySchedule(for: employee), id: \.date) { scheduleDay in
//                                HStack {
//                                    Text(dayLabelFor(day: scheduleDay.date))
//                                        .font(.subheadline)
//                                    Spacer()
//                                    if let hours = scheduleDay.hours {
//                                        Text("\(hours.start) - \(hours.end)")
//                                            .font(.subheadline)
//                                    } else {
//                                        Text(scheduleDay.status.label)
//                                            .font(.subheadline)
//                                    }
//                                }
//                                .padding(8)
//                                .background(scheduleDay.status.color)
//                                .cornerRadius(5)
//                                .padding(.bottom, 5)
//                            }
//                        }
//                    }
//                }
//                .padding()
//            }
//        }
//        .navigationTitle("Planning Généré")
//    }
//
//    private func dayLabelFor(day: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "fr_FR")
//        dateFormatter.dateFormat = "EEEE dd/MM"
//        return dateFormatter.string(from: day).capitalized
//    }
//}
//
//struct ScheduleDay {
//    let date: Date
//    var hours: (start: String, end: String)?
//    var isWorkingDay: Bool
//    var status: DayStatus
//}
//
//func timeFromString(_ timeString: String) -> Date? {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "H:mm"
//    return dateFormatter.date(from: timeString)
//}
//
//func stringFromTime(_ time: Date) -> String {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "H:mm"
//    return dateFormatter.string(from: time)
//}
//
//#Preview {
//    ContentView()
//}

import SwiftUI

enum DayStatus: String, CaseIterable {
    case working, off, holiday, sickLeave, ltpa
    
    var color: Color {
        switch self {
        case .working:
            return .clear
        case .off:
            return .yellow
        case .holiday:
            return .green
        case .sickLeave:
            return .pink
        case .ltpa:
            return .blue
        }
    }
    
    var label: String {
        switch self {
        case .working: return "Travail"
        case .off: return "RH"
        case .holiday: return "CP"
        case .sickLeave: return "AMAJ"
        case .ltpa: return "LTPA"
        }
    }
}

struct Employee {
    var name: String
    var selectedDays: [Date: DayStatus] = [:]
}

struct ContentView: View {
    @State private var employees: [Employee] = [
        Employee(name: "Dalila"),
        Employee(name: "Lathe"),
        Employee(name: "Joel"),
        Employee(name: "Chris"),
        Employee(name: "Salim"),
        Employee(name: "Salah"),
        Employee(name: "Houssam")
    ]
    @State private var currentDayStatus: DayStatus = .working
    @State private var showScheduleView = false
    @State private var selectedEmployeeIndex = 0
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedDate = Date()
    @State private var selectedFilter: FilterType = .month
    private let years = [2024, 2025, 2026]
    private let months = Calendar.current.monthSymbols

    var body: some View {
        NavigationSplitView {
            Form {
                Section {
                    Picker("Filtrer par", selection: $selectedFilter) {
                        Text("Mois").tag(FilterType.month)
                        Text("Semaine").tag(FilterType.week)
                        Text("Jour").tag(FilterType.day)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if selectedFilter == .month {
                        Picker("Mois", selection: $selectedMonth) {
                            ForEach(1...months.count, id: \.self) { index in
                                Text(months[index - 1])
                                    .tag(index)
                            }
                        }
                        Picker("Année", selection: $selectedYear) {
                            ForEach(years, id: \.self) { year in
                                Text("\(year)")
                                    .tag(year)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    } else if selectedFilter == .week {
                        DatePicker("Sélectionner une semaine", selection: $selectedDate, displayedComponents: [.date])
                    } else if selectedFilter == .day {
                        DatePicker("Sélectionner une date", selection: $selectedDate, displayedComponents: [.date])
                    }
                }

                Section {
                    Picker("Collègue", selection: $selectedEmployeeIndex) {
                        ForEach(employees.indices, id: \.self) { index in
                            Text(employees[index].name)
                                .tag(index)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    Picker("Statut", selection: $currentDayStatus) {
                        ForEach(DayStatus.allCases, id: \.self) { status in
                            Text(status.label)
                                .tag(status)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Planning")) {
                    ForEach(currentDays(), id: \.self) { day in
                        let isSelected = employees[selectedEmployeeIndex].selectedDays.keys.contains(day)
                        MultipleSelectionRow(title: dayLabelFor(day: day), isSelected: isSelected, color: employees[selectedEmployeeIndex].selectedDays[day]?.color ?? .clear) {
                            if let status = employees[selectedEmployeeIndex].selectedDays[day], status == currentDayStatus {
                                employees[selectedEmployeeIndex].selectedDays.removeValue(forKey: day)
                            } else {
                                employees[selectedEmployeeIndex].selectedDays[day] = currentDayStatus
                            }
                        }
                    }
                }

                Button("Générer le Planning") {
                    showScheduleView = true
                }
            }
            .navigationTitle("Planning Team Bourbier")
          
        } detail: {
            if showScheduleView {
                ScheduleView(employees: employees, days: currentDays())
            }
        }
    }

    private func dayLabelFor(day: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "EEEE dd/MM"
        return dateFormatter.string(from: day).capitalized
    }

    private func currentDays() -> [Date] {
        var dates = [Date]()
        let calendar = Calendar.current
        switch selectedFilter {
            case .month:
                var dateComponents = DateComponents()
                dateComponents.year = selectedYear
                dateComponents.month = selectedMonth
                let startDate = calendar.date(from: dateComponents)!
                let range = calendar.range(of: .day, in: .month, for: startDate)!
                
                for day in range {
                    if let date = calendar.date(byAdding: .day, value: day - 1, to: startDate) {
                        dates.append(date)
                    }
                }
            case .week:
                dates = calendar.generateDates(forWeekContaining: selectedDate)
            case .day:
                dates.append(selectedDate)
        }
        return dates
    }
}

enum FilterType {
    case month, week, day
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var color: Color
    var action: () -> Void

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
            }
        }
        .onTapGesture {
            action()
        }
        .background(color)
        .cornerRadius(5)
    }
}

struct ScheduleView: View {
    var employees: [Employee]
    let days: [Date]
    
    private func generateWeeklySchedule(for employee: Employee) -> [ScheduleDay] {
        if employee.name == "Salim" {
            return generateScheduleForSalim(for: employee)
        }
        let fixedSchedule: [String: (start: String, end: String)] = [
            "Joel": ("CadO Matin", "CadF Après-Midi") // Remarque: Vous devez adapter cette partie pour gérer correctement ce cas spécifique
        ]
        
        let possibleStartTimes = ["9:30", "10:00", "11:00", "11:30", "12:00"]
        let dayDuration = 8 // Durée de travail standard en heures

        return days.map { day -> ScheduleDay in
            let status = employee.selectedDays[day] ?? .off
            var hours: (start: String, end: String)? = nil

            if status == .working {
                if let fixedHours = fixedSchedule[employee.name] {
                    hours = fixedHours
                } else {
                    if let startTimeString = possibleStartTimes.randomElement(),
                       let startTime = timeFromString(startTimeString),
                       let endTime = Calendar.current.date(byAdding: .hour, value: dayDuration, to: startTime) {
                        let endTimeString = stringFromTime(endTime)
                        hours = (startTimeString, endTimeString)
                    }
                }
            }
            
            return ScheduleDay(date: day, hours: hours, isWorkingDay: status == .working, status: status)
        }
    }

    private func generateScheduleForSalim(for employee: Employee) -> [ScheduleDay] {
        let calendar = Calendar.current
        let possibleStartTimes = ["9:30", "10:00", "11:00", "11:30", "12:00"]
        let dailyMinutes = 390 // 6h30 = 390 minutes pour totaliser 26h sur 4 jours

        return days.map { day -> ScheduleDay in
            let weekday = calendar.component(.weekday, from: day) // 1=dimanche ... 6=vendredi, 7=samedi

            // Vendredi: toujours LTPA, on ignore toute sélection manuelle pour ce jour
            if weekday == 6 {
                return ScheduleDay(date: day, hours: nil, isWorkingDay: false, status: .ltpa)
            }

            // Comportement identique aux autres jours: l'utilisateur sélectionne le statut
            let status = employee.selectedDays[day] ?? .off

            // Si jour travaillé sélectionné → calcul d'horaires automatiques sur 6h30
            if status == .working {
                if let startTimeString = possibleStartTimes.randomElement(),
                   let startTime = timeFromString(startTimeString),
                   let endTime = calendar.date(byAdding: .minute, value: dailyMinutes, to: startTime) {
                    let endTimeString = stringFromTime(endTime)
                    return ScheduleDay(date: day, hours: (start: startTimeString, end: endTimeString), isWorkingDay: true, status: .working)
                } else {
                    // fallback
                    return ScheduleDay(date: day, hours: (start: "10:00", end: "16:30"), isWorkingDay: true, status: .working)
                }
            }

            // Sinon: pas d'horaires, on affiche le label du statut sélectionné (RH/CP/AMAJ/LTPA/off)
            return ScheduleDay(date: day, hours: nil, isWorkingDay: false, status: status)
        }
    }

    var body: some View {
        ScrollView(.vertical) {
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 20) {
                    ForEach(employees, id: \.name) { employee in
                        VStack(alignment: .leading) {
                            Text(employee.name)
                                .font(.headline)
                                .padding(.bottom, 5)
                            
                            ForEach(generateWeeklySchedule(for: employee), id: \.date) { scheduleDay in
                                HStack {
                                    Text(dayLabelFor(day: scheduleDay.date))
                                        .font(.subheadline)
                                    Spacer()
                                    if let hours = scheduleDay.hours {
                                        Text("\(hours.start) - \(hours.end)")
                                            .font(.subheadline)
                                    } else {
                                        Text(scheduleDay.status.label)
                                            .font(.subheadline)
                                    }
                                }
                                .padding(8)
                                .background(scheduleDay.status.color)
                                .cornerRadius(5)
                                .padding(.bottom, 5)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Planning Généré")
    }
    
    private func dayLabelFor(day: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "EEEE dd/MM"
        return dateFormatter.string(from: day).capitalized
    }
}

struct ScheduleDay {
    let date: Date
    var hours: (start: String, end: String)?
    var isWorkingDay: Bool
    var status: DayStatus
}

func timeFromString(_ timeString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "H:mm"
    return dateFormatter.date(from: timeString)
}

func stringFromTime(_ time: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "H:mm"
    return dateFormatter.string(from: time)
}

extension Calendar {
    func generateDates(forWeekContaining date: Date) -> [Date] {
        var dates: [Date] = []
        guard let startOfWeek = self.date(from: self.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)),
              let endOfWeek = self.date(byAdding: .day, value: 6, to: startOfWeek) else {
            return dates
        }
        
        var currentDate = startOfWeek
        while currentDate <= endOfWeek {
            dates.append(currentDate)
            guard let nextDate = self.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        return dates
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
