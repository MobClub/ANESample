package cn.sharesdk.ane.events
{
	import flash.events.Event;
	
	/**
	 * 分享事件 
	 * @author vim888
	 * 
	 */	
	public class ShareEvent extends Event
	{
		public function ShareEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * 分享状态变更 
		 */		
		public static const STATUS:String = "share_status";
		
		private var _platform:int;
		private var _status:int;
		private var _error:Object;
		private var _data:Object;
		private var _end:Boolean;

		/**
		 * 获取是否分享结束标识 
		 * @return 分享结束标识
		 * 
		 */		
		public function get end():Boolean
		{
			return _end;
		}
	
		/**
		 * 设置是否分享结束标识 
		 * @param value 分享结束标识
		 * 
		 */		
		public function set end(value:Boolean):void
		{
			_end = value;
		}
		
		/**
		 * 获取分享数据 
		 * @return 分享数据
		 * 
		 */		
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * 设置分享数据 
		 * @param value	分享数据
		 * 
		 */		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		/**
		 * 获取错误信息 
		 * @return 错误信息
		 * 
		 */		
		public function get error():Object
		{
			return _error;
		}
		
		/**
		 * 设置错误信息 
		 * @param value	错误信息
		 * 
		 */		
		public function set error(value:Object):void
		{
			_error = value;
		}
		
		/**
		 * 获取分享状态 
		 * @return 分享状态，参考ResponseState
		 * 
		 */		
		public function get status():int
		{
			return _status;
		}
		
		/**
		 * 设置分享状态 
		 * @param value 分享状态
		 * 
		 */		
		public function set status(value:int):void
		{
			_status = value;
		}
		
		/**
		 * 获取平台类型 
		 * @return 平台类型
		 * 
		 */		
		public function get platform():int
		{
			return _platform;
		}
		
		/**
		 * 设置平台类型 
		 * @param value 平台类型
		 * 
		 */		
		public function set platform(value:int):void
		{
			_platform = value;
		}

	}
}