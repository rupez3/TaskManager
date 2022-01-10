//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by Rupesh Chhetri on 1/9/22.
//

import Foundation
import SwiftUI

class TaskViewModel: ObservableObject {
    
    init() {
        fetchCurrentWeek()
        filterTodayTasks()
    }
    
    @Published var storedTasks: [Task] = [
        Task(taskTitle: "Breakfast", taskDescription: "Have a breakfast", taskDate: Date(timeIntervalSince1970: 1641773243)),
        Task(taskTitle: "Standup", taskDescription: "Have a standup", taskDate: Date(timeIntervalSince1970: 1641772872)),
        Task(taskTitle: "refinement", taskDescription: "Have a refinement", taskDate: Date(timeIntervalSince1970: 1641772772)),
        Task(taskTitle: "Lunch", taskDescription: "Have a lunch", taskDate: Date(timeIntervalSince1970: 1641772772)),
        Task(taskTitle: "ANother meeting", taskDescription: "Have a meeting", taskDate: Date(timeIntervalSince1970: 1641772772)),
        Task(taskTitle: "Eod Calll", taskDescription: "Have a call", taskDate: Date(timeIntervalSince1970: 1641772772)),
    ]
    
    @Published var currentWeek: [Date] = []
    
    @Published var currentDay: Date = Date()
    
    @Published var filteredTasks: [Task]?
    
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
    
    func filterTodayTasks() {
        DispatchQueue.global(qos: .userInteractive).async {
            let calendar = Calendar.current
            let filtered = self.storedTasks.filter {
                return calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
            }
                .sorted { task1, task2 in
                    return task2.taskDate < task1.taskDate
                    
                }
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTasks = filtered
                }
            }
        }
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currnetHour = calendar.component(.hour, from: Date())
        return hour == currnetHour
    }
    
}
