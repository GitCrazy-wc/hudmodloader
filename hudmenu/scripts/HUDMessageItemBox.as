package
{
   import Shared.GlobalFunc;
   import flash.events.Event;
   import flash.text.TextFieldAutoSize;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol317")]
   public class HUDMessageItemBox extends HUDMessageItemBase
   {
      
      public function HUDMessageItemBox()
      {
         super();
         addFrameScript(4,this.frame5,15,this.frame16,177,this.frame178);
         Internal_mc.BodyText_tf.autoSize = TextFieldAutoSize.LEFT;
         Internal_mc.BodyText_tf.multiline = true;
      }
      
      override public function redrawUIComponent() : void
      {
         if(data)
         {
            Internal_mc.gotoAndStop(m_ShowBottomRight ? "bottomRight" : "default");
            visible = true;
            GlobalFunc.SetText(Internal_mc.HeaderText_tf,m_Data.data.headerText,true);
            GlobalFunc.SetText(Internal_mc.TitleText_tf,m_Data.data.titleText,true);
            GlobalFunc.SetText(Internal_mc.BodyText_tf,m_Data.data.messageText,true);
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
      
      internal function frame16() : *
      {
         dispatchEvent(new Event("HUDFadingListItem::FadeInComplete",true));
         stop();
      }
      
      internal function frame178() : *
      {
         dispatchEvent(new Event("HUDFadingListItem::FadeOutComplete",true));
         stop();
      }
   }
}

