//
//  TaskModel.swift
//  TaskManager
//
//  Created by Rupesh Chhetri on 1/9/22.
//

import Foundation

struct Task {
    var id: String = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
