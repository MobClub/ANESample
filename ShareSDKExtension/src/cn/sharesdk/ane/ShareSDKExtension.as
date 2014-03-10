package cn.sharesdk.ane {
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	public class ShareSDKExtension {
		private var context:ExtensionContext;
		private var onCom:Function;
		private var onErr:Function;
		private var onCan:Function;
		
		public function ShareSDKExtension() {
			context = ExtensionContext.createExtensionContext("ShareSDKExtension","");
			context.addEventListener(StatusEvent.STATUS, javaCallback);
		}
		
		private function callJavaFunction(action:String, params:Object = null):String {
			var data:Object = new Object();
			data.action = action;
			data.params = params;
			var json:String = JSON.stringify(data);
			return context.call("ShareSDKUtils", json) as String;
		}
		
		private function javaCallback(e:StatusEvent):void {
			if (e.code == "SSDK_PA") {
				var json:String = e.level;
				if (json == null) {
					return;
				}
				
				var resp:Object = JSON.parse(json);
				var platform:int = resp.platform;
				var action:int = resp.action;
				var status:int = resp.status; // Success = 1, Fail = 2, Cancel = 3
				var res:Object = resp.res;
				switch (status) {
					case 1: onComplete(platform, action, res); break;
					case 2: onError(platform, action, res); break;
					case 3: onCancel(platform, action); break;
				}
			}
		}
		
		public function setPlatformActionListener(onComplete:Function, onError:Function, onCancel:Function):void {
			this.onCom = onComplete;
			this.onErr = onError;
			this.onCan = onCancel;
		}
		
		public function open(appkey:String = null, enableStatistics:Boolean = true):void {
			var params:Object = new Object();
			params.appkey = appkey;
			params.enableStatistics = enableStatistics;
			callJavaFunction(PlatformAction.ACTION_OPEN, params);
		}
		
		public function close():void {
			callJavaFunction(PlatformAction.ACTION_CLOSE);
		}
		
		public function setPlatformConfig(platform:int,config:Object):void {
			var params:Object = new Object();
			params.platform = platform;
			params.config = config;
			callJavaFunction(PlatformAction.ACTION_SET_PLATFORM_CONF, params);
		}
		
		public function authorize(platform:int):void {
			var params:Object = new Object();
			params.platform = platform;
			callJavaFunction(PlatformAction.ACTION_AUTHORIZE, params);
		}
		
		public function cancelAuthorie(platform:int):void {
			var params:Object = new Object();
			params.platform = platform;
			callJavaFunction(PlatformAction.ACTION_REMOVE_AUTHORIZATION, params);
		}
		
		public function hasAuthorized(platform:int):Boolean {
			var params:Object = new Object();
			params.platform = platform;
			var json:String = callJavaFunction(PlatformAction.ACTION_ISVALID, params);
			if (json == null) {
				return false;
			}
			var res:Object = JSON.parse(json);
			return res.isValid;
		}
		
		public function getUserInfo(platform:int):void {
			var params:Object = new Object();
			params.platform = platform;
			callJavaFunction(PlatformAction.ACTION_GET_USER_INFO, params);
		}
		
		public function shareContent(platform:int, shareParams:Object):void {
			var params:Object = new Object();
			params.platform = platform;
			params.shareParams = shareParams;
			callJavaFunction(PlatformAction.ACTION_SHARE, params);
		}
		
		public function oneKeyShareContent(platforms:Array, shareParams:Object):void {
			var params:Object = new Object();
			params.platforms = platforms;
			params.shareParams = shareParams;
			callJavaFunction(PlatformAction.ACTION_MULTI_SHARE, params);
		}
		
		public function showShareMenu(platforms:Array = null, shareParams:Object = null):void {
			var params:Object = new Object();
			params.platforms = platforms;
			params.shareParams = shareParams;
			callJavaFunction(PlatformAction.ACTION_ONE_KEY_SHARE, params);
		}
		
		public function showShareView(platforms:Array = null, shareParams:Object = null):void {
			var params:Object = new Object();
			params.platforms = platforms;
			params.shareParams = shareParams;
			callJavaFunction(PlatformAction.ACTION_SHOW_SHARE_VIEW, params);
		}
		
		public function toast(message:String):void {
			var params:Object = new Object();
			params.message = message;
			callJavaFunction("toast", params);
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