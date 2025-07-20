package
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class CustomButton extends Sprite
   {
      
      private var bg:Shape = new Shape();
      
      private var labelField:TextField = new TextField();
      
      private var tf:TextFormat = new TextFormat("Arial",14,0);
      
      private var _label:String;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _padding:Number = 10;
      
      private var _cornerRadius:Number = 8;
      
      private var _bgColor:uint = 13421772;
      
      private var _hoverColor:uint = 11184810;
      
      private var _downColor:uint = 8947848;
      
      private var _currentBgColor:uint = _bgColor;
      
      public function CustomButton(label:String, width:Number = 120, height:Number = 40)
      {
         super();
         this._label = label;
         this._width = width;
         this._height = height;
         this._currentBgColor = _bgColor;
         buttonMode = true;
         mouseChildren = false;
         addChild(bg);
         addChild(labelField);
         setupLabel();
         redraw();
         addEventListener(MouseEvent.MOUSE_OVER,onOver);
         addEventListener(MouseEvent.MOUSE_OUT,onOut);
         addEventListener(MouseEvent.MOUSE_DOWN,onDown);
         addEventListener(MouseEvent.MOUSE_UP,onUp);
      }
      
      private function setupLabel() : void
      {
         labelField.defaultTextFormat = tf;
         labelField.text = _label;
         labelField.wordWrap = true;
         labelField.multiline = true;
         labelField.selectable = false;
         labelField.mouseEnabled = false;
      }
      
      private function redraw() : void
      {
         bg.graphics.clear();
         bg.graphics.beginFill(_currentBgColor);
         bg.graphics.drawRoundRect(0,0,_width,_height,_cornerRadius);
         bg.graphics.endFill();
         labelField.text = _label;
         labelField.width = _width - 2 * _padding;
         labelField.height = labelField.textHeight + 4;
         labelField.x = (_width - labelField.width) / 2;
         labelField.y = (_height - labelField.height) / 2;
      }
      
      private function onOver(e:MouseEvent) : void
      {
         _currentBgColor = _hoverColor;
         redraw();
      }
      
      private function onOut(e:MouseEvent) : void
      {
         _currentBgColor = _bgColor;
         redraw();
      }
      
      private function onDown(e:MouseEvent) : void
      {
         _currentBgColor = _downColor;
         redraw();
      }
      
      private function onUp(e:MouseEvent) : void
      {
         _currentBgColor = _hoverColor;
         redraw();
      }
      
      public function set label(text:String) : void
      {
         _label = text;
         redraw();
      }
      
      public function get label() : String
      {
         return _label;
      }
      
      override public function set width(value:Number) : void
      {
         _width = value;
         redraw();
      }
      
      override public function get width() : Number
      {
         return _width;
      }
      
      override public function set height(value:Number) : void
      {
         _height = value;
         redraw();
      }
      
      override public function get height() : Number
      {
         return _height;
      }
   }
}

