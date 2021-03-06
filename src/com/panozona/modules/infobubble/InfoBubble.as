﻿/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.infobubble{
	
	import com.panozona.modules.infobubble.controller.BubbleController;
	import com.panozona.modules.infobubble.model.InfoBubbleData;
	import com.panozona.modules.infobubble.view.BubbleView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	import flash.system.ApplicationDomain;
	
	public class InfoBubble extends Module{
		
		private var infoBubbleData:InfoBubbleData;
		
		private var bubbleView:BubbleView;
		private var bubbleController:BubbleController;
		
		public function InfoBubble(){
			super("InfoBubble", "1.3.2", "http://ouwei.cn/wiki/Module:InfoBubble");
			
			moduleDescription.addFunctionDescription("show", String);
			moduleDescription.addFunctionDescription("hide");
			moduleDescription.addFunctionDescription("setEnabled", Boolean);
			moduleDescription.addFunctionDescription("toggleEnabled");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			infoBubbleData = new InfoBubbleData(moduleData, qjPlayer); // allways first
			
			bubbleView = new BubbleView(infoBubbleData);
			addChild(bubbleView);
			bubbleController = new BubbleController(bubbleView, this);
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			qjPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
		}
		
		private function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			qjPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading);
			if (infoBubbleData.settings.enabled) {
				qjPlayer.manager.runAction(infoBubbleData.settings.onEnable);
			}else {
				qjPlayer.manager.runAction(infoBubbleData.settings.onDisable);
			}
		}
		
		private function handleResize(viewEvent:Object):void {
			infoBubbleData.bubbleData.isShowing = false;
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function show(bubbleId:String):void {
			infoBubbleData.bubbleData.currentId = bubbleId; // change id first!
			infoBubbleData.bubbleData.isShowing = true;
		}
		
		public function hide():void {
			infoBubbleData.bubbleData.isShowing = false;
		}
		
		public function setEnabled(value:Boolean):void {
			infoBubbleData.bubbleData.enabled = value;
		}
		
		public function toggleEnabled():void {
			infoBubbleData.bubbleData.enabled = !infoBubbleData.bubbleData.enabled;
		}
	}
}