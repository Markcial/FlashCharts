package es.markcial.log
{
	import flash.text.TextField;
	import flash.external.ExternalInterface;
	
	public class Logger {
		
		public static var LOG_LEVEL : int = 0;
		public static var DEBUG_LEVEL : int = 1;
		public static var WARN_LEVEL : int = 2;
		public static var ERROR_LEVEL : int = 3;
		public static var FATAL_LEVEL : int = 4;
		
		protected static var SEVERITY_LEVEL : Array = ["log","debug","warn","error","fatal"];
		
		public static var VERBOSE_LEVEL : int = LOG_LEVEL;
		public static var ENABLED : Boolean = true;
		public static var OM_FIREBUG : String = "firebug";
		public static var OM_EXT_TEXTBOX : String = "textbox";
		public static var OM_TRACE : String = "trace";
		
		protected static var OUTPUT_MODE : String = OM_FIREBUG; // ["firebug","textbox","trace"];
		
		protected static var textField : TextField;
		
		public static function setTextField(tf:TextField):void {
			textField = tf; 
		}
		
		public static function setMode(mode:String):void {
			if(mode == OM_FIREBUG|| mode == OM_EXT_TEXTBOX || mode == OM_TRACE ){
				OUTPUT_MODE = mode;
			}else{
				throw new Error("Modo no aceptado!");
			}
		}

		protected static function traceCall(severity:int,obj:*,msg:String):void{
			if(!ENABLED)return;
			if(severity < VERBOSE_LEVEL)return;
			switch(OUTPUT_MODE){
				case OM_FIREBUG:
				if(ExternalInterface.available){
					var func : String = "console." + SEVERITY_LEVEL[severity];
						if(msg){
						ExternalInterface.call(func,msg,obj);
					}else{
						ExternalInterface.call(func,obj);
					}
				};
				break;
				case OM_EXT_TEXTBOX:
					if(textField){
						if(msg){
							textField.appendText(msg + " :: " + obj + "\n" );
						}else{
							textField.appendText(obj + "\n" );
						}
					};
				break;
				case OM_TRACE:
				default:
				if(msg){
					trace(SEVERITY_LEVEL[severity] + " :: " + msg + " :: " + obj );
				}else{
					trace(SEVERITY_LEVEL[severity] + " :: " + obj );
				}
				break;	
			}
		}
		
		public static function log(obj:*,msg:String=null):void{
			traceCall(LOG_LEVEL, obj, msg);
		}
		public static function debug(obj:*,msg:String=null):void{
			traceCall(DEBUG_LEVEL, obj, msg);
		}
		public static function warn(obj:*,msg:String=null):void{
			traceCall(WARN_LEVEL, obj, msg);
		}
		public static function error(obj:*,msg:String=null):void{
			traceCall(ERROR_LEVEL, obj, msg);
		}
		public static function fatal(obj:*,msg:String=null):void{
			traceCall(FATAL_LEVEL, obj, msg);
		}
		public static function dir(obj:*,msg:String=null):void{}
	}
}