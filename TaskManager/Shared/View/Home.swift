//
//  Home.swift
//  TaskManager
//
//  Created by Rupesh Chhetri on 1/9/22.
//

import SwiftUI

struct Home: View {
    
    @StateObject var taskViewModel: TaskViewModel = TaskViewModel()
    
    @Namespace var animation
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    //current week
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(taskViewModel.currentWeek, id: \.self) { day in
                                VStack(spacing: 10) {
                                    Text(taskViewModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                    Text(taskViewModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(taskViewModel.isToday(date: day) ? 1 : 0)
                                }
                                .foregroundStyle(taskViewModel.isToday(date: day) ? .primary : .tertiary)
                                .foregroundColor(taskViewModel.isToday(date: day) ? .white : .black)
                                .frame(width: 45, height: 90)
                                .background(
                                    ZStack {
                                        //
                                        // geometry effect
                                        if taskViewModel.isToday(date: day) {
                                            Capsule()
                                                .fill(.black)
                                                .matchedGeometryEffect(id: "currentday", in: animation)
                                        }
                                    }
                                    
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation {
                                        taskViewModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    taskView()
                } header: {
                    headerView()
                    
                }
                
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
    
    // MARK: Header
    func headerView() -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                Text("Today")
                    .font(.largeTitle)
            }
            .hLeading()
            
            Button {
                
            } label: {
                Image("pic2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
            
            
        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color.white)
    }
    
    func taskView() -> some View {
        LazyVStack(spacing: 20) {
            if let tasks = taskViewModel.filteredTasks {
                if tasks.isEmpty {
                    Text("No task for the day")
                        .font(.system(size: 14))
                        .fontWeight(.light)
                        .offset(y: 100)
                } else {
                    ForEach(tasks, id: \.id) { task in
                        taskCardView(task: task)
                    }
                }
            } else {
                ProgressView()
                    .offset(y: 100)
            }
        }
        .padding()
        .padding(.top)
        .onChange(of: taskViewModel.currentDay) { newValue in
            taskViewModel.filterTodayTasks()
        }
    }
    
    func taskCardView(task: Task) -> some View {
        HStack(alignment: .top, spacing: 30) {
            VStack(spacing: 10) {
                Circle()
                    .fill(taskViewModel.isCurrentHour(date: task.taskDate) ? .black : .clear)
                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                            .stroke(.black, lineWidth: 1)
                            .padding(-3)
                    )
                    .scaleEffect(!taskViewModel.isCurrentHour(date: task.taskDate) ? 0.8 : 1)
                Rectangle()
                    .fill(.black)
                    .frame(width: 3)
            }
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.taskTitle)
                            .font(.title2.bold())
                        Text(task.taskDescription)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    Text(task.taskDate.formatted(date: .omitted, time: .shortened))
                }
                
                if taskViewModel.isCurrentHour(date: task.taskDate) {
                    HStack(spacing: 0) {
                        HStack(spacing: -10) {
                            ForEach(["User1","User11","User12","User13"], id: \.self) { user in
                                Image(user)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                background(
                                    Circle()
                                        .stroke(.black, lineWidth: 5)
                                )
                            }
                        }
                        .hLeading()
                        //
                        Button {
                            
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.black)
                                .padding(10)
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                        }
                        
                    }
                    .padding(.top)
                }
                
            }
            .foregroundColor(taskViewModel.isCurrentHour(date: task.taskDate) ? .white : .black)
            .padding(taskViewModel.isCurrentHour(date: task.taskDate) ? 15 : 0)
            .padding(.bottom, taskViewModel.isCurrentHour(date: task.taskDate) ? 0 : 10)
            .hLeading()
            .background(
                Color.black
                    .cornerRadius(25)
                        .opacity(taskViewModel.isCurrentHour(date: task.taskDate) ? 1 : 0)
                )
        }
        .hLeading()
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

extension View {
    
    func hLeading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
        
    }
    
}
