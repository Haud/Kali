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

import Quick
import Nimble
import DateTime

class DateTimeTests: QuickSpec
{
    override func spec()
    {
        let utcTimezone = NSTimeZone(forSecondsFromGMT: 0)
        let dateString = "October 13, 2001 17:23:42 +00:00"
        let dateFormat = "MMMM dd, yyyy HH:mm:ss z"

        describe("The datetime initialization") {
            it("Initializes from a valid date string and format.") {

                let datetime = DateTime(string: dateString, format: dateFormat)
                expect(datetime).toNot(beNil())
            }

            it ("does not intialize when given an invalid date string and format.") {
                let datetime = DateTime(string: "This is a date string", format: dateFormat)
                expect(datetime).to(beNil())
            }

            it ("can initialize with individual month, day, and year values") {
                let month = Month.January
                let day = 25
                let year = 1985

                let datetime = DateTime(month: month, day: day, year: year)

                expect(datetime?.month).to(equal(month))
                expect(datetime?.day).to(equal(day))
                expect(datetime?.year).to(equal(year))
            }
        }

        describe("DateTime equality") {
            it ("properly determines when two DateTimes are equal") {
                let leftDateTime = DateTime(string: dateString, format: dateFormat)
                let rightDateTime = DateTime(string: dateString, format: dateFormat)

                expect(leftDateTime).to(equal(rightDateTime))
            }

            it ("determines when two DateTimes are unequal") {
                let leftDateTime = DateTime(string: dateString, format: dateFormat)
                let rightDateTime = DateTime()

                expect(leftDateTime).toNot(equal(rightDateTime))
            }
        }

        describe("DateTime components") {
            it ("returns the correct month") {
                let datetime = DateTime(string: dateString, format: dateFormat, timezone: utcTimezone)
                let month = datetime?.month

                expect(month?.rawValue).to(equal(10))
            }

            it ("returns the correct weekday") {
                let expectedDayOfWeek = Weekday.Saturday // October 13, 2001 was a Saturday

                let datetime = DateTime(string: dateString, format: dateFormat, timezone: utcTimezone)

                expect(datetime?.weekday).to(equal(expectedDayOfWeek))
            }

            it ("returns the correct day") {
                let datetime = DateTime(string: dateString, format: dateFormat, timezone: utcTimezone)
                expect(datetime?.day).to(equal(13))
            }

            it ("accounts for timezones when returning the day value") {
                let datetime = DateTime(string: dateString, format: dateFormat, timezone: NSTimeZone(forSecondsFromGMT: 43200))
                expect(datetime?.day).to(equal(14))
            }

            it ("returns the correct year") {
                let datetime = DateTime(string: dateString, format: dateFormat)
                expect(datetime?.year).to(equal(2001))
            }

            it ("returns the correct hour") {
                let datetime = DateTime(string: dateString, format: dateFormat, timezone: utcTimezone)
                expect(datetime?.hour).to(equal(17))
            }

            it ("returns the correct hour in the proper timezone") {
                let datetime = DateTime(string: dateString, format: dateFormat, timezone: NSTimeZone(forSecondsFromGMT: 18000))
                expect(datetime?.hour).to(equal(22))
            }

            it ("returns the correct minute") {
                let datetime = DateTime(string: dateString, format: dateFormat, timezone: utcTimezone)
                expect(datetime?.minute).to(equal(23))
            }

            it ("returns the correct second") {
                let datetime = DateTime(string: dateString, format: dateFormat, timezone: utcTimezone)
                expect(datetime?.second).to(equal(42))
            }
        }

        describe("DateTime modifications") {
            it ("creates a new DateTime by adding seconds") {
                let datetime = DateTime(string: dateString, format: dateFormat, timezone: utcTimezone)!
                let secondsComponent = datetime.second
                let secondsToAdd = 10

                let newDateTime = datetime.addSeconds(secondsToAdd)
                expect(newDateTime.second).to(equal(secondsComponent + secondsToAdd))
            }

            it ("creates a new DateTime by adding minutes") {
                let datetime = DateTime(string: dateString, format: dateFormat, timezone: utcTimezone)!
                let minutesComponent = datetime.minute
                let minutesToAdd = 10

                let newDateTime = datetime.addMinutes(minutesToAdd)
                expect(newDateTime.minute).to(equal(minutesComponent + minutesToAdd))
            }

            it ("creates a new DateTime by adding hours") {
                let datetime = DateTime(string: dateString, format: dateFormat, timezone: utcTimezone)!
                let hoursComponent = datetime.hour
                let hoursToAdd = 3

                let newDateTime = datetime.addHours(hoursToAdd)
                expect(newDateTime.hour).to(equal(hoursComponent + hoursToAdd))
            }

            it ("creates a new DateTime by adding days") {
                let datetime = DateTime(string: dateString, format: dateFormat, timezone: utcTimezone)!
                let daysComponent = datetime.day
                let daysToAdd = 15

                let newDateTime = datetime.addDays(daysToAdd)
                expect(newDateTime.day).to(equal(daysComponent + daysToAdd))
            }

            it ("generates a timespan by subtracting a second date") {
                let secondsDifference = 5
                let minutesDifference = 45
                let hoursDifference = 8
                let daysDifference = 2

                let datetime = DateTime()
                var comparedDateTime = datetime.addSeconds(-secondsDifference)
                comparedDateTime = comparedDateTime.addMinutes(-minutesDifference)
                comparedDateTime = comparedDateTime.addHours(-hoursDifference)
                comparedDateTime = comparedDateTime.addDays(-daysDifference)

                let timespan = datetime.timespanSinceDate(comparedDateTime)

                expect(timespan.seconds).to(equal(secondsDifference))
                expect(timespan.minutes).to(equal(minutesDifference))
                expect(timespan.hours).to(equal(hoursDifference))
                expect(timespan.days).to(equal(daysDifference))
            }
        }

        describe("DateTime comparisons") {
            it("determines when one date time is greater than another") {
                let firstDateTime = DateTime()
                let secondDateTime = firstDateTime.addHours(-1)

                let comparisonResult = firstDateTime > secondDateTime
                expect(comparisonResult).to(beTrue())
            }

            it ("determines when one date time is greater than or equal to another") {
                let firstDateTime = DateTime()
                let secondDateTime = firstDateTime.addHours(0)

                let comparisonResult = firstDateTime >= secondDateTime
                expect(comparisonResult).to(beTrue())
            }

            it ("determines when one date time is less than another") {
                let firstDateTime = DateTime()
                let secondDateTime = firstDateTime.addHours(-1)

                let comparisonResult = secondDateTime < firstDateTime
                expect(comparisonResult).to(beTrue())
            }

            it ("determines when one date time is less than or equal to another") {
                let firstDateTime = DateTime()
                let secondDateTime = firstDateTime.addHours(0)

                let comparisonResult = secondDateTime <= firstDateTime
                expect(comparisonResult).to(beTrue())
            }
        }

        describe("DateTime string formatting") {
            it ("converts the datetime to a string value based on the input format") {
                let dateString = "October 23, 1995 13:25:44"
                let dateFormat = "MMMM dd, yyyy HH:mm:ss"

                let datetime = DateTime(string: dateString, format: dateFormat, timezone: utcTimezone)
                let stringOutput = datetime?.stringValue(format: dateFormat)

                expect(stringOutput).to(equal(dateString))
            }
        }
    }
}
