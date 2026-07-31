package
{
   import Shared.AS3.BSButtonHintBar;
   import Shared.AS3.BSButtonHintData;
   import Shared.AS3.Events.PlatformChangeEvent;
   import flash.events.Event;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol259")]
   public class HUDMessageItemRecentActivity extends HUDMessageItemBase
   {
      
      public static const EVENT_ON_FADE_OUT_COMPLETE:* = "HUDMessage::RecentActivityOnFadeOutComplete";
      
      public static const EVENT_ON_FADE_IN_COMPLETE:* = "HUDMessage::RecentActivityOnFadeInComplete";
      
      public static const EVENT_JOIN:* = "HUDMessage::RecentActivityJoin";
      
      public var ButtonHintBar_mc:BSButtonHintBar;
      
      private var m_DownButton:BSButtonHintData;
      
      public function HUDMessageItemRecentActivity(auiPlatform:uint = 0)
      {
         super();
         addFrameScript(4,this.frame5,15,this.frame16,177,this.frame178);
         TextFieldEx.setTextAutoSize(Internal_mc.TitleText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(Internal_mc.BodyText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         Internal_mc.Icon_mc.clipWidth = Internal_mc.Icon_mc.width;
         Internal_mc.Icon_mc.clipHeight = Internal_mc.Icon_mc.height;
         Internal_mc.Icon_mc.clipScale = 1;
         Internal_mc.Icon_mc.clipXOffset = Internal_mc.Icon_mc.clipWidth / 2;
         Internal_mc.Icon_mc.clipYOffset = Internal_mc.Icon_mc.clipHeight / 2;
         this.m_DownButton = new BSButtonHintData("$JoinEvent","G","_DPad_Down","_DPad_Down",1,null,EVENT_JOIN,auiPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE ? "Emotes" : "QuickkeyDown");
         this.m_DownButton.canHold = true;
         this.ButtonHintBar_mc = Internal_mc.ButtonHintBar_mc;
         this.ButtonHintBar_mc.SetButtonHintData(new <BSButtonHintData>[this.m_DownButton]);
         this.m_DownButton.ButtonVisible = false;
      }
      
      override public function redrawUIComponent() : void
      {
         var icon:String = null;
         if(Boolean(data) && Boolean(data.data))
         {
            this.m_DownButton.ButtonVisible = false;
            Internal_mc.gotoAndStop(m_ShowBottomRight ? "bottomRight" : "default");
            visible = true;
            icon = "";
            switch(data.type)
            {
               case HUDMessageItemData.TYPE_DAILY_OPS:
                  Internal_mc.Icon_mc.clipWidth = Internal_mc.Icon_mc.width;
                  Internal_mc.Icon_mc.clipHeight = Internal_mc.Icon_mc.height;
                  icon = "DOMode_Uplink2";
                  break;
               case HUDMessageItemData.TYPE_MUTATED_EVENT:
                  Internal_mc.Icon_mc.clipWidth = Internal_mc.Icon_mc.width * 0.75;
                  Internal_mc.Icon_mc.clipHeight = Internal_mc.Icon_mc.height * 0.75;
                  icon = "InWorldMutatedPublicEventIcon";
                  break;
               case HUDMessageItemData.TYPE_RAID:
                  Internal_mc.Icon_mc.clipWidth = Internal_mc.Icon_mc.width;
                  Internal_mc.Icon_mc.clipHeight = Internal_mc.Icon_mc.height;
                  icon = "RaidEventIcon";
                  break;
               case HUDMessageItemData.TYPE_INFESTATION:
                  Internal_mc.Icon_mc.clipWidth = Internal_mc.Icon_mc.width;
                  Internal_mc.Icon_mc.clipHeight = Internal_mc.Icon_mc.height;
                  icon = "InfestationIcon";
                  this.m_DownButton.ButtonVisible = true;
                  this.m_DownButton.DispatchDataID = data.data.recentActivityId;
            }
            Internal_mc.Icon_mc.setContainerIconClip(icon);
            Internal_mc.TitleText_tf.text = data.data.titleText;
            Internal_mc.TitleText_tf.text = Internal_mc.TitleText_tf.text.toUpperCase();
            Internal_mc.BodyText_tf.text = data.data.messageText;
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

