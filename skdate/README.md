Format:

Managed specifiers:

%a	  Abbreviated weekday name.
%^a	  Abbreviated weekday uppercase name.
%A	  Full weekday name.
%^A	  Full weekday uppercase name.
%b	  Abbreviated month name.
%^b	  Abbreviated month uppercase name.
%B	  Full month name.
%^B	  Full month uppercase name.
%c	  Date/Time in the format of the locale. If not available in the locale time format, format: %a %b %d %H:%M:%S %Y.
%:c	  Full calendar date format: %Y-%m-%d %H:%M:%f%:::z.
%C	  Century number [00-99], the year divided by 100 and truncated to an integer.
%d	  Day of the month [01-31].
%-d   Day of the month [1-31].
%D	  Date Format, same as %m/%d/%y.
%e	  Same as %d, except single digit is preceded by a space [ 1-31].
%g	  2 digit year portion of ISO week date [00,99].
%F	  ISO Date Format, same as %Y-%m-%d.
%f	  Fractional seconds SS.SSS.
%G	  4 digit year portion of ISO week date. Can be negative.
%h	  Same as %b.
%H	  Hour in 24-hour format [00-23].
%I	  Hour in 12-hour format [01-12].
%j	  Day of the year [001-366].
%J    Julian day number (fractional).
%m	  Month [01-12].
%_m	  Month [ 1-12].
%-m	  Month [1-12].
%M	  Minute [00-59].
%n	  Newline character.
%p	  AM or PM string.
%r	  Time in AM/PM format of the locale. If not available in the locale time format, defaults to the POSIX time AM/PM format: %I:%M:%S %p.
%R	  24-hour time format without seconds, same as %H:%M.
%S	  Second [00-59].
%s	  Number of seconds since 1970-01-01 00:00:00 UTC
%t	  Tab character.
%T	  24-hour time format with seconds, same as %H:%M:%S.
%u	  Weekday [1,7]. Monday is 1 and Sunday is 7.
%U	  Week number of the year [00-53]. Sunday is the first day of the week.
%V	  ISO week number of the year [01-53]. Monday is the first day of the week. If the week containing January 1st has four or more days in the new year then it is considered week 1. Otherwise, it is the last week of the previous year, and the next year is week 1 of the new year.
%w	  Weekday [0,6], Sunday is 0.
%W	  Week number of the year [00-53]. Monday is the first day of the week.
%y	  2 digit year [00,99].
%Y	  4-digit year. Can be negative.
%x	  Date in the format of the locale. If not available in the locale time format, format: %m/%d/%y.
%X	  Time in the format of the locale. If not available in the locale time format, format: %H:%M:%S.
%z	  UTC offset with hour and minute offset without separator (e.g. +0900).
%:z	  UTC offset with hour and minute offset with a colon (e.g. +09:00).
%::z	UTC offset with hour, minute and second (e.g. +09:00:00).
%:::z UTC offset with hour, minute and second if needed (e.g. +09, +09:30, +09:30:30).
%Z	  Locale time zone name.
%%	% character.

Unmanaged specifiers are returned as they are.