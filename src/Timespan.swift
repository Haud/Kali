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

/**
*  A span of elapsed time.
*/
public struct TimeSpan
{
    fileprivate static let secondsPerMinute = 60
    fileprivate static let secondsPerHour = 60 * secondsPerMinute
    fileprivate static let secondsPerDay = 24 * secondsPerHour

    /// The raw time interval for the timespan, in seconds.
    public var timeInterval: TimeInterval {
        get {
            var totalSeconds = self.seconds
            totalSeconds += self.minutes * TimeSpan.secondsPerMinute
            totalSeconds += self.hours * TimeSpan.secondsPerHour
            totalSeconds += self.days * TimeSpan.secondsPerDay

            return Double(totalSeconds)
        }
    }

    /// The number of days.
    public let days: Int

    /// The number of hours.
    public let hours: Int

    /// The number of minutes.
    public let minutes: Int

    /// The number of seconds
    public let seconds: Int

    /**
    Initializes a new TimeSpan with the specified number of seconds in the time interval.

    :param: timeInterval The time interval of the timespan, in seconds.

    :returns: A new TimeSpan.
    */
    public init(timeInterval: TimeInterval)
    {
        var totalSecondsInterval = Int(timeInterval)

        let days = (totalSecondsInterval / TimeSpan.secondsPerDay)
        totalSecondsInterval -= (days * TimeSpan.secondsPerDay)

        let hours = (totalSecondsInterval / TimeSpan.secondsPerHour)
        totalSecondsInterval -= (hours * TimeSpan.secondsPerHour)

        let minutes = (totalSecondsInterval / TimeSpan.secondsPerMinute)
        totalSecondsInterval -= (hours * TimeSpan.secondsPerMinute)

        self.days = days
        self.hours = hours
        self.minutes = minutes
        self.seconds = (totalSecondsInterval % 60)
    }

    /**
    Initializes a new TimeSpan with the specified values.

    :param: days    The number of days in the timespan.
    :param: hours   The number of hours in the timespan.
    :param: minutes The number of minutes in the timespan.
    :param: seconds The number of seconds in the timespan.

    :returns: A new TimeSpan.
    */
    public init(days: Int, hours: Int, minutes: Int, seconds: Int)
    {
        self.days = days
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
}

// RawRepresentable implementation.
extension TimeSpan: RawRepresentable
{
    /// The RawValue of TimeSpan.
    public typealias RawValue = TimeInterval

    /**
    Initializes a new instance of TimeSpan by its raw value.

    :param: rawValue The time in seconds.

    :returns: A new TimeSpan. This can be safely force-unwrapped.
    */
    public init?(rawValue: RawValue) {
        self.init(timeInterval: rawValue)
    }

    /// The raw value of the TimeSpan.
    public var rawValue: RawValue {
        get {
            return self.timeInterval
        }
    }
}
