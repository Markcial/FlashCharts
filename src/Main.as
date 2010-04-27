package {

	import com.greensock.TweenMax;
	import com.greensock.TweenLite;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import es.markcial.charts.Assets;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.display.LoaderInfo;
	import es.markcial.charts.timeline.Tooltip;
	import es.markcial.charts.timeline.TimelineEvent;
	import es.markcial.charts.timeline.Timeline;
	import es.markcial.charts.data.DataSource;
	import es.markcial.log.Logger;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	[SWF(backgroundColor="#F2F0E6", frameRate="30", width="980", height="580")]
	public class Main extends Sprite
	{
		protected var dataSource : DataSource;
		
		protected var timeline : Timeline;
		
		protected var container : Sprite = new Sprite();
		
		protected var loading : Sprite = new Sprite();
		
		protected var tooltip : Tooltip = new Tooltip();
		
		protected var flashVars : Object;
		
		protected var dataPath : String = "xml/datasource.xml";
		
		protected var yDesp : Number = 0;
		
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		protected function init(evt:Event):void{
			Logger.ENABLED = false;
			Logger.log("Log session start!");
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			flashVars = LoaderInfo(root.loaderInfo).parameters;
			addChild(container);
			addLoading();
			dataSource = DataSource.getInstance();
			dataSource.getData(flashVars["dataSource"] ? flashVars["dataSource"] : dataPath);
			dataSource.addEventListener("completado", onDataSourceReady);
		}

		private function onDataSourceReady(evt:Event) : void {
			timeline = new Timeline();
			container.addChild(timeline);
			for(var i :uint = 0;i<dataSource.numeroProyectos;i++){
				var nodeId : int = dataSource.getIdProyecto(i);
				var startDate : Date = dataSource.fechaInicioProyecto(nodeId);
				var endDate : Date = dataSource.fechaFinProyecto(nodeId);
				var link : String = dataSource.getLink(nodeId);
				var tlEvent : TimelineEvent = new TimelineEvent(startDate, endDate, nodeId, link );
				timeline.addTimelineEvent(tlEvent);
			}
			
			timeline.render();
			TweenMax.to(loading,.5,{alpha:0,onComplete:function():void{removeChild(loading);}});
			/*if(timeline.width>stage.stageWidth){
				addHScroll();
			}*/
			if(timeline.altoEventos>stage.stageHeight){
				addVScroll();
			}
			Logger.log(timeline.altoEventos,"alto eventos");
			
			tooltip.alpha = 0;
			addChild(tooltip);
			timeline.tooltip = tooltip;
			tooltip.trackMouse();
		}
		
		private function addLoading():void{
			addChild(loading);
			loading.graphics.beginFill(0xFFFFFF,.7);
			loading.graphics.drawRect(0,0, stage.stageWidth, stage.stageHeight);
			loading.graphics.endFill();
			var texto : TextField = new TextField();
			var tformat : TextFormat = new TextFormat(Assets.FONT_ARIAL,28,0x5b512d,true);
			tformat.align = TextFormatAlign.LEFT;
			texto.defaultTextFormat = tformat;
			texto.autoSize = TextFieldAutoSize.CENTER;
			texto.width = 400;
			texto.embedFonts = true;
			texto.selectable = false;
			texto.text = "Cargando proyectos";
			loading.addChild(texto);
			texto.x = ( stage.stageWidth - texto.textWidth ) / 2;
			texto.y = ( stage.stageHeight - texto.textHeight ) / 2;
		}

		protected function addHScroll():void{
			stage.addEventListener(Event.ENTER_FRAME, hscroll);
		}
		
		protected function addVScroll():void{
			stage.addEventListener(MouseEvent.MOUSE_MOVE,initVScroll);
		}
		
		protected function removeVScroll(evt:Event):void{
			stage.removeEventListener(Event.MOUSE_LEAVE, removeVScroll);
			stage.removeEventListener(Event.ENTER_FRAME, vscroll);
		}
		
		protected function initVScroll(evt:MouseEvent):void{
			stage.addEventListener(Event.MOUSE_LEAVE, removeVScroll);
			stage.addEventListener(Event.ENTER_FRAME, vscroll);
		}
		
		protected function hscroll(evt:Event):void{
			//Logger.log(mouseX,"raton x");
			//Logger.log(mouseY,"raton y");
			var delta : Number = ( stage.mouseX / stage.stageWidth );
			delta *= -1;
			timeline.x = (timeline.width - (stage.stageWidth)) *  delta;
			//Logger.log(delta,"centro");
		}
		
		protected function vscroll(evt:Event):void{
			//Logger.log(mouseX,"raton x");
			//Logger.log(mouseY,"raton y");
			var delta : Number = ( stage.mouseY / stage.stageHeight );
			var fc : Number;
			if(delta<0.3 &&  timeline.spriteEventos.y < 0 ){
				fc = 100 * ( .3 - delta);
				timeline.spriteEventos.y += fc;
			}else if(delta>0.7 && timeline.spriteEventos.y > ( ( timeline.altoEventos + timeline.altoTimeline ) - stage.stageHeight  ) * -1 ){
				fc = 100 * ( .3 - (1-delta));
				timeline.spriteEventos.y -= fc;
			}
			Logger.log(timeline.spriteEventos.y);
			//Logger.log(delta,"centro");
		}
	}
}