package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Button extends Sprite
	{
		public function Button()
		{
			super();
			
			this.graphics.beginFill(0xcccccc, 1);
			this.graphics.drawRect(0, 0, 300, 80);
			this.graphics.endFill();
			
			_label = new TextField();
			_label.background = false;
			_label.width = 200;
			_label.height = 60;
			
			this.addChild(_label);
		}
		
		private var _label:TextField;
		
		public function set label(value:String):void
		{
			_label.text = value;
			
			var format:TextFormat = new TextFormat();
			format.align = TextFormatAlign.CENTER;
			format.size = 40;
			_label.setTextFormat(format);
			
			_label.x = (this.width - _label.textWidth) / 2;
			_label.y = (this.height - _label.textHeight) / 2;
			_label.width = _label.textWidth;
			_label.height = _label.textHeight;
		}
		
		public function get label():String
		{
			return _label.text;
		}
	
	}
}