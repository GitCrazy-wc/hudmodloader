package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol323")]
   public class HUDMessageItem extends HUDMessageItemBase
   {
      
      private var BaseTextFieldWidth:uint = 0;
      
      public function HUDMessageItem()
      {
         super();
         addFrameScript(4,this.frame5,18,this.frame19,123,this.frame124);
         this.BaseTextFieldWidth = this.MessageText_tf.width;
         this.MessageText_tf.autoSize = TextFieldAutoSize.LEFT;
         this.MessageText_tf.multiline = true;
      }
      
      private function get MessageText_tf() : TextField
      {
         return Internal_mc.MessageText_tf as TextField;
      }
      
      private function get RadioStationIcon_mc() : MovieClip
      {
         return Internal_mc.RadioStationIcon_mc as MovieClip;
      }
      
      public function CalcIconWidth() : uint
      {
         var iconDeltaX:uint = 0;
         if(m_Data.data.isRadioStation)
         {
            iconDeltaX += this.RadioStationIcon_mc.width + 2;
         }
         return iconDeltaX;
      }
      
      override public function redrawUIComponent() : void
      {
         var iconWidth:uint = 0;
         if(data)
         {
            visible = true;
            this.RadioStationIcon_mc.visible = m_Data.data.isRadioStation;
            iconWidth = this.CalcIconWidth();
            this.MessageText_tf.width = this.BaseTextFieldWidth - iconWidth;
            this.MessageText_tf.x = iconWidth;
            TextFieldEx.setNoTranslate(this.MessageText_tf,true);
            GlobalFunc.SetText(this.MessageText_tf,m_Data.data.messageText,true);
         }
         else
         {
            visible = false;
         }
      }
      
      internal function frame5() : *
      {
         stop();
      }
      
      internal function frame19() : *
      {
         dispatchEvent(new Event("HUDFadingListItem::FadeInComplete",true,true));
         stop();
      }
      
      internal function frame124() : *
      {
         dispatchEvent(new Event("HUDFadingListItem::FadeOutComplete",true,true));
         stop();
      }
   }
}

