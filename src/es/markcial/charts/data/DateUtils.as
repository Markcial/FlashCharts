package es.markcial.charts.data {
	
	/**
	 * @author markcial
	 */
	public class DateUtils {

		public static function getTotalDaysFromYear(year:uint):uint{
			var sDate : Date = new Date(year,0,1);
			var eDate : Date = new Date(year+1,12,0);
			var days : uint = Math.round(Math.abs((eDate.time - sDate.time) / 86400000));
			return days;
		}
		
		public static function getTotalDaysFromYearMonth(year:uint,month:uint):uint{
			var sDate : Date = new Date(year,month,0);
			var eDate : Date = new Date(year,month+1,0);
			var days : uint = Math.round(Math.abs((eDate.time - sDate.time) / 86400000));
			return days;
		}
	}
}
