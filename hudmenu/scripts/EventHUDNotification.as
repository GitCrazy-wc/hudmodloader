package
{
   import flash.display.MovieClip;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol794")]
   public class EventHUDNotification extends MovieClip
   {
      
      public static const EVENT_STW_COMBAT_TAG:String = "[#STW_COMBAT]";
      
      public static const EVENT_STW_TWIST_TAG:String = "[#STW_TWIST]";
      
      public static const EVENT_STW_BOSS_TAG:String = "[#STW_BOSS]";
      
      public static const EVENT_STW_COMPLETE_TAG:String = "[#STW_COMPLETE]";
      
      public static const EVENT_STW_FREEBIE_TAG:String = "[#STW_FREEBIE]";
      
      public var EventHUDNotificationAnim_mc:MovieClip;
      
      private var STWEventType_mc:MovieClip;
      
      public function EventHUDNotification()
      {
         super();
         addFrameScript(0,this.frame1,38,this.frame39,69,this.frame70);
         this.STWEventType_mc = this.EventHUDNotificationAnim_mc.STWEventType_mc;
         TextFieldEx.setTextAutoSize(this.STWEventType_mc.ENHeaderText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.STWEventType_mc.ENDynamicText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function isEventNotification(aText:String) : Boolean
      {
         return aText.indexOf(EVENT_STW_COMBAT_TAG) != -1 || aText.indexOf(EVENT_STW_TWIST_TAG) != -1 || aText.indexOf(EVENT_STW_BOSS_TAG) != -1 || aText.indexOf(EVENT_STW_COMPLETE_TAG) != -1 || aText.indexOf(EVENT_STW_FREEBIE_TAG) != -1;
      }
      
      public function setData(aEvent:Object) : void
      {
         var markupRemovedCombatText:String = null;
         var markupRemovedTwistText:String = null;
         var markupRemovedBossText:String = null;
         var markupRemovedCompleteText:String = null;
         var markupRemovedFreebieText:String = null;
         if(aEvent.messageText.indexOf(EVENT_STW_COMBAT_TAG) != -1)
         {
            this.STWEventType_mc.gotoAndStop("STW_Combat");
            markupRemovedCombatText = aEvent.messageText.replace(EVENT_STW_COMBAT_TAG,"");
            this.STWEventType_mc.ENDynamicText_tf.text = markupRemovedCombatText;
         }
         else if(aEvent.messageText.indexOf(EVENT_STW_TWIST_TAG) != -1)
         {
            this.STWEventType_mc.gotoAndStop("STW_Twist");
            markupRemovedTwistText = aEvent.messageText.replace(EVENT_STW_TWIST_TAG,"");
            this.STWEventType_mc.ENDynamicText_tf.text = markupRemovedTwistText;
         }
         else if(aEvent.messageText.indexOf(EVENT_STW_BOSS_TAG) != -1)
         {
            this.STWEventType_mc.gotoAndStop("STW_Boss");
            markupRemovedBossText = aEvent.messageText.replace(EVENT_STW_BOSS_TAG,"");
            this.STWEventType_mc.ENDynamicText_tf.text = markupRemovedBossText;
         }
         else if(aEvent.messageText.indexOf(EVENT_STW_COMPLETE_TAG) != -1)
         {
            this.STWEventType_mc.gotoAndStop("STW_Complete");
            markupRemovedCompleteText = aEvent.messageText.replace(EVENT_STW_COMPLETE_TAG,"");
            this.STWEventType_mc.ENDynamicText_tf.text = markupRemovedCompleteText;
         }
         else if(aEvent.messageText.indexOf(EVENT_STW_FREEBIE_TAG) != -1)
         {
            this.STWEventType_mc.gotoAndStop("STW_Freebie");
            markupRemovedFreebieText = aEvent.messageText.replace(EVENT_STW_FREEBIE_TAG,"");
            this.STWEventType_mc.ENDynamicText_tf.text = markupRemovedFreebieText;
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame39() : *
      {
         stop();
      }
      
      internal function frame70() : *
      {
         stop();
      }
   }
}

