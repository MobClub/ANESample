package cn.sharesdk.ane {
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.InvokeEvent;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	import cn.sharesdk.ane.events.AuthEvent;
	import cn.sharesdk.ane.events.ShareEvent;
	import cn.sharesdk.ane.events.UserInfoEvent;
	
	public class ShareSDKExtension implements IEventDispatcher {
		
		private var context:ExtensionContext;
		private var onCom:Function;
		private var onErr:Function;
		private var onCan:Function;
		
		public function ShareSDKExtension() {
			context = ExtensionContext.createExtensionContext("cn.sharesdk.ane.ShareSDKExtension","");
			context.addEventListener(StatusEvent.STATUS, javaCallback);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, invokeHandler);
		}
		
		private function invokeHandler(event:InvokeEvent):void
		{
			if (event.arguments.length > 0)
			{
				var params:Object = new Object();
				params["url"] = event.arguments[0] as String;
				params["source_app"] = event.arguments[1] as String;
				params["annotation"] = event.arguments[2] as String;
				
				callJavaFunction("handleOpenURL", params);
			}	
		}
		
		private function callJavaFunction(action:String, params:Object = null):Object {
			var data:Object = new Object();
			data.action = action;
			data.params = params;
			var json:String = JSON.stringify(data);
			trace("callJavaFunctionMethod-params : ", json);
			return context.call("ShareSDKUtils", json);
		}
		
		private function javaCallback(e:StatusEvent):void {
			if (e.code == "SSDK_PA") {
				var json:String = e.level;
				trace (json);
				if (json == null) {
					return;
				}
				
				var resp:Object = JSON.parse(json);
				var platform:int = resp.platform;
				var action:int = resp.action; 		// 
				var status:int = resp.status; 		// Success = 1, Fail = 2, Cancel = 3
				var res:Object = resp.res;
				
				var error:Object = null;
				var user:Object = null;
				
				switch (status) {
					case ResponseState.SUCCESS: 
						onComplete(platform, action, res); 
						break;
					case ResponseState.FAIL:
						error = res;
						onError(platform, action, res); 
						break;
					case ResponseState.CANCEL: 
						onCancel(platform, action); 
						break;
				}
				
				//派发事件
				switch (action)
				{
					case Action.AUTHORIZE:
						
						var authEvt:AuthEvent = new AuthEvent(AuthEvent.STATUS);
						authEvt.platform = platform;
						authEvt.status = status;
						authEvt.error = error;
						this.dispatchEvent(authEvt);
						
						break;
					case Action.USER_INFO:
						
						var userEvt:UserInfoEvent = new UserInfoEvent(UserInfoEvent.STATUS);
						userEvt.platform = platform;
						userEvt.status = status;
						userEvt.error = error;
						if (userEvt.status == ResponseState.SUCCESS && res)
						{
							userEvt.data = res;
						}
						
						this.dispatchEvent(userEvt);
						
						break;
					case Action.SHARE:
						
						var shareEvt:ShareEvent = new ShareEvent(ShareEvent.STATUS);
						shareEvt.platform = platform;
						shareEvt.status = status;
						shareEvt.error = error;
						if (shareEvt.status == ResponseState.SUCCESS && res)
						{
							shareEvt.end = res.end;
							shareEvt.data = res.data;
						}
						
						this.dispatchEvent(shareEvt);
						
						break;
				}
			}
		}
		
		/**
		 * 回调事件处理器 
		 * @param event	事件对象
		 * 
		 */		
		private function openURLHandler(event:InvokeEvent):void
		{
			if (event.arguments.length > 0)
			{
				var url:String = event.arguments[0] as String;
				var sourceApplication:String = event.arguments[1] as String;
				var annotation:String = event.arguments[2] as String;
				
				var params:Object = new Object();
				params["url"] = url;
				params["source_app"] = sourceApplication;
				params["annotation"] = annotation;
				
				callJavaFunction("handleOpenURL", params);
			}
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			context.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * @inheritDoc
		 * 
		 */	
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			context.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * @inheritDoc
		 * 
		 */	
		public function dispatchEvent(event:Event):Boolean
		{
			return context.dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 * 
		 */	
		public function hasEventListener(type:String):Boolean
		{
			return context.hasEventListener(type);
		}
		
		/**
		 * @inheritDoc
		 * 
		 */	
		public function willTrigger(type:String):Boolean
		{
			return context.willTrigger(type);
		}
		
		/**
		 * 设置平台回调监听
		 * @param onComplete	完成
		 * @param onError		错误
		 * @param onCancel		取消
		 * 
		 */		
		public function setPlatformActionListener(onComplete:Function, onError:Function, onCancel:Function):void {
			this.onCom = onComplete;
			this.onErr = onError;
			this.onCan = onCancel;
		}
		
		/**
		 * 初始化SDK 
		 * @param appkey	应用Key
		 * @param enableStatistics	统计开关
		 * 
		 */		
		public function open(appkey:String = null, enableStatistics:Boolean = true):void {
			var params:Object = new Object();
			params.appkey = appkey;
			params.enableStatistics = enableStatistics;
			callJavaFunction(NativeMethodName.OPEN, params);
		}
		
		/**
		 * 关闭SDK 
		 * 
		 */		
		public function close():void {
			callJavaFunction(NativeMethodName.CLOSE);
		}
		
		public function setPlatformConfig(platform:int,config:Object):void {
			var params:Object = new Object();
			params.platform = platform;
			params.config = config;
			callJavaFunction(NativeMethodName.SET_PLATFORM_CONF, params);
		}
		
		public function authorize(platform:int):void {
			var params:Object = new Object();
			params.platform = platform;
			callJavaFunction(NativeMethodName.AUTHORIZE, params);
			
		}
		
		public function cancelAuthorie(platform:int):void {
			var params:Object = new Object();
			params.platform = platform;
			callJavaFunction(NativeMethodName.REMOVE_AUTHORIZATION, params);
		}
		
		public function hasAuthorized(platform:int):Boolean {
			var params:Object = new Object();
			params.platform = platform;
			var obj:Object = callJavaFunction(NativeMethodName.IS_VALID, params);	
			trace("this is hasAuthorized-json :",obj);				
			if (obj == null){
				return false;
			}
			else 
			{
				return obj;
			}
}
		
		public function checkClient(platform:int):Boolean {
			var params:Object = new Object();
			params.platform = platform;
			var obj:Object = callJavaFunction(NativeMethodName.CHECK_CLIENT, params);	
			trace("this is checkClient :",obj);				
			if (obj == null){
				return false;
			}
			else 
			{
				return obj;
			}
			
			
		}
		public function getUserInfo(platform:int):void {
			var params:Object = new Object();
			params.platform = platform;
			callJavaFunction(NativeMethodName.GET_USER_INFO, params);
		}
		
		public function shareContent(platform:int, shareParams:Object):void {
			var params:Object = new Object();
			params.platform = platform;
			params.shareParams = shareParams;
			callJavaFunction(NativeMethodName.SHARE, params);
		}
		
		public function oneKeyShareContent(platforms:Array, shareParams:Object):void {
			var params:Object = new Object();
			params.platforms = platforms;
			params.shareParams = shareParams;
			callJavaFunction(NativeMethodName.MULTI_SHARE, params);
		}
		
		public function showShareMenu(platforms:Array = null, shareParams:Object = null, x:Number = 0, y:Number = 0, direction:int = 0x0f):void {
			var params:Object = new Object();
			params.platforms = platforms;
			params.shareParams = shareParams;
			params.x = x;
			params.y = y;
			params.direction = direction;
			callJavaFunction(NativeMethodName.ONE_KEY_SHARE, params);
		}
		
		public function showShareView(platform:int, shareParams:Object = null):void {
			var params:Object = new Object();
			params.platform = platform;
			params.shareParams = shareParams;
			callJavaFunction(NativeMethodName.SHOW_SHARE_VIEW, params);
		}
		
		public function toast(message:String):void {
			var params:Object = new Object();
			params.message = message;
			callJavaFunction("toast", params);
		}
		//path 由string改为 Object
		public function screenshot():String {
			var path:Object = callJavaFunction("screenshot");
			return path.path;
		}
		
		public function onComplete(platform:int, action:int, res:Object):void {
			if (onCom != null) {
				onCom(platform, action, res);
			}
		}
		
		public function onCancel(platform:int, action:int):void {
			if (onCan != null) {
				onCan(platform, action);
			}
		}
		
		public function onError(platform:int, action:int, err:Object):void {
			if (onErr != null) {
				onErr(platform, action, err);
			}
		}
		
	}
	
}