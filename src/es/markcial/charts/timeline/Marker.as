package es.markcial.charts.timeline {
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author markcial
	 */
	public class Marker extends Sprite {
		
		protected var ownDate : Date;
		
		public function Marker(date:Date) {
			ownDate = new Date(date.fullYear,date.month,date.date);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(evt:Event):void{
			graphics.lineStyle(.5,0x000000,1);
			graphics.moveTo(0, 0);
			graphics.lineTo(0, 30);
			graphics.endFill();
			var tb : TextField = new TextField();
			addChild(tb);
			tb.border = true;
			tb.autoSize = TextFieldAutoSize.LEFT;
			tb.text = ownDate.date.toString();
			tb.x -= 10;
			tb.y -= 20;
		}
	}
}
