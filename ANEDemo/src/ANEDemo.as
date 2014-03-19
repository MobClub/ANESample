package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import cn.sharesdk.ane.PlatformID;
	import cn.sharesdk.ane.ShareSDKExtension;
	import cn.sharesdk.ane.ShareType;
	
	public class ANEDemo extends Sprite
	{
		public function ANEDemo()
		{
			super();
			
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			shareSDK.open("iosv1101");
			shareSDK.setPlatformActionListener(onComplete, onError, onCancel);
		}
		
		private static const BUTTON_WIDTH:Number = 260;
		private static const BUTTON_HEIGHT:Number = 80;
		
		private var shareSDK:ShareSDKExtension = new ShareSDKExtension();
		
		private function addedToStageHandler(event:Event):void
		{
			var authBtn:Button = new Button();
			authBtn.label = "授权";
			authBtn.x = 100;
			authBtn.y = 20;
			authBtn.width = BUTTON_WIDTH;
			authBtn.height = BUTTON_HEIGHT;
			this.addChild(authBtn);
			authBtn.addEventListener(MouseEvent.CLICK, authBtnClickHandler);
			
			var cancelAuthBtn:Button = new Button();
			cancelAuthBtn.label = "取消授权";
			cancelAuthBtn.x = 100;
			cancelAuthBtn.y = authBtn.y + authBtn.height + 20;
			cancelAuthBtn.width = BUTTON_WIDTH;
			cancelAuthBtn.height = BUTTON_HEIGHT;
			this.addChild(cancelAuthBtn);
			cancelAuthBtn.addEventListener(MouseEvent.CLICK, cancelAuthBtnClickHandler);
			
			var hasAuthBtn:Button = new Button();
			hasAuthBtn.label = "检测授权";
			hasAuthBtn.x = 100;
			hasAuthBtn.y = cancelAuthBtn.y + cancelAuthBtn.height + 20;
			hasAuthBtn.width = BUTTON_WIDTH;
			hasAuthBtn.height = BUTTON_HEIGHT;
			this.addChild(hasAuthBtn);
			hasAuthBtn.addEventListener(MouseEvent.CLICK, hasAuthBtnClickHandler);
			
			var getUserInfoBtn:Button = new Button();
			getUserInfoBtn.label = "获取用户资料";
			getUserInfoBtn.x = 100;
			getUserInfoBtn.y = hasAuthBtn.y + hasAuthBtn.height + 20;
			getUserInfoBtn.width = BUTTON_WIDTH;
			getUserInfoBtn.height = BUTTON_HEIGHT;
			this.addChild(getUserInfoBtn);
			getUserInfoBtn.addEventListener(MouseEvent.CLICK, getUserInfoBtnClickHandler);
			
			var shareBtn:Button = new Button();
			shareBtn.label = "分享";
			shareBtn.x = 100;
			shareBtn.y = getUserInfoBtn.y + getUserInfoBtn.height + 20;
			shareBtn.width = BUTTON_WIDTH;
			shareBtn.height = BUTTON_HEIGHT;
			this.addChild(shareBtn);
			shareBtn.addEventListener(MouseEvent.CLICK, shareBtnClickHandler);
			
			var oneKeyShareBtn:Button = new Button();
			oneKeyShareBtn.label = "一键分享";
			oneKeyShareBtn.x = 100;
			oneKeyShareBtn.y = shareBtn.y + shareBtn.height + 20;
			oneKeyShareBtn.width = BUTTON_WIDTH;
			oneKeyShareBtn.height = BUTTON_HEIGHT;
			this.addChild(oneKeyShareBtn);
			oneKeyShareBtn.addEventListener(MouseEvent.CLICK, oneKeyShareBtnClickHandler);
			
			var shareMenuBtn:Button = new Button();
			shareMenuBtn.label = "显示分享菜单";
			shareMenuBtn.x = 100;
			shareMenuBtn.y = oneKeyShareBtn.y + oneKeyShareBtn.height + 20;
			shareMenuBtn.width = BUTTON_WIDTH;
			shareMenuBtn.height = BUTTON_HEIGHT;
			this.addChild(shareMenuBtn);
			shareMenuBtn.addEventListener(MouseEvent.CLICK, shareMenuBtnClickHandler);
			
			var shareViewBtn:Button = new Button();
			shareViewBtn.label = "显示分享菜单";
			shareViewBtn.x = 100;
			shareViewBtn.y = shareMenuBtn.y + shareMenuBtn.height + 20;
			shareViewBtn.width = BUTTON_WIDTH;
			shareViewBtn.height = BUTTON_HEIGHT;
			this.addChild(shareViewBtn);
			shareViewBtn.addEventListener(MouseEvent.CLICK, shareViewBtnClickHandler);
		}
		
		public function onComplete(platform:int, action:String, res:Object):void {
			var json:String = (res == null ? "" : JSON.stringify(res));
			var message:String = "onComplete\nPlatform=" + platform + ", action=" + action + "\nres=" + json;
			shareSDK.toast(message);
		}
		
		public function onCancel(platform:int, action:String):void {
			var message:String = "onCancel\nPlatform=" + platform + ", action=" + action;
			shareSDK.toast(message);
		}
		
		public function onError(platform:int, action:String, err:Object):void {
			var json:String = (err == null ? "" : JSON.stringify(err));
			var message:String = "onError\nPlatform=" + platform + ", action=" + action + "\nres=" + json;
			shareSDK.toast(message);
		}
		
		private function authBtnClickHandler(event:MouseEvent):void
		{
			shareSDK.authorize(PlatformID.SinaWeibo);
		}
		
		private function cancelAuthBtnClickHandler(event:MouseEvent):void
		{
			shareSDK.cancelAuthorie(PlatformID.SinaWeibo);
		}
		
		private function hasAuthBtnClickHandler(event:MouseEvent):void
		{
			var isValid:Boolean = shareSDK.hasAuthorized(PlatformID.DouBan);
			shareSDK.toast("isValid = " + isValid);
		}
		
		private function getUserInfoBtnClickHandler(event:MouseEvent):void
		{
			shareSDK.getUserInfo(PlatformID.SinaWeibo);
		}
		
		private function shareBtnClickHandler(event:MouseEvent):void
		{
			var shareParams:Object = new Object();
			shareParams.title = "ShareSDK for ANE发布";
//			shareParams.titleUrl = "http://sharesdk.cn";
			shareParams.text = "好耶～好高兴啊～";
			shareParams.shareType = ShareType.SHARE_TEXT;
//			shareParams.imageUrl = "http://f1.sharesdk.cn/imgs/2014/02/26/owWpLZo_638x960.jpg";
//			shareParams.site = "ShareSDK";
//			shareParams.siteUrl = "http://sharesdk.cn";
			shareSDK.shareContent(PlatformID.WeChatSession, shareParams);
		}
		
		private function oneKeyShareBtnClickHandler(event:MouseEvent):void
		{
			var platforms:Array = new Array(PlatformID.SinaWeibo, PlatformID.TencentWeibo);
			var shareParams:Object = new Object();
			shareParams.title = "ShareSDK for ANE发布";
			shareParams.titleUrl = "http://sharesdk.cn";
			shareParams.text = "好耶～好高兴啊～";
			shareParams.imageUrl = "http://f1.sharesdk.cn/imgs/2014/02/26/owWpLZo_638x960.jpg";
			shareParams.site = "ShareSDK";
			shareParams.siteUrl = "http://sharesdk.cn";
			shareSDK.oneKeyShareContent(platforms, shareParams);
		}
		
		private function shareMenuBtnClickHandler(event:MouseEvent):void
		{
			var shareParams:Object = new Object();
			shareParams.title = "ShareSDK for ANE发布";
			shareParams.titleUrl = "http://sharesdk.cn";
			shareParams.text = "好耶～好高兴啊～";
			shareParams.imageUrl = "http://f1.sharesdk.cn/imgs/2014/02/26/owWpLZo_638x960.jpg";
			shareParams.site = "ShareSDK";
			shareParams.siteUrl = "http://sharesdk.cn";
			shareSDK.showShareMenu(null, shareParams);
		}
		
		private function shareViewBtnClickHandler(event:MouseEvent):void
		{
			var shareParams:Object = new Object();
			shareParams.title = "ShareSDK for ANE发布";
			shareParams.titleUrl = "http://sharesdk.cn";
			shareParams.text = "好耶～好高兴啊～";
			shareParams.imageUrl = "http://f1.sharesdk.cn/imgs/2014/02/26/owWpLZo_638x960.jpg";
			shareParams.site = "ShareSDK";
			shareParams.siteUrl = "http://sharesdk.cn";
			var platforms:Array = new Array();
			platforms[0] = PlatformID.TencentWeibo;
			shareSDK.showShareView(PlatformID.SinaWeibo, shareParams);
		}
	}
}