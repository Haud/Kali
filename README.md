# DateTime

[![Version](https://img.shields.io/cocoapods/v/DateTime.svg?style=flat)](http://cocoapods.org/pods/DateTime)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/DateTime.svg?style=flat)](http://cocoapods.org/pods/DateTime)
[![Platform](https://img.shields.io/cocoapods/p/DateTime.svg?style=flat)](http://cocoapods.org/pods/DateTime)

DateTime is an iOS library written in Swift which aims to bring a native date object to the Swift library.
Many types such as `String` and `Int` have found native types in Swift from Objective-c, but `NSDate` did
not get such a treatment.

DateTime aims to wrap the complexities of `NSDate`, `NSCalendar`, and `NSTimeZone` in a much simpler interface,
making interfacing with dates much easier and safer than before. Unlike other libraries, `DateTime` does not aim
to extend `NSDate` or other Swift native types; instead, it aims to create a new, immutable Swift type that
wraps the complex functionality found in `NSDate` in an easier and safer manner.

## Requirements

DateTime is only compatible with Swift 2 and Xcode 7 and above. There is no support for this library for any
previous versions of Swift.

## Usage

### DateTime

DateTime aims to be as simple and seamless as possible by mimicking the `NSDate` APIs wherever possible. 

For instance, to instantiate DateTime with the current date and time, simply:

```swift
let currentDate = DateTime()
```

Often times, we need to convert strings to dates -- from API calls, for instance. Normally, this would require
working with `NSDateFormatter` and `NSCalendar` to get the desired results. With DateTime, however, this simply becomes:

```swift
let date = DateTime(string: "12/25/2001 14:23:23", format: "MM/dd/yyyy HH:mm:ss")
```

And sometimes, we just want to create a date simply and easily by specifying component values:

```swift
let datetime = DateTime(month: 12, day: 25, year: 2001, hour: 12, minute: 23, second: 23)
```

Accessing the various components of the date value is simple:

```swift
let datetime = DateTime(month: 12, day: 13, year: 2000)
print(datetime.month)    // 12
print(datetime.day)     // 13
print(datetime.year)    // 2000
```

DateTime implements `RawRepresentable` and can be conveniently initialized using the time interval in seconds since 
January 1, 1970.

DateTime implements `Comparable`, making it easy to compare two DateTime objects using `==`, `!=`, `>`, `>=`, `<`, `<=` .

DateTime initialization takes an optional `NSTimeZone` parameter. If not specified, it defaults to the device timezone.
The timezone property is an essential component of DateTime and ensures that your DateTime values are exactly as expected.

Finally, DateTime is immutable: once initialized, its state can never be modified or changed. Any potential modifications 
made to a DateTime object (by, for instance, adding minutes or day components) will result in a new DateTime object.

### TimeSpan

TimeSpans are included for a simple way to add time to DateTime objects as well as determine the time difference
between two DateTimes. 

Adding time values to a DateTime is simple. If you only need to add a single component to a DateTime:

```swift
let datetime = DateTime()
let fiveMinutesFromNow = dateTime.addMinutes(5)
```

For more complex time intervals, you can simply use `addTimespan`:

```swift
let datetime = DateTime()
let timespan = TimeSpan(days: 0, hours: 1, minutes: 5, seconds: 1)

let newDateTime = datetime.addTimespan(timespan)
```

Determining the time interval between two dates is just as simple. If you wanted to determine how much time had elapsed between two dates:

```swift
let firstDateTime = DateTime()
let secondDateTime = firstDateTime.addMinutes(-5)

let timespan = firstDateTime.timespanSinceDate(secondDateTime)

print(timespan.minutes) // 5
```

TimeSpan implements `RawRepresentable` and can be conveniently initialized using the time interval in seconds.

## Installation

DateTime is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DateTime", '~> 1.0'
```

## Contributing

All contributions to bettering this library are welcome! 

Feel free to create a pull request for this library to add or fix functionality. When contributing, please make sure
to follow the general style of the library: use `self` for all class level properties, document all public headers 
for AppleDocs, etc.

If you do not wish to contribute directly but wish to enhance the library or have found a bug, please file an issue.

## Author

Christopher Jones, chris.jones@haud.co

## License

DateTime is available under the MIT license. See the LICENSE file for more info.
