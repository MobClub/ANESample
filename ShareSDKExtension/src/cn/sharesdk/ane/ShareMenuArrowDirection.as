package cn.sharesdk.ane
{
	public class ShareMenuArrowDirection
	{
		/**
		 * 箭头向上 
		 */		
		public static const Up:uint = 1 << 0;
		
		/**
		 * 箭头向下 
		 */		
		public static const Down:uint = 1 << 1;
		
		/**
		 * 箭头向左 
		 */		
		public static const Left:uint = 1 << 2;
		
		/**
		 * 箭头向右 
		 */		
		public static const Right:uint = 1 << 3;
		
		/**
		 * 任意方向 
		 */		
		public static const Any:uint = ShareMenuArrowDirection.Up | ShareMenuArrowDirection.Down | ShareMenuArrowDirection.Left | ShareMenuArrowDirection.Right;
		
		/**
		 * 未知方向 
		 */		
		public static const Unkonwn:uint = uint.MAX_VALUE;
	}
}