package ouwei.encry
{
	import com.baiduLvgu.core.Config;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.ByteArray;
	
	import cmodule.Decryptor.CLibInit;
	
	[SWF(width="500", height="375", frameRate="30")] //the dimensions should be same as the loaded swf's
	public class QjMain extends Sprite
	{
		[Embed (source = "../../../bin-release/QjPlayer.swf", mimeType = "application/octet-stream")]
		private var content:Class;
		private var key:String = "ouwei123456A"; 
		
		public function QjMain():void
		{
			flash.system.Security.allowDomain("*");
			if(loaderInfo.parameters.width && loaderInfo.parameters.height){
				setWH(loaderInfo.parameters.width,loaderInfo.parameters.height);
			}
			load();
		}
		
		public function load():void{
			var data:ByteArray = new content();
			
			/*
			var cLibInit:cmodule.Decryptor.CLibInit = new cmodule.Decryptor.CLibInit();
			var encryptorLib:Object = cLibInit.init();
			encryptorLib.Decrypt(data);
			data.position = 0;
			*/
			/*
			var flag:int = 0;
			
			var desci:int = 0;
			var descnum:Number = 50;
			
	
			for(var i:int = 0; i < data.length && desci < descnum; ){
				if(flag >= key.length){
					flag = 0;
				}
				data[i] = data[i] - key.charCodeAt(flag);
				i = i + 50 ;
				desci = desci + 1;
				flag = flag + 1;
				
				
			}
			*/
			var locontext:LoaderContext=new LoaderContext(false,ApplicationDomain.currentDomain);
			locontext.parameters = loaderInfo.parameters;
			
			if(flash.system.Capabilities.playerType == "Desktop")
			{
				trace("flash.system.Capabilities.playerType"+flash.system.Capabilities.playerType);
				locontext.allowLoadBytesCodeExecution = true;
				
			}
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCmp);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onErr);
			loader.loadBytes(data,locontext);
			addChild(loader);
		}
		
		protected function onErr(event:IOErrorEvent):void
		{
			trace(event.text);			
		}
		
		private var w:Number;
		private var h:Number;
		
		private var isSetWH:Boolean;
		
		public function setWH(w:Number,h:Number):void{
			this.w = w;
			this.h = h;
			isSetWH = true;
			if(isSetWH && loadContent && loadContent.hasOwnProperty("setWH"))
				loadContent.setWH(this.w,this.h);
		}
		
		protected function onCmp(event:Event):void
		{
			loadContent = event.target.content.manager;
			if(isSetWH && loadContent && loadContent.hasOwnProperty("setWH"))
				loadContent.setWH(this.w,this.h);
		}
		
		private var loadContent:Object;
	}
	
}