package es.markcial.charts.timeline {
	import flash.text.AntiAliasType;
	import es.markcial.charts.Assets;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.geom.Matrix;
	import flash.display.SpreadMethod;
	import flash.display.GradientType;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author markcial
	 */
	public class Tooltip extends Sprite {
		
		protected var area : Rectangle = new Rectangle();
		protected var tf : TextField = new TextField();
		
		public function Tooltip() {
			area.width = 430;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(evt:Event):void{
			build();	
		}
		
		protected function build():void{
			addChild(tf);
			tf.y = 3;
			tf.x = 3;
			tf.width = area.width - 6;	
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;
			tf.wordWrap = true;
			//var tformat : TextFormat = new TextFormat();
			//tformat.font = Assets.FONT_ARIAL;
			//tf.defaultTextFormat = tformat;
			//tf.embedFonts = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.htmlText = "";	
			draw();
		}
		
		protected function draw():void{
			area.height = tf.textHeight + 6;
			var colors:Array = [0xe5e5e5, 0xf2f2f2];
  			var alphas:Array = [1, 1];
  			var ratios:Array = [0x00, 0xFF];
 			var matr:Matrix = new Matrix();
  			matr.createGradientBox(area.width, area.height, Math.PI/2, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr, SpreadMethod.PAD);
			graphics.drawRoundRect(0, 0, area.width, area.height,10);
			graphics.endFill();
		}

		protected function redraw():void{
			graphics.clear();
			draw();
		}
		
		public function trackMouse():void{
			addEventListener(Event.ENTER_FRAME, followMouse );
		}
		
		private function followMouse(evt:Event):void{
			x = stage.mouseX + 10;
			y = stage.mouseY + 10;
			if( ( x + width) > stage.stageWidth ){
				x = stage.mouseX - ( 10 + width );
			}
			if( ( y + height ) > stage.stageHeight ){
				y = stage.mouseY - ( 10 + height );
			}
		}
		
		public function set message(str:String):void{
			tf.htmlText = '<font face="Arial">'+str+'</font>';
			redraw();	
		}
		
		public function show():void{
			TweenLite.to(this,.2,{alpha:1});
		}
		
		public function hide():void{
			TweenLite.to(this,.2,{alpha:0});	
		}
	}
}
