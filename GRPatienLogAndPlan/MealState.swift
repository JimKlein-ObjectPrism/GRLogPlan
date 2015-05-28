//
//  MealState.swift
//  GRPatienLogAndPlan
//
//  Created by James Klein on 5/22/15.
//  Copyright (c) 2015 ObjectPrism Corp. All rights reserved.
//

import Foundation

typealias TimeTuple = (hour: Int, minute: Int)

struct TimeRange {
    var rangeStart: TimeTuple?
    var rangeEnd: TimeTuple?
    
    var timerValue: Int? {
        get{
            var seconds: Int = 0
            if rangeStart != nil && rangeEnd != nil {
                var hours: Int = rangeEnd!.hour - rangeStart!.hour
                
                var minutes = abs(rangeStart!.minute - rangeEnd!.minute)
                seconds = hours * 60 * 60 + minutes * 60
                return seconds
            }
            return nil
        }
    }
    init() {}
    init(rangeStart: TimeTuple?, rangeEnd: TimeTuple?)
    {
        self.rangeStart = rangeStart
        self.rangeEnd = rangeEnd
    }
}
//
//class OPProfile {
//    var breakfast: Bool = true
//    var morningSnack = false
//    var lunch: Bool = true
//    var afternoonSnack = true
//    var dinner: Bool = true
//    var eveningSnack: Bool = true
//    
//}
//class TestProfile {
//    var breakfast: Bool = true
//    var lunch: Bool = true
//    var dinner: Bool = false
//}

enum MealState {
    
    case Breakfast(TimeRange), MorningSnack(TimeRange), Lunch(TimeRange), AfternoonSnack(TimeRange), Dinner(TimeRange), EveningSnack(TimeRange)
    
    
    static var breakfastRange: TimeRange!
    static var morningSnackRange: TimeRange!
    static var lunchRange: TimeRange!
    static var afternoonSnackRange: TimeRange!
    static var dinnerRange: TimeRange!
    static var eveningSnackRange: TimeRange!
    
    static var stateArray: [MealState]!
    
    mutating func next() {
        switch self {
        case let .Breakfast(x):
            if MealState.morningSnackRange.rangeStart == nil {
                self = .Lunch(MealState.lunchRange)
            } else {
                self = MealState.AfternoonSnack(MealState.afternoonSnackRange)
            }
        case .MorningSnack:
            self = .Lunch(MealState.lunchRange)
        case .Lunch:
            self = .AfternoonSnack(MealState.afternoonSnackRange)
        case .AfternoonSnack:
            self = MealState.Breakfast(MealState.dinnerRange)
        case .Dinner:
            if MealState.eveningSnackRange?.rangeStart == nil {
                self = MealState.Breakfast(MealState.breakfastRange)
            } else {
                self = MealState.EveningSnack(MealState.eveningSnackRange!)
            }
        case .EveningSnack:
            self = MealState.Breakfast(MealState.breakfastRange)
        }
    }
    
    func mealName () -> String {
        switch self{
        case .Breakfast:
            return "Breakfast"
        case .MorningSnack:
            return "Morning Snack"
        case .Lunch:
            return "Lunch"
        case .AfternoonSnack:
            return "Afternoon Snack"
        case .Dinner:
            return "Dinner"
        case .EveningSnack:
            return "Evening Snack"
        }
    }
    
