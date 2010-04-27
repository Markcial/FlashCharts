package es.markcial.charts.data {
	import flash.xml.XMLNode;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import es.markcial.log.Logger;

	/**
	 * @author markcial
	 */
	public class DataSource extends EventDispatcher {
		
		protected static var $instance : DataSource;
		protected var parsedData : XML;
		
		protected var loader : URLLoader = new URLLoader();
		
		public static function getInstance():DataSource{
			if($instance == null){
				Logger.log('initial instantiation DataSource');
				$instance = new DataSource(new SingletonLock());
			}
			return $instance;
		}
		
		public function DataSource(lock:SingletonLock){
			if(lock==null)throw new Error("Error: Instantiation failed: Use DataSource.getInstance() instead of new.");
		}
		
		public function getData(path:String):void{
			loader.addEventListener(Event.OPEN, onDataLoadStart);
			loader.addEventListener(ProgressEvent.PROGRESS, onDataProgress);
			loader.addEventListener(Event.COMPLETE,onDataLoadComplete);
			loader.load(new URLRequest(path)); 
		}
		
		public function get isLoaded():Boolean{
			return parsedData!=null;
		}
		
		public function get lowestStartYear():int{
			if(!isLoaded)throw new Error("datos no cargados!");
			var years : XMLList = parsedData.list.*.startDate;
			var min : int = 0;
			for each(var year : XML in years ){
				var p : Array = year.text().toString().split('/');
				var y : int = new Date(p[2],p[1],p[0]).fullYear;
				if(min!=0){
					y<min?min=y:false;
				}else{
					min = y;
				}
			}
			return min;
		}
		
		public function get highestEndYear():int{
			if(!isLoaded)throw new Error("datos no cargados!");
			var years : XMLList = parsedData.list.*.endDate;
			var max : int = 0;
			for each(var year : XML in years ){
				var p : Array = year.text().toString().split('/');
				var y : int = new Date(p[2],p[1],p[0]).fullYear;
				if(max!=0){
					y>max?max=y:false;
				}else{
					max = y;
				}
			}
			return max;
		}
		
		public function get timelineTitulo():String{
			if(!isLoaded)throw new Error("datos no cargados!");
			return parsedData.title.text();
		}
		
		public function get rangoInicial():int{
			if(!isLoaded)throw new Error("datos no cargados!");
			return parsedData.yearRange.startYear.text();
		}
		
		public function get rangoFinal():int{
			if(!isLoaded)throw new Error("datos no cargados!");
			return parsedData.yearRange.endYear.text();
		}

		public function get numeroProyectos():int{
			if(!isLoaded)throw new Error("datos no cargados!");
			return parsedData.list.project.length();			
		}
		
		public function getIdProyecto(ptr:int):int{
			var id : int = parsedData.list.project[ptr].@id;
			return id;
		}
		
		public function getLink(id:int):String{
			var link : String = parsedData.list.project.( @id == id ).link.text();
			return link;
		}
		
		public function fechaInicioProyecto(id:uint):Date{
			var sfec : String = parsedData.list.project.( @id == id ).startDate.text();
			var f : Array = sfec.split("/");
			return new Date(int(f[2]),int(f[1])-1,int(f[0])); 
		}
		
		public function fechaFinProyecto(id:uint):Date{
			var sfec : String = parsedData.list.project.( @id == id ).endDate.text();
			var f : Array = sfec.split("/");
			return new Date(int(f[2]),int(f[1])-1,int(f[0])); 
		}
		
		public function tituloProyecto(id:uint):String{
			return parsedData.list.project.( @id == id ).title.text();
		}
		
		public function descriptionProyecto(id:uint):String{
			return parsedData.list.project.( @id == id ).intro.text();
		}
		
		public function detalleProyecto(id:uint):String{
			return parsedData.list.project.( @id == id ).description.text();
		}

		private function onDataLoadComplete(evt:Event) : void {
			Logger.log("Data Completed");
			parsedData = new XML(URLLoader(evt.target).data);
			Logger.log(parsedData.yearRange.startYear.text());
			Logger.log(parsedData.yearRange.endYear.text());
			dispatchEvent(new Event("completado"));
		}

		private function onDataProgress(evt:Event) : void {
			Logger.log('data progress');
		}

		private function onDataLoadStart(evt:Event) : void {
			Logger.log('data start');
		}
	}	
}

internal class SingletonLock{}
