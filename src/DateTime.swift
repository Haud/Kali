/* 

Copyright (c) 2015 Christopher Jones <chris.jones@haud.co>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

import UIKit

// MARK: Initialization

/**
*  An immutable structure for handling date and time values.
*/
public struct DateTime: Comparable
{
    /// The timezone of the date time. This defaults to the device timezone if not specified during initialization.
    public let timezone: TimeZone

    // NSDate value used internally
    fileprivate let internalDate: Date

    // NSCalendarComponents used internally.
    fileprivate let calendarComponents: DateComponents

    /**
    Initializes a new instance of DateTime, with the date set to the current date and time.

    :returns: A new instance of DateTime set to the current time.
    */
    public init()
    {
        self.init(date: Date())
    }

    /**
    Initializes a new instance of DateTime by initializing a time interval from the specified date.

    :param: timeInterval The time interval in seconds to be added to the reference date.
    :param: date         The reference date.
    :param: timezone     The timezone for the DateTime; defaults to the device time zone if unspecified.

    :returns: A new instance of DateTime set to the specified time interval since the input reference date.
    */
    public init(timeInterval: TimeInterval, sinceDate date: Date, inTimezone timezone: TimeZone = TimeZone.current)
    {
        let date = Date(timeInterval: timeInterval, since: date)
        self.init(date: date, timezone: timezone)
    }

    /**
    Attempts to initializes a new DateTime by parsing an input string to the specified format.

    :param: string   The date string to convert.
    :param: format   The date format to be used to convert the date.
    :param: timezone The timezone for the date conversion; defaults to the device time zone if unspecified.

    :returns: If the date string is valid and can be parsed, a new DateTime object; otherwise, this will be nil
    */
    public init?(string: String, format: String, timezone: TimeZone = TimeZone.current)
    {
        let dateFormatter = DateFormatter.sharedFormatter
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timezone

        guard let dateValue = dateFormatter.date(from: string) else {
            return nil
        }
        
        self.init(date: dateValue, timezone: timezone)
    }

    /**
    Attempts to initialize a new instance of DateTime by creating a date object from input month, day, and year. The time component of the DateTime will be set to midnight.

    :param: month    The month for the date.
    :param: day      The day for the date.
    :param: year     The year for the date.
    :param: timezone The timezone for the date; if not specified, this will default to the device timezone.

    :returns: If a DateTime can be initialized with the specified input, a new DateTime object; otherwise this will be nil.
    */
    public init?(month: Month, day: Int, year: Int, timezone: TimeZone = TimeZone.current)
    {
        self.init(month: month, day: day, year: year, hour: 0, minute: 0, second: 0, timezone: timezone)
    }

    /**
      Attempts to initialize a new instance of DateTime by creating a date and time from the specified inputs.

    :param: month    The month for the date.
    :param: day      The day for the date.
    :param: year     The year for the date.
    :param: hour     The hour for the date.
    :param: minute   The minute for the date.
    :param: second   The seconds for the date.
    :param: timezone The timezone for the date; if not specified, this will default to the device timezone.

    :returns: If a DateTime can be initialized with the specified input, a new DateTime object; otherwise this will be nil.
    */
    public init?(month: Month, day: Int, year: Int, hour: Int, minute: Int, second: Int, timezone: TimeZone = TimeZone.current)
    {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = timezone

        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = timezone
        components.month = month.rawValue
        components.day = day
        components.year = year
        components.hour = hour
        components.minute = minute
        components.second = second

        guard let dateValue = calendar.date(from: components) else {
            return nil
        }

        self.init(date: dateValue, timezone: timezone)
    }

    /**
    Initializes a new DateTime object with the specified NSDate and timezone.

    :param: date     The reference date.
    :param: timezone The timezone; if not specified, this will default to the device timezone.

    :returns: A new instance of DateTime.
    */
    public init(date: Date, timezone: TimeZone = TimeZone.current)
    {
        self.internalDate = date
        self.timezone = timezone

        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = timezone

        let calendarUnits = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekday, .weekdayOrdinal, .weekOfMonth, .weekOfYear, .month, .year])
        self.calendarComponents = calendar.dateComponents(calendarUnits, from: self.internalDate)
    }
}

// MARK: - 
// MARK: RawRepresentable
extension DateTime: RawRepresentable
{
    /// The raw type of DateTime.
    public typealias RawType = TimeInterval

    /// The raw value of the DateTime as represented in the number of seconds since 1970.
    public var rawValue: RawType {
        get {
            return self.internalDate.timeIntervalSince1970
        }
    }

    /**
    Initializes a new instance of DateTime with its raw type.

    :param: rawValue The time interval since 1970.

    :returns: A new instance of DateTime; this initialization can be safely force-unwrapped.
    */
    public init?(rawValue: RawType) {
        let date = Date(timeIntervalSince1970: rawValue)
        self.init(date: date)
    }
}

// MARK: -
// MARK: Components
extension DateTime
{
    /// The weekday component of the date.
    public var weekday: Weekday {
        get {
            return Weekday(rawValue: self.calendarComponents.weekday!)!
        }
    }

    /// The month component of the date.
    public var month: Month {
        get {
            return Month(rawValue: self.calendarComponents.month!)!
        }
    }

