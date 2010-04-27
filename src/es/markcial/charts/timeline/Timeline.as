package es.markcial.charts.timeline {
	import mx.formatters.DateFormatter;
	import flash.text.AntiAliasType;
	import es.markcial.charts.Assets;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import es.markcial.charts.data.DateUtils;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import es.markcial.log.Logger;
	import es.markcial.charts.data.DataSource;
	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author markcial
	 */
	public class Timeline extends Sprite {
		
		protected var dataSource : DataSource;
		protected var fromYear : int;
		protected var toYear : int;
		protected var yearRange : int;
		protected var areaFondo : Rectangle = new Rectangle();
		
		protected var $tooltip : Tooltip;
		
		protected var tHeight : Number = 60;
		protected var padding : Number = 10;
		protected var margin : Number = 10;
		
		private var sEvents : Sprite = new Sprite();
		private var sTimeline : Sprite = new Sprite();
		
		protected var tlEvents : Array = [];
		protected var rdEvents : Array = [];
		
		protected var cTlEvent : TimelineEvent;
		
		public function Timeline() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(evt:Event):void{
			dataSource = DataSource.getInstance();
			if(!dataSource.isLoaded){ // se supone que si, atachamos el clip cuando se ha cargado el xml
				throw new Error("Datos no cargados");
			}
			fromYear = dataSource.lowestStartYear;
			toYear = dataSource.highestEndYear;
			yearRange = toYear - fromYear;
		}

		public function set tooltip(ttip : Tooltip):void{
			$tooltip = ttip;
		};

		public function render():void{
			if(tlEvents.length==0)Logger.warn('No hay eventos en la linea de tiempo, asegurate de añadirlos antes de renderizar!');
			// hay que añadir las muescas de los dias y meses tambien
			addChild(sEvents);
			addChild(sTimeline);
			areaFondo.height = 45;
			areaFondo.width = stage.stageWidth;
			var xFrac : Number =  areaFondo.width / (365 * (yearRange+1));
			var lastX : Number = 0;
			for(var i : int = fromYear;i <= toYear;i++) {
				var markerYear : Sprite = addYearMarker(i);
				addChild(markerYear);
				markerYear.x = lastX;
				markerYear.y = stage.stageHeight - ( markerYear.height + 12 );
				lastX+=xFrac;
				for(var j : uint = 0;j<12;j++){
					var diasm : uint = DateUtils.getTotalDaysFromYearMonth(i, j);
					//Logger.log(diasm,"dias del mes");
					//var markerMonth : Sprite = addMonthMarker(j);
					//addChild(markerMonth);
					//markerMonth.x = lastX;
					//lastX+=4;
					//markerMonth.y = stage.stageHeight - markerMonth.height;
					lastX+=xFrac;
					for(var k : uint = 0;k<diasm;k++){
						//var markerDate : Sprite = addDateMarker(k);
						for each(var tlEvt : TimelineEvent in tlEvents){
							if( tlEvt.startDate.fullYear == i &&
							    tlEvt.startDate.month == j &&
							    tlEvt.startDate.date == (k+1) ){
							    	tlEvt.area.x = lastX;
									var evtRdy : Boolean = true;
									for each(var iEvt : TimelineEvent in rdEvents){
										iEvt.projectId == tlEvt.projectId ? evtRdy=false:false;
									}
									evtRdy?rdEvents.push(tlEvt):false;
									Logger.log(evtRdy,"no repetido");
									Logger.log(tlEvt,"evento");
									//tlEvt.area.y += 100;
							}
							if( tlEvt.endDate.fullYear == i &&
								tlEvt.endDate.month == j &&
								tlEvt.endDate.date == (k+1) ){
									tlEvt.area.width = lastX - tlEvt.area.x;
							}
						}
						//addChild(markerDate);
						//markerDate.x = lastX;
						//markerDate.y = stage.stageHeight - markerDate.height;
						lastX+=xFrac;
					}
				}
			}
			sTimeline.graphics.beginFill(0xf3ecca,1);
			sTimeline.graphics.drawRect(0,stage.stageHeight - areaFondo.height, areaFondo.width, areaFondo.height);
			sTimeline.graphics.endFill();			
			renderEvents();
		}
		
		protected function renderEvents():void{
			var startY : Number = 0;
			for each(var tlEvt : TimelineEvent in rdEvents) {
				/*if(addedEvts.length>0){
					for each(var adEvt : TimelineEvent in addedEvts ){
						if(!tlEvt.area.intersects(adEvt.area)){
							tlEvt.area.y = startY;
							tlEvt.draw();
							tlEvt.y -= tlEvt.height;
							addChild(tlEvt);
							break;
						}else{
							startY -= adEvt.area.height + 10;			
						}
					} 
				}else{*/
					tlEvt.area.y = startY;
					tlEvt.draw();
					//tlEvt.y += tlEvt.height;
					sEvents.addChild(tlEvt);
				//}
				
				startY += ( tlEvt.area.height + 2);
				tlEvt.addEventListener(MouseEvent.ROLL_OVER, onEventOver );
				tlEvt.addEventListener(MouseEvent.ROLL_OUT, onEventOut);
			}
			Logger.log(startY,"alto total");
		}
		
		protected function onEventOver(evt:MouseEvent):void{
			evt.preventDefault();
			var pjId : uint = TimelineEvent(evt.target).projectId;
			var fIn : Date = dataSource.fechaInicioProyecto(pjId);
			var df : DateFormatter = new DateFormatter();
			df.formatString = "DD/MM/YYYY";
			var msg : String = "<b>Fecha inicio : </b>"+df.format(fIn)+"<br />";
			var fFin : Date = dataSource.fechaFinProyecto(pjId);
			msg += "<b>Fecha fin : </b>"+df.format(fFin)+"<br />";
			msg += dataSource.detalleProyecto(pjId); 
			$tooltip.message = msg;
			$tooltip.show();
		}
		
		protected function onEventOut(evt:MouseEvent):void{
			$tooltip.hide();
		}
		
		protected function addYearMarker(year:uint):Sprite{
			var sp : Sprite = new Sprite();
			var tformat : TextFormat = new TextFormat();
			tformat.font = Assets.FONT_ARIAL;
			tformat.color = 0x666666;
			tformat.size = 12;
			
			var tb:TextField = new TextField();
			tb.embedFonts = true;
			tb.autoSize = TextFieldAutoSize.CENTER;
			tb.antiAliasType = AntiAliasType.ADVANCED;
			tb.defaultTextFormat = tformat;
			tb.text = year.toString();
			sp.addChild(tb);
			tb.x = (tb.width)*-1;
			tb.y = 0;
			return sp;
		}
		
		protected function addMonthMarker(month:uint):Sprite{
			var sp : Sprite = new Sprite();
			sp.graphics.lineStyle(.5,0x000000);
			sp.graphics.moveTo(0, -30);
			sp.graphics.lineTo(0,30);
			sp.graphics.endFill();
			var tb:TextField = new TextField();
			tb.autoSize = TextFieldAutoSize.LEFT;
			tb.border = true;
			sp.addChild(tb);
			//tb.embedFonts = true;
			tb.text = month.toString();
			//tb.rotation -= .5;
			return sp;
		}
		
		protected function addDateMarker(date:uint):Sprite{
			var sp : Sprite = new Sprite();
			sp.graphics.lineStyle(.5,0x000000);
			sp.graphics.moveTo(0,-70);
			sp.graphics.lineTo(0,0);
			sp.graphics.endFill();
			var tb:TextField = new TextField();
			tb.autoSize = TextFieldAutoSize.LEFT;
			tb.border = true;
			sp.addChild(tb);
			//tb.embedFonts = true;
			tb.text = date.toString();
			//tb.rotation -= .5;
			
			return sp;
		}
		
		public function get altoTimeline():Number {
			return sTimeline.height;
		}

		public function get altoEventos():Number {
			return sEvents.height;
		}
		
		public function get spriteEventos():Sprite{
			return sEvents;
		}

		public function addTimelineEvent(tlEvent:TimelineEvent):void {
			//tlEvent.startDate.
			tlEvents.push(tlEvent);
		}
	}
}