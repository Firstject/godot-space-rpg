# Date Time
# Written by: First

extends Node

class_name Util_DateTime

"""
	DateTime is a class used for storing date and time.
	It can convert these data into a readable text, and
	also supports formatting patterns. It contains
	days, months, years, hours, minutes, seconds, and
	daylight savings, primarily.
	
	DateTime เป็นคลาสที่เก็บข้อมูลวันที่และเวลา สามารถเก็บแปลงมาเป็น
	ข้อความที่ทำให้อ่านแล้วเข้าใจได้ ซึ่งรองรับการ format ข้อความได้อีก
	หลากหลายรูปแบบ โดยพื้นฐานจะมีข้อมูล วัน เดือน ปี เวลาเป็นชั่วโมง
	นาที วินาที และ เวลาออมแสงแดด หลักๆ
"""

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export var year : int setget set_year, get_year

export var month : int setget set_month, get_month 

export var weekday : int setget set_weekday, get_weekday

export var day : int setget set_day, get_day

export var hour : int setget set_hour, get_hour

export var minute : int setget set_minute, get_minute

export var second : int setget set_second, get_second

export var dst : bool setget set_dst, get_dst

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#Set all variables from a dictionary. Mostly when you acquire
#it from OS singleton by calling `OS.get_datetime()`.
func set_datetime_from_dict(dict : Dictionary) -> void:
	year = dict.get("year")
	month = dict.get("month")
	weekday = dict.get("weekday")
	day = dict.get("day")
	hour = dict.get("hour")
	minute = dict.get("minute")
	second = dict.get("second")
	dst = dict.get("dst")

#Returns time in minutes as string. A zero letter is added
#at the beginning of the text if the time is a single digit.
func get_minute_as_text(var minute : int, var add_zero_prefix : bool = true) -> String:
	if add_zero_prefix and minute <= 9:
		return str(0, minute)
	
	return str(minute)

#Returns time in seconds as string. A zero letter is added
#at the beginning of the text if the time is a single digit.
func get_second_as_text(var second : int, var add_zero_prefix : bool = true) -> String:
	if add_zero_prefix and second <= 9:
		return str(0, second)
	
	return str(second)

#Returns a full weekday name (Starting from Sunday).
func get_weekday_name(weekday : int) -> String:
	match weekday:
		OS.DAY_SUNDAY:
			return "Sunday"
		OS.DAY_MONDAY:
			return "Monday"
		OS.DAY_TUESDAY:
			return "Tuesday"
		OS.DAY_WEDNESDAY:
			return "Wednesday"
		OS.DAY_THURSDAY:
			return "Thursday"
		OS.DAY_FRIDAY:
			return "Friday"
		OS.DAY_SATURDAY:
			return "Saturday"
		_:
			return "UnknownDay"

#Returns abbreviated name of weekday.
func get_weekday_abbr_name(weekday : int) -> String:
	return get_weekday_name(weekday).substr(0, 3)

#Return a full month name.
func get_month_name(month : int) -> String:
	match month:
		OS.MONTH_JANUARY:
			return "January"
		OS.MONTH_FEBRUARY:
			return "February"
		OS.MONTH_MARCH:
			return "March"
		OS.MONTH_APRIL:
			return "April"
		OS.MONTH_MAY:
			return "May"
		OS.MONTH_JUNE:
			return "June"
		OS.MONTH_JULY:
			return "July"
		OS.MONTH_AUGUST:
			return "August"
		OS.MONTH_SEPTEMBER:
			return "September"
		OS.MONTH_OCTOBER:
			return "October"
		OS.MONTH_NOVEMBER:
			return "November"
		OS.MONTH_DECEMBER:
			return "December"
		_:
			return "UnknownMonth"

#Returns abbreviated name of month.
func get_month_abbr_name(month : int) -> String:
	return get_month_name(month).substr(0, 3)

#Indicating the period of the day from midnight to just before noon.
func is_ante_meridiem(hour : int) -> bool:
	return hour % 24 < 12

#Indicating the period of the day from noon to just before midnight.
func is_post_meridiem(hour : int) -> bool:
	return hour % 24 >= 12

#Get time marker in AM/PM format by passing a parameter with
#value 'hour'. Two optional parameters can be passed to return
#string converted to uppercase or excluding pull stops. Ex:
#
#*-* `get_am_pm(10)`  _returns A.M._
#
#*-* `get_am_pm(20)`  _returns P.M._
#
#*-* `get_am_pm(5, true)`  _returns a.m._
#
#*-* `get_am_pm(17, true, false)`  _returns pm_
func get_am_pm(hour : int, uppercase : bool = false, include_pull_stop : bool = true) -> String:
	var result : String
	
	if is_ante_meridiem(hour):
		result = "a.m."
	else:
		result = "p.m."
	
	if uppercase:
		result = result.to_upper()
	
	if not include_pull_stop:
		result = result.replace(".", "")
	
	return result

#Get datetime on this object from a format text and returns result as String.
#Below is the letters you can use to create a format:
#
#*-* `yyyy` : year, four digits
#
#*-* `yy` : year, last two digits
#
#*-* `MMM` : month abbreviation name, 3 letters long
#
#*-* `MM` : month
#
#*-* `day` : weekday abbreviation name, 3 letters long
#
#*-* `dd` : day
#
#*-* `HH` : hour (0 - 23)
#
#*-* `hh` : hour (0 - 12)
#
#*-* `mm` : minute in hour, with zero prefix at < 10
#
#*-* `ss` : seconds, with zero prefix at < 10
func get_datetime_by_format(format : String = "day-dd-yyyy hh:mm") -> String:
	format = format.replace("yyyy", str(year))
	format = format.replace("yy", str(year).right(2))
	format = format.replace("MMM", get_month_abbr_name(month))
	format = format.replace("MM", str(month))
	format = format.replace("day", get_weekday_abbr_name(weekday))
	format = format.replace("dd", str(day))
	format = format.replace("HH", str(hour))
	if hour % 24 > 12:
		format = format.replace("hh", str(hour % 24 - 12))
	else:
		format = format.replace("hh", str(hour % 24))
	format = format.replace("mm", get_minute_as_text(minute))
	format = format.replace("ss", get_second_as_text(second))
	format = format.replace("aa", get_am_pm(hour, true, false))
	
	return format


#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_year(val) -> void:
	year = val

func get_year() -> int:
	return year

func set_month(val) -> void:
	month = val

func get_month() -> int:
	return month

func set_weekday(val) -> void:
	weekday = val

func get_weekday() -> int:
	return weekday

func set_day(val) -> void:
	day = val

func get_day() -> int:
	return day

func set_hour(val) -> void:
	hour = val

func get_hour() -> int:
	return hour

func set_minute(val) -> void:
	minute = val

func get_minute() -> int:
	return minute

func set_second(val) -> void:
	second = val

func get_second() -> int:
	return second

func set_dst(val) -> void:
	dst = val

func get_dst() -> bool:
	return dst