    /// The day component of the date.
    public var day: Int {
        get {
            return self.calendarComponents.day!
        }
    }

    /// The year component of the date.
    public var year: Int {
        get {
            return self.calendarComponents.year!
        }
    }

    /// The hour component of the date.
    public var hour: Int {
        get {
            return self.calendarComponents.hour!
        }
    }

    /// The minute comopnent of the date.
    public var minute: Int {
        get {
            return self.calendarComponents.minute!
        }
    }

    /// The second component of the date.
    public var second: Int {
        get {
            return self.calendarComponents.second!
        }
    }
}

// MARK: -
// MARK: TimeSpan

extension DateTime
{
    /**
    Adds the input number of seconds to the current DateTime.

    :param: seconds The number of seconds to add.

    :returns: A new DateTime modified by the number of seconds.
    */
    public func add(seconds: Int) -> DateTime
    {
        let timespan = TimeSpan(days: 0, hours: 0, minutes: 0, seconds: seconds)
        return self.add(timespan: timespan)
    }

    /**
    Adds the input number of minutes to the current DateTime.

    :param: minutes The number of minutes to add.

    :returns: A new DateTime modified by the number of minutes.
    */
    public func add(minutes: Int) -> DateTime
    {
        let timespan = TimeSpan(days: 0, hours: 0, minutes: minutes, seconds: 0)
        return self.add(timespan: timespan)
    }

    /**
    Adds the input number of hours to the current DateTime.

    :param: hours The number of hours to add.

    :returns: A new DateTime modified by the number of hours.
    */
    public func add(hours: Int) -> DateTime
    {
        let timespan = TimeSpan(days: 0, hours: hours, minutes: 0, seconds: 0)
        return self.add(timespan: timespan)
    }

    /**
    Adds the input number of days to the current DateTime.

    :param: days The number of days to add.

    :returns: A new DateTime modified by the number of days.
    */
    public func add(days: Int) -> DateTime
    {
        let timespan = TimeSpan(days: days, hours: 0, minutes: 0, seconds: 0)
        return self.add(timespan: timespan)
    }

    /**
    Adds the specified timespan to the current datetime.

    :param: timespan The timespan to add.

    :returns: A new DateTime modified by the timespan.
    */
    public func add(timespan: TimeSpan) -> DateTime
    {
        let newDate = self.internalDate.addingTimeInterval(timespan.timeInterval)
        return DateTime(date: newDate, timezone: self.timezone)
    }

    /**
    Calculates the timespan since the input date.

    :param: datetime The datetime to subtract from the current date.

    :returns: The timespan since the current date.
    */
    public func timespanSince(datetime: DateTime) -> TimeSpan
    {
        let timeInterval = self.internalDate.timeIntervalSince(datetime.internalDate)
        return TimeSpan(timeInterval: timeInterval)
    }
}

// MARK: -
// MARK: String Formatting

extension DateTime: CustomStringConvertible
{
    /**
    Converts the DateTime to a string value with the specified format.

    :param: format The format for the date.

    :returns: The DateTime string value.
    */
    public func stringValue(format: DateTimeStringFormat) -> String
    {
        return self.stringValue(format: format.rawValue)
    }

    /**
    Converts the DateTime to a string value with the specified format.

    :param: format The format for the date.

    :returns: The DateTime string value.
    */
    public func stringValue(format: String) -> String
    {
        let dateFormatter = DateFormatter.sharedFormatter
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = self.timezone

        return dateFormatter.string(from: self.internalDate)
    }

    /// The description of the DateTime; this defaults to DateTimeStringFormat.Full
    public var description: String {
        get {
            return self.stringValue(format: .Full)
        }
    }
}

// MARK: -
// MARK: Comparable & Equatable

/**
Evaluates if the two DateTime values are equal.

:param: left  The first DateTime.
:param: right The second DateTime.

:returns: True if the two input DateTime values are equal; otherwise false.
*/
public func ==(left: DateTime, right: DateTime) -> Bool
{
    return left.rawValue == right.rawValue
}

/**
Evaluates if the first DateTime value is less than the second.

:param: left  The first DateTime.
:param: right The second DateTime.

:returns: True if the first DateTime value is less than the second; otherwise false.
*/
public func <(left: DateTime, right: DateTime) -> Bool
{
    return left.rawValue < right.rawValue
}

/**
Evaluates if the first DateTime value is less than or equal to the second.

:param: left  The first DateTime.
:param: right The second DateTime.

:returns: True if the first DateTime value is less than or equal to the second; otherwise false.
*/
public func <=(left: DateTime, right: DateTime) -> Bool
{
    return left.rawValue <= right.rawValue
}

/**
Evaluates if the first DateTime value is greater than the second.

:param: left  The first DateTime.
:param: right The second DateTime.

:returns: True if the first DateTime value is greater than the second; otherwise false.
*/
public func >(left: DateTime, right: DateTime) -> Bool
{
    return left.rawValue > right.rawValue
}

/**
Evaluates if the first DateTime value is greater than or equal to the second.

:param: left  The first DateTime.
:param: right The second DateTime.

:returns: True if the first DateTime value is greater than or equal to the second; otherwise false.
*/
public func >=(left: DateTime, right: DateTime) -> Bool
{
    return left.rawValue >= right.rawValue
}
