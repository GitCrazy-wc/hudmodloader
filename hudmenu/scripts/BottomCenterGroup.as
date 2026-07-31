package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1662")]
   public class BottomCenterGroup extends MovieClip
   {
      
      public var SubtitleText_mc:Subtitles;
      
      public var EncounterHealthMeterContainer_mc:EncounterHealthMeterContainer;
      
      public var PerkVaultBoy_mc:MovieClip;
      
      public var CritMeter_mc:MovieClip;
      
      public var CompassWidget_mc:MovieClip;
      
      private const DEFAULT_SPEAKER_NAME_Y:Number = -57.75;
      
      private const DEFAULT_SUBTITLE_TEXT_Y:Number = -25.75;
      
      public function BottomCenterGroup()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.ENTER_FRAME,this.adjustSubtitlePosition);
         this.__setProp_PerkVaultBoy_mc_BottomCenterGroup_PerkVaultBoy_mc_0();
      }
      
      private function onAddedToStage(e:Event) : void
      {
         if(this.SubtitleText_mc != null && this.EncounterHealthMeterContainer_mc != null)
         {
            this.adjustSubtitlePosition();
         }
      }
      
      private function adjustSubtitlePosition(e:Event = null) : void
      {
         var yOffset:Number = NaN;
         var meterList:Array = null;
         var i:int = 0;
         if(this.SubtitleText_mc != null && this.EncounterHealthMeterContainer_mc != null)
         {
            yOffset = 0;
            meterList = [this.EncounterHealthMeterContainer_mc.EncounterHealthMeter1_mc,this.EncounterHealthMeterContainer_mc.EncounterHealthMeter2_mc,this.EncounterHealthMeterContainer_mc.EncounterHealthMeter3_mc];
            for(i = 0; i < meterList.length; i++)
            {
               if(meterList[i] != null && Boolean(meterList[i].visible))
               {
                  yOffset = 100;
                  break;
               }
            }
            this.SubtitleText_mc.SpeakerName_tf.y = this.DEFAULT_SPEAKER_NAME_Y - yOffset;
            this.SubtitleText_mc.SubtitleText_tf.y = this.DEFAULT_SUBTITLE_TEXT_Y - yOffset;
         }
      }
      
      internal function __setProp_PerkVaultBoy_mc_BottomCenterGroup_PerkVaultBoy_mc_0() : *
      {
         try
         {
            this.PerkVaultBoy_mc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.PerkVaultBoy_mc.bPlayClipOnce = true;
         this.PerkVaultBoy_mc.bracketCornerLength = 6;
         this.PerkVaultBoy_mc.bracketLineWidth = 1.5;
         this.PerkVaultBoy_mc.bracketPaddingX = 0;
         this.PerkVaultBoy_mc.bracketPaddingY = 0;
         this.PerkVaultBoy_mc.BracketStyle = "horizontal";
         this.PerkVaultBoy_mc.bShowBrackets = false;
         this.PerkVaultBoy_mc.bUseFixedQuestStageSize = false;
         this.PerkVaultBoy_mc.bUseShadedBackground = false;
         this.PerkVaultBoy_mc.ClipAlignment = "Center";
         this.PerkVaultBoy_mc.DefaultBoySwfName = "Components/Quest Vault Boys/Miscellaneous Quests/DefaultBoy.swf";
         this.PerkVaultBoy_mc.maxClipHeight = 128;
         this.PerkVaultBoy_mc.questAnimStageHeight = 400;
         this.PerkVaultBoy_mc.questAnimStageWidth = 550;
         this.PerkVaultBoy_mc.ShadedBackgroundMethod = "Shader";
         this.PerkVaultBoy_mc.ShadedBackgroundType = "normal";
         try
         {
            this.PerkVaultBoy_mc["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

