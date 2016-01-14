function targetDST = timezoneconvert(dateno,toTimezone,fromTimezone)
%   targetDST = timezoneconvert(dateno,toTimezone,fromTimezone)
%   dateno : The datenumber that is in the form of matlabs datenumber
%   dateno = seconds from 1st June 0000 00:00:00  over 86400 which is
%   seconds in a day
%   toTimeZone : The name of timezone that is converted to. If it is empty 
%   or 'local' current system zone is used
%   fromTimeZone : The name of timezone that is converted from. If not
%   entered current system zone is used
%   Use java.util.TimeZone.getAvailableIDs to retrieve the names of
%   timezones.
%   If a timezone parameter is wrong, it will be replaced by GMT.
import java.util.* 
if ~exist('fromTimezone','var') || isempty(fromTimezone) || strcmpi(fromTimezone,'local')
    FromCalender = javaObjectEDT('java.util.GregorianCalendar',javaMethodEDT('getDefault','java.util.TimeZone'));
else
    FromCalender = javaObjectEDT('java.util.GregorianCalendar',javaMethodEDT('getTimeZone','java.util.TimeZone',fromTimezone));
end
if ~exist('toTimezone','var') || isempty(toTimezone) || strcmpi(toTimezone,'local')
    ToCalender = javaObjectEDT('java.util.GregorianCalendar',javaMethodEDT('getDefault','java.util.TimeZone'));
else
    ToCalender = javaObjectEDT('java.util.GregorianCalendar',javaMethodEDT('getTimeZone','java.util.TimeZone',toTimezone));
end
datevc    = datevec(dateno);
targetDST = dateno;
for iDateNum = 1:length(dateno)
    FromCalender.set(datevc(iDateNum,1),datevc(iDateNum,2)-1,datevc(iDateNum,3),datevc(iDateNum,4),datevc(iDateNum,5),datevc(iDateNum,6))
    % Correct the milliseconds field
    FromCalender.set(Calendar.MILLISECOND,rem(datevc(iDateNum,end),1)*1000)
    ToCalender.setTimeInMillis(FromCalender.getTimeInMillis());
    targetDST(iDateNum) = ToCalender.getTimeInMillis() + ToCalender.get(ToCalender.ZONE_OFFSET) + ToCalender.get(ToCalender.DST_OFFSET);
    targetDST(iDateNum) = datenum([1970 1 1 0 0 targetDST(iDateNum)/1000]);
end