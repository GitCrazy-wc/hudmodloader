package
{
   import Shared.GlobalFunc;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import scaleform.gfx.TextFieldEx;
   
   public class HUDButton extends Sprite
   {
      
      private var textLabel:TextField;
      
      private var background:Shape;
      
      private var arrow:Shape;
      
      private var _textFormat:TextFormat;
      
      private var _selectFormat:TextFormat;
      
      private var _disabledFormat:TextFormat;
      
      private var _disabledSelectFormat:TextFormat;
      
      private var _text:String;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _textColor:uint;
      
      private var _backgroundColor:uint;
      
      private var _backgroundAlpha:Number = 0.75;
      
      private var _selectColor:uint;
      
      private var _selectBGColor:uint;
      
      private var _pushedBGColor:uint;
      
      private var _disabledColor:uint;
      
      private var _disabledBGColor:uint;
      
      private var _borderThickness:Number = 2;
      
      private var _hasSubmenu:Boolean = false;
      
      private var _hasAction:Boolean = false;
      
      private var _isSelected:Boolean = false;
      
      private var _isDisabled:Boolean = false;
      
      private var _isPushed:Boolean = false;
      
      private var _padding:Number = 6;
      
      private var _cornerRadius:Number = 4;
      
      private var _fontSize:Number = 18;
      
      private var _tag:String = "";
      
      private var _timeout:Number = 0;
      
      private var _timeoutTimer:Timer = null;
      
      public function HUDButton(w:Number = 150, h:Number = 30)
      {
         super();
         this.textLabel = new TextField();
         this.background = new Shape();
         this.arrow = new Shape();
         this._textColor = SharedUtils.calcColor(255,255,200);
         this._backgroundColor = SharedUtils.calcColor(61,61,61);
         this._selectColor = SharedUtils.calcColor(0,0,0);
         this._selectBGColor = SharedUtils.calcColor(255,220,100);
         this._pushedBGColor = SharedUtils.multColor(this._selectBGColor,0.6);
         this._disabledColor = SharedUtils.calcColor(200,200,200);
         this._disabledBGColor = SharedUtils.calcColor(41,41,41);
         this._width = w;
         this._height = h;
         mouseChildren = false;
         this.formatTextField(this.textLabel);
         addChild(this.background);
         addChild(this.arrow);
         addChild(this.textLabel);
      }
      
      public function setInfo(tag:String, enabled:Boolean, hasSubmenu:Boolean, timeout:Number = 0) : *
      {
         this._tag = tag;
         this._hasSubmenu = hasSubmenu;
         this._timeout = timeout;
         this.isDisabled = !enabled;
         if(this._timeoutTimer != null)
         {
            this._timeoutTimer.stop();
         }
         if(this._timeout > 0)
         {
            this._timeoutTimer = new Timer(this._timeout,1);
            this._timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.timeoutComplete);
         }
      }
      
      public function click() : Boolean
      {
         var result:Boolean = false;
         if(this._tag != null && this._tag.length > 0)
         {
            if(!this.isDisabled)
            {
               result = true;
               if(this._timeout > 0)
               {
                  this._timeoutTimer.reset();
                  this._timeoutTimer.start();
                  isDisabled = true;
               }
               else
               {
                  isDisabled = true;
               }
            }
         }
         return result;
      }
      
      private function timeoutComplete(param1:TimerEvent) : void
      {
         if(isDisabled)
         {
            isDisabled = false;
         }
      }
      
      public function setColors(textColor:String = "ffffc8", bgColor:String = "3d3d3d", bgAlpha:Number = 0.75, selectColor:String = "000000", selectBGColor:String = "ffdc64") : *
      {
         if(textColor.length > 0)
         {
            this._textColor = uint("0x" + textColor);
         }
         if(bgColor.length > 0)
         {
            this._backgroundColor = uint("0x" + bgColor);
         }
         if(bgAlpha >= 0)
         {
            this._backgroundAlpha = bgAlpha;
         }
         if(selectColor.length > 0)
         {
            this._selectColor = uint("0x" + selectColor);
         }
         if(selectBGColor.length > 0)
         {
            this._selectBGColor = uint("0x" + selectBGColor);
         }
         this._pushedBGColor = SharedUtils.multColor(this._selectBGColor,0.6);
         this._textFormat = new TextFormat("$MAIN_Font_Bold",this._fontSize,this._textColor);
         this._textFormat.align = "center";
         this._selectFormat = new TextFormat("$MAIN_Font_Bold",this._fontSize,this._selectColor);
         this._selectFormat.align = "center";
         this.DrawUpdate();
      }
      
      private function DrawUpdate() : void
      {
         this.background.alpha = this._backgroundAlpha;
         this.background.graphics.clear();
         this.arrow.graphics.clear();
         if(_borderThickness > 0)
         {
            if(isPushed)
            {
               this.background.graphics.lineStyle(_borderThickness,_pushedBGColor,1);
            }
            else if(isSelected)
            {
               this.background.graphics.lineStyle(_borderThickness,_selectBGColor,1);
            }
            else
            {
               this.background.graphics.lineStyle(_borderThickness,_textColor,1);
            }
         }
         else
         {
            this.background.graphics.lineStyle();
         }
         if(isDisabled && isSelected)
         {
            this.background.graphics.beginFill(_disabledColor);
            this.arrow.graphics.beginFill(_disabledBGColor);
         }
         else if(isDisabled)
         {
            this.background.graphics.beginFill(_disabledBGColor);
            this.arrow.graphics.beginFill(_disabledColor);
         }
         else if(isPushed)
         {
            this.background.graphics.beginFill(_pushedBGColor);
            this.arrow.graphics.beginFill(_selectColor);
         }
         else if(isSelected)
         {
            this.background.graphics.beginFill(_selectBGColor);
            this.arrow.graphics.beginFill(_selectColor);
         }
         else
         {
            this.background.graphics.beginFill(_backgroundColor);
            this.arrow.graphics.beginFill(_textColor);
         }
         this.background.graphics.drawRoundRect(0,0,this._width,this._height,this._cornerRadius,this._cornerRadius);
         if(this._hasSubmenu)
         {
            this.arrow.graphics.moveTo(this._width - 12,this._height / 2 - 6);
            this.arrow.graphics.lineTo(this._width - 2,this._height / 2);
            this.arrow.graphics.lineTo(this._width - 12,this._height / 2 + 6);
         }
         this.background.graphics.endFill();
         this.arrow.graphics.endFill();
         this.textLabel.x = 10;
         this.textLabel.y = 0;
         this.textLabel.width = _width - 20;
         this.textLabel.height = _height;
         if(isDisabled && isSelected)
         {
            this.textLabel.defaultTextFormat = this._disabledSelectFormat;
            this.textLabel.setTextFormat(this._disabledSelectFormat);
         }
         else if(isDisabled)
         {
            this.textLabel.defaultTextFormat = this._disabledFormat;
            this.textLabel.setTextFormat(this._disabledFormat);
         }
         else if(isSelected || isPushed)
         {
            this.textLabel.defaultTextFormat = this._selectFormat;
            this.textLabel.setTextFormat(this._selectFormat);
         }
         else
         {
            this.textLabel.defaultTextFormat = this._textFormat;
            this.textLabel.setTextFormat(this._textFormat);
         }
         TextFieldEx.setVerticalAlign(this.textLabel,TextFieldEx.VALIGN_CENTER);
         TextFieldEx.setTextAutoSize(this.textLabel,TextFieldEx.TEXTAUTOSZ_SHRINK);
         GlobalFunc.SetText(textLabel,_text);
      }
      
      private function formatTextField(tf:TextField) : void
      {
         this._textFormat = new TextFormat("$MAIN_Font_Bold",this._fontSize,this._textColor);
         this._textFormat.align = "center";
         this._selectFormat = new TextFormat("$MAIN_Font_Bold",this._fontSize,this._selectColor);
         this._selectFormat.align = "center";
         this._disabledFormat = new TextFormat("$MAIN_Font_Bold",this._fontSize,this._disabledColor);
         this._disabledFormat.align = "center";
         this._disabledSelectFormat = new TextFormat("$MAIN_Font_Bold",this._fontSize,this._disabledBGColor);
         this._disabledSelectFormat.align = "center";
         tf.width = _width;
         tf.height = _height;
         tf.defaultTextFormat = this._textFormat;
         tf.setTextFormat(this._textFormat);
         TextFieldEx.setVerticalAlign(tf,TextFieldEx.VALIGN_CENTER);
         TextFieldEx.setTextAutoSize(tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function get text() : String
      {
         return _text;
      }
      
      public function set text(value:String) : void
      {
         _text = value;
         this.DrawUpdate();
      }
      
      override public function get width() : Number
      {
         return _width;
      }
      
      override public function set width(value:Number) : void
      {
         _width = value;
         this.DrawUpdate();
      }
      
      override public function get height() : Number
      {
         return _height;
      }
      
      override public function set height(value:Number) : void
      {
         _height = value;
         this.DrawUpdate();
      }
      
      public function get isSelected() : Boolean
      {
         return _isSelected;
      }
      
      public function set isSelected(value:Boolean) : void
      {
         _isSelected = value;
         this.DrawUpdate();
      }
      
      public function get isDisabled() : Boolean
      {
         return _isDisabled;
      }
      
      public function set isDisabled(value:Boolean) : void
      {
         _isDisabled = value;
         this.DrawUpdate();
      }
      
      public function get isPushed() : Boolean
      {
         return _isPushed;
      }
      
      public function set isPushed(value:Boolean) : void
      {
         _isPushed = value;
         this.DrawUpdate();
      }
   }
}

