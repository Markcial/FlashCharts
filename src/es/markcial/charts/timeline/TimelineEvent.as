package es.markcial.charts.timeline {
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.AntiAliasType;
	import es.markcial.charts.Assets;
	import flash.text.TextFormatAlign;
	import flash.text.TextFormat;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import es.markcial.charts.data.DataSource;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import flash.geom.Rectangle;
	import es.markcial.log.Logger;
	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author markcial
	 */
	public class TimelineEvent extends Sprite {
		
		protected var dataSource : DataSource;
		
		public var startDate : Date;
		public var endDate : Date;
		public var projectId : uint;
		
		protected var $targetUrl : String;
		
		protected var padding : Number = 7;
		
		protected var defHeight : Number = 50;
		
		protected var titulo : TextField = new TextField();
	
		protected var bg : Sprite = new Sprite();
		
		public var area : Rectangle = new Rectangle();
		
		public function TimelineEvent(sDate:Date,eDate:Date,nodeId:uint,targetUrl:String) {
			startDate = sDate;
			endDate = eDate;
			projectId = nodeId;
			area.height = defHeight;
			$targetUrl = targetUrl;
			dataSource = DataSource.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(evt:Event):void{
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onMouseClick);	
		}
		
		protected function onMouseClick(evt:MouseEvent):void{
			var req : URLRequest = new URLRequest($targetUrl);
			navigateToURL(req,"_self");
		}
		
		protected function onMouseOut(evt:MouseEvent):void{
			TweenLite.to(bg,.4,{alpha:1});
		}
		
		protected function onMouseOver(evt:MouseEvent):void{
			TweenLite.to(bg,.4,{alpha:.4});
		}
				
		protected function addTitulo():void{
			titulo.autoSize = TextFieldAutoSize.LEFT;
			titulo.x = area.x + padding;
			titulo.y = area.y + padding;
			titulo.width = area.width - (padding*2);
			titulo.multiline = true,
			titulo.wordWrap = true;
			titulo.textColor = 0x5b512d;
			titulo.selectable = false;
			titulo.antiAliasType = AntiAliasType.ADVANCED;
			titulo.htmlText = '<font face="Arial" size="11"><b>'+dataSource.tituloProyecto(projectId)+"</b></font>";
			addChild(titulo);	
		}

		public function draw():void {
			addChild(bg);
			addTitulo();
			area.height = titulo.textHeight + (padding*2);
			bg.graphics.beginFill(0xf6e5a1);
			bg.graphics.drawRoundRect(area.x, area.y, area.width, area.height, 10);
			bg.graphics.endFill();
		}
	}
}