    func timeRangeLength () -> Int {
        switch self{
        case .Breakfast:
            return MealState.breakfastRange.timerValue!
        case .MorningSnack:
            return MealState.morningSnackRange.timerValue!
        case .Lunch:
            return MealState.lunchRange.timerValue!
        case .AfternoonSnack:
            return MealState.afternoonSnackRange.timerValue!
        case .Dinner:
            return MealState.dinnerRange.timerValue!
        case .EveningSnack:
            return MealState.eveningSnackRange.timerValue!
        }
    }
    func timeSpanInSecondsFromCurrentTimeToRangeEndingTime( endingTime: TimeTuple) -> Int
    {
        var currentTime: TimeTuple = MealState.covertTimeToTuple(NSDate())
        
        var seconds = 0
        
        var hours: Int = abs(currentTime.hour - endingTime.hour)
        var minutes = abs(currentTime.minute - endingTime.minute)
        
        seconds = hours * 60 * 60 + minutes * 60
        
        return seconds
        
    }
    func timeRemainingInCurrentTimeRange() -> Int {
        switch self{
        case .Breakfast:
            return timeSpanInSecondsFromCurrentTimeToRangeEndingTime(MealState.breakfastRange.rangeEnd!)
        case .MorningSnack:
            return timeSpanInSecondsFromCurrentTimeToRangeEndingTime(MealState.morningSnackRange.rangeEnd!)
        case .Lunch:
            return timeSpanInSecondsFromCurrentTimeToRangeEndingTime(MealState.lunchRange.rangeEnd!)
        case .AfternoonSnack:
            return timeSpanInSecondsFromCurrentTimeToRangeEndingTime(MealState.afternoonSnackRange.rangeEnd!)
        case .Dinner:
            return timeSpanInSecondsFromCurrentTimeToRangeEndingTime(MealState.dinnerRange.rangeEnd!)
        case .EveningSnack:
            return timeSpanInSecondsFromCurrentTimeToRangeEndingTime(MealState.eveningSnackRange.rangeEnd!)
        }
        
    }
    
    
    static func mealTimeState(
        timeOfDay: NSDate,
        timeRange: TimeRange?
        ) -> Bool {
            
            if timeRange == nil {
                return false
            } else {
                //rule is lowerLimit <= timeOfDay < upperLimit
                // refactor these constants out of the function because they will be useed by other cases in the switch statement
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: timeOfDay)
                let hour = components.hour
                let minute = components.minute
                println(timeRange?.rangeEnd?.hour)
                println(timeRange?.rangeEnd?.minute)
                println(timeRange?.rangeStart?.hour)
                println(timeRange?.rangeStart?.minute)
                
                let minHour = timeRange?.rangeStart?.hour
                let minMinute = timeRange?.rangeStart?.minute
                
                let maxHour = timeRange?.rangeEnd?.hour
                let maxMinute = timeRange?.rangeEnd?.minute
                
                var part1 = ( hour >= minHour && minute >= minMinute)
                var test = ((hour < timeRange?.rangeEnd?.hour) || ( hour == timeRange?.rangeEnd?.hour && minute < timeRange?.rangeEnd?.minute))//(hour < timeRange?.rangeEnd?.hour) //|| ( hour < timeRange?.rangeEnd?.hour && minute < timeRange?.rangeEnd?.hour))
                var timeWithinRange: Bool =
                (( hour >= minHour && minute >= minMinute) || (hour > minHour)) &&
                    ((hour < maxHour) || ( hour == maxHour && minute < maxMinute))
                return timeWithinRange
            }
    }
    
    static func covertTimeToTuple(timeOfDay: NSDate) -> TimeTuple {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: timeOfDay)
        let hour = components.hour
        let minute = components.minute
        return TimeTuple(hour: hour, minute: minute)
    }
    
    static func getMealState ( timeOfDay: NSDate) -> MealState
    {
        var time = MealState.covertTimeToTuple(timeOfDay)
        println("time \(timeOfDay) tupple time end: \(MealState.afternoonSnackRange.rangeEnd)")

        switch timeOfDay {
        case let x where mealTimeState(x, timeRange: MealState.breakfastRange):
            return MealState.Breakfast(MealState.breakfastRange)
            
        case let x where mealTimeState(x, timeRange: MealState.morningSnackRange):
            return MealState.MorningSnack(MealState.morningSnackRange)
            
        case let x where mealTimeState(x, timeRange: MealState.lunchRange):
            return MealState.Lunch(MealState.lunchRange)
            
        case let x where mealTimeState(x, timeRange: MealState.afternoonSnackRange):
            return MealState.AfternoonSnack(MealState.afternoonSnackRange)
            
        case let x where mealTimeState(x, timeRange: MealState.dinnerRange):
            return MealState.Dinner(MealState.dinnerRange)
            
        case let x where mealTimeState(x, timeRange: MealState.eveningSnackRange):
            return MealState.EveningSnack(MealState.eveningSnackRange)
        default:
            assert(false, "Out of Bounds error in Meal State")
        }
    }
    
    static func all() -> [MealState] {
        return stateArray
    }
    
    static func setUpMealMenuForProfile( profile: TempProfile) {
        
        var enumArray = [MealState]()
        if profile.morningSnackRequired {
            MealState.breakfastRange = TimeRange(rangeStart: (0,0), rangeEnd: (9,30))
            enumArray.append(MealState.Breakfast(MealState.breakfastRange))
            
            MealState.morningSnackRange = TimeRange(rangeStart: (9,30), rangeEnd: (11,0))
            enumArray.append(MealState.MorningSnack(MealState.morningSnackRange))
        } else {
            MealState.breakfastRange = TimeRange(rangeStart: (0,0), rangeEnd: (11,0))
            enumArray.append(MealState.Breakfast(MealState.breakfastRange))
            MealState.morningSnackRange = TimeRange(rangeStart: nil, rangeEnd: nil)
            //if morning snack not required, don't append to array
        }
        
        MealState.lunchRange = TimeRange(rangeStart: (11,0), rangeEnd: (13,30))
        enumArray.append(MealState.Lunch(MealState.lunchRange))
        
        MealState.afternoonSnackRange = TimeRange(rangeStart: (13,30), rangeEnd: (17,0))
        enumArray.append(MealState.AfternoonSnack(MealState.afternoonSnackRange))

        
        if profile.eveningSnackRequired {
            MealState.dinnerRange = TimeRange(rangeStart: (17,0), rangeEnd: (21,0))
            let dinner = MealState.Dinner(MealState.dinnerRange)
            enumArray.append(dinner)
            
            MealState.eveningSnackRange = TimeRange(rangeStart: (21,0), rangeEnd: (24,0))
            enumArray.append(MealState.EveningSnack(MealState.eveningSnackRange))
        } else {
            MealState.dinnerRange = TimeRange(rangeStart: (17,0), rangeEnd: (24,0))
            enumArray.append(MealState.Dinner(MealState.dinnerRange))
            MealState.eveningSnackRange = TimeRange(rangeStart: nil, rangeEnd: nil)
            //if evening snack not required, don't append to array
        }
//        self.stateArray = enumArray
    }
}
