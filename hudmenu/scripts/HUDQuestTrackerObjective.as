package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import fl.transitions.Tween;
   import fl.transitions.easing.*;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol699")]
   public class HUDQuestTrackerObjective extends BSDisplayObject
   {
      
      public static const ALERT_STATE_NONE:uint = 0;
      
      public static const METER_TYPE_DEFAULT:uint = 0;
      
      public static const METER_TYPE_TWO_WAY:uint = 1;
      
      public static var OPTIONAL_LABEL:String = "";
      
      public static var COMPLETED_LABEL:String = "";
      
      public static var FAILED_LABEL:String = "";
      
      public var Icon_mc:MovieClip;
      
      public var CompletedIcon_mc:MovieClip;
      
      public var Sizer_mc:MovieClip;
      
      public var Title_mc:HUDQuestTrackerObjectiveTitle;
      
      public var TitleCompleted_mc:HUDQuestTrackerObjectiveTitle;
      
      public var Count_mc:MovieClip;
      
      public var Meter_mc:MovieClip;
      
      public var Alert_mc:MovieClip;
      
      public var MergedLeaderIcon_mc:MovieClip;
      
      public var VertiibirdIcon_mc:MovieClip;
      
      private var m_State:Number;
      
      private var m_IsOptional:Boolean;
      
      private var m_Title:String;
      
      private var m_Count:Number = 0;
      
      private var m_CountMax:Number = 0;
      
      private var m_ObjectiveID:uint;
      
      private var m_IsOrObjective:Boolean;
      
      private var m_IsOffMap:Boolean;
      
      private var m_TitleBaseX:Number = 0;
      
      private var m_QuestID:uint;
      
      private var m_ToRemove:Boolean = false;
      
      private var m_Timer:Number = -1;
      
      private var m_UseCountdownTimer:Boolean = true;
      
      private var m_IsTimerPaused:Boolean = false;
      
      private var m_Progress:Number = -1;
      
      private var m_MeterFrames:int = 100;
      
      private var m_AlertState:int = 0;
      
      private var m_AlertMessage:String = "";
      
      private var m_AlertSizeBuffer:Number = 0;
      
      private var m_IsMergedLeaderObjective:Boolean = false;
      
      private var m_UseProvider:Boolean = false;
      
      private var m_ProviderCallback:Function;
      
      private var m_ContextQuestID:uint;
      
      private var m_MeterType:uint = 0;
      
      private var m_MeterTextLeft:String = "";
      
      private var m_MeterTextRight:String = "";
      
      private var m_posTween:Tween;
      
      private var m_DisplayIndex:int = 0;
      
      private var m_IsProximityTracker:Boolean = false;
      
      private var m_IsPrefixSuffixDirty:Boolean = false;
      
      private var m_IsTitleDirty:Boolean = false;
      
      public var m_TimestampLow:uint = 4294967295;
      
      public var m_TimestampHigh:uint = 4294967295;
      
      public function HUDQuestTrackerObjective()
      {
         addFrameScript(0,this.frame1,15,this.frame16,38,this.frame39,43,this.frame44,115,this.frame116,167,this.frame168,171,this.frame172,204,this.frame205,238,this.frame239,253,this.frame254,268,this.frame269);
         super();
         this.m_TitleBaseX = this.Title_mc.Sizer_mc.x;
         this.m_MeterFrames = this.Meter_mc.Internal_mc.totalFrames;
         this.Meter_mc.visible = false;
         Extensions.enabled = true;
         if(OPTIONAL_LABEL.length == 0)
         {
            OPTIONAL_LABEL = GlobalFunc.LocalizeFormattedString("$QuestTrackerState_Optional");
         }
         if(COMPLETED_LABEL.length == 0)
         {
            COMPLETED_LABEL = GlobalFunc.LocalizeFormattedString("$QuestTrackerState_Completed");
         }
         if(FAILED_LABEL.length == 0)
         {
            FAILED_LABEL = GlobalFunc.LocalizeFormattedString("$QuestTrackerState_Failed");
         }
      }
      
      public function onQuestDataChange(aQuests:Array) : void
      {
         var objectiveData:Object = null;
         var obIndex:uint = 0;
         for(var quIndex:uint = 0; quIndex < aQuests.length; quIndex++)
         {
            if(aQuests[quIndex].questID == this.m_QuestID)
            {
               obIndex = 0;
               while(aQuests[quIndex].objectives.length)
               {
                  objectiveData = aQuests[quIndex].objectives[obIndex];
                  if(objectiveData.contextQuestID == this.m_ContextQuestID && objectiveData.objectiveID == this.m_ObjectiveID)
                  {
                     this.meterType = objectiveData.isTwoWayProgressMeter ? METER_TYPE_TWO_WAY : METER_TYPE_DEFAULT;
                     this.meterTextLeft = objectiveData.twoWayProgressMeterTextLeft;
                     this.meterTextRight = objectiveData.twoWayProgressMeterTextRight;
                     this.progress = objectiveData.progressMeter;
                     this.timer = objectiveData.timer;
                     this.alertState = objectiveData.announceState;
                     this.alertMessage = objectiveData.announce;
                     this.isMergedLeaderObjective = objectiveData.isMergedLeaderObj;
                     return;
                  }
                  obIndex++;
               }
            }
         }
      }
      
      private function onProviderUpdate(arEvent:FromClientDataEvent) : *
      {
         var quests:Array = arEvent.data.quests;
         this.onQuestDataChange(quests);
      }
      
      override public function onRemovedFromStage() : void
      {
         if(this.isProximityTracker)
         {
            BSUIDataManager.Unsubscribe("ProximityTrackersProvider",this.onProximityTrackersData);
         }
      }
      
      private function onProximityTrackersData(aEvent:FromClientDataEvent) : *
      {
         var i:uint = 0;
         if(this.isProximityTracker && aEvent && aEvent.data && Boolean(aEvent.data.proximityTrackers))
         {
            for(i = 0; i < aEvent.data.proximityTrackers.length; i++)
            {
               if(aEvent.data.proximityTrackers[i].questId == this.questID && aEvent.data.proximityTrackers[i].objectiveId == this.objectiveID)
               {
                  this.progress = Math.max(aEvent.data.proximityTrackers[i].progress,0);
                  break;
               }
            }
         }
      }
      
      public function set useProvider(aUse:Boolean) : void
      {
         if(aUse != this.m_UseProvider)
         {
            this.m_UseProvider = aUse;
            if(this.m_ProviderCallback != null)
            {
               BSUIDataManager.Unsubscribe("QuestTrackerData",this.m_ProviderCallback);
            }
            if(this.m_UseProvider)
            {
               this.m_ProviderCallback = BSUIDataManager.Subscribe("QuestTrackerData",this.onProviderUpdate);
            }
         }
      }
      
      public function set alertState(aState:int) : void
      {
         var alertLabels:Array = null;
         var alertUseLabel:String = null;
         var i:* = undefined;
         if(aState != this.m_AlertState)
         {
            this.m_AlertState = aState;
            if(this.m_AlertState > ALERT_STATE_NONE)
            {
               this.Alert_mc.Internal_mc.visible = true;
               alertLabels = this.Alert_mc.Internal_mc.currentLabels;
               alertUseLabel = "AlertState1";
               for(i = 0; i < alertLabels.length; i++)
               {
                  if(alertLabels[i].name == "AlertState" + this.m_AlertState)
                  {
                     alertUseLabel = alertLabels[i].name;
                     break;
                  }
               }
               this.Alert_mc.Internal_mc.gotoAndPlay(alertUseLabel);
               this.updateAlertPos();
            }
            else
            {
               this.Alert_mc.Internal_mc.visible = false;
            }
         }
      }
      
      public function set alertMessage(aMessage:String) : void
      {
         var alertField:TextField = null;
         if(this.m_AlertMessage != aMessage)
         {
            this.m_AlertMessage = aMessage;
            alertField = this.Alert_mc.Internal_mc.AlertText_mc.AlertText_tf;
            alertField.text = this.m_AlertMessage;
         }
      }
      
      public function set isMergedLeaderObjective(aFlag:Boolean) : void
      {
         if(this.m_IsMergedLeaderObjective != aFlag)
         {
            this.m_IsMergedLeaderObjective = aFlag;
            this.handleIconVisibility();
         }
      }
      
      public function get timer() : Number
      {
         return this.m_Timer;
      }
      
      public function set timer(aTimer:Number) : void
      {
         if(this.m_Timer != aTimer)
         {
            this.m_Timer = aTimer;
            this.m_IsPrefixSuffixDirty = true;
         }
      }
      
      public function get useCountdownTimer() : Boolean
      {
         return this.m_UseCountdownTimer;
      }
      
      public function set useCountdownTimer(aBool:Boolean) : void
      {
         this.m_UseCountdownTimer = aBool;
      }
      
      public function get isTimerPaused() : Boolean
      {
         return this.m_IsTimerPaused;
      }
      
      public function set isTimerPaused(aBool:Boolean) : void
      {
         this.m_IsTimerPaused = aBool;
      }
      
      public function set meterType(aType:uint) : void
      {
         if(aType != this.m_MeterType)
         {
            this.m_MeterType = aType;
            switch(this.m_MeterType)
            {
               case METER_TYPE_TWO_WAY:
                  this.Meter_mc.gotoAndStop("twoWay");
                  break;
               default:
                  this.Meter_mc.gotoAndStop("plain");
            }
            this.updateProgress();
            if(aType == METER_TYPE_TWO_WAY)
            {
               this.updateMeterText();
            }
         }
      }
      
      public function set meterTextLeft(aText:String) : void
      {
         if(aText != this.m_MeterTextLeft)
         {
            this.m_MeterTextLeft = aText;
            this.updateMeterText();
         }
      }
      
      public function set meterTextRight(aText:String) : void
      {
         if(aText != this.m_MeterTextRight)
         {
            this.m_MeterTextRight = aText;
            this.updateMeterText();
         }
      }
      
      private function updateMeterText() : void
      {
         if(this.m_MeterType == METER_TYPE_TWO_WAY)
         {
            TextFieldEx.setTextAutoSize(this.Meter_mc.Internal_mc.LeftLabel_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.Meter_mc.Internal_mc.RightLabel_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            this.Meter_mc.Internal_mc.LeftLabel_tf.text = this.m_MeterTextLeft;
            this.Meter_mc.Internal_mc.RightLabel_tf.text = this.m_MeterTextRight;
         }
      }
      
      public function set progress(aProgress:Number) : void
      {
         if(this.m_Progress != aProgress)
         {
            this.m_Progress = aProgress;
            this.updateProgress();
         }
      }
      
      private function updateProgress() : void
      {
         var entry:HUDQuestTrackerEntry = null;
         if(this.m_Progress >= 0)
         {
            this.Meter_mc.visible = true;
            if(this.m_State >= HUDQuestTracker.QUEST_STATE_COMPLETE)
            {
               this.Meter_mc.Internal_mc.gotoAndStop(this.m_MeterFrames);
            }
            else
            {
               this.Meter_mc.Internal_mc.gotoAndStop(Math.floor(this.m_Progress * this.m_MeterFrames));
            }
            entry = this.parent as HUDQuestTrackerEntry;
            if(entry != null)
            {
               entry.arrangeObjectives();
            }
         }
         else
         {
            this.Meter_mc.visible = false;
         }
      }
      
      public function get isProximityTracker() : Boolean
      {
         return this.m_IsProximityTracker;
      }
      
      public function set isProximityTracker(aBool:Boolean) : void
      {
         if(this.m_IsProximityTracker != aBool)
         {
            this.m_IsProximityTracker = aBool;
            if(this.m_IsProximityTracker)
            {
               BSUIDataManager.Subscribe("ProximityTrackersProvider",this.onProximityTrackersData);
            }
            else
            {
               BSUIDataManager.Unsubscribe("ProximityTrackersProvider",this.onProximityTrackersData);
            }
         }
      }
      
      public function set toRemove(aRemove:Boolean) : *
      {
         this.m_ToRemove = aRemove;
      }
      
      public function get toRemove() : Boolean
      {
         return this.m_ToRemove;
      }
      
      public function get displayIndex() : int
      {
         return this.m_DisplayIndex;
      }
      
      public function set displayIndex(aIndex:int) : void
      {
         this.m_DisplayIndex = aIndex;
      }
      
      private function updateAlertPos() : void
      {
         var textWidth:Number = NaN;
         var useClip:MovieClip = null;
         if(this.m_AlertState > ALERT_STATE_NONE || this.m_IsMergedLeaderObjective == true)
         {
            textWidth = 0;
            if(this.m_State >= HUDQuestTracker.QUEST_STATE_COMPLETE)
            {
               useClip = this.TitleCompleted_mc;
            }
            else
            {
               useClip = this.Title_mc;
            }
            textWidth = Number(useClip.textField.getLineMetrics(0).width);
            if(this.m_AlertState > ALERT_STATE_NONE)
            {
               this.Alert_mc.Internal_mc.x = useClip.x - textWidth;
            }
         }
      }
      
      private function updateTitleText() : void
      {
         this.Title_mc.setTitleData(this.m_Title,false);
         this.TitleCompleted_mc.setTitleData(this.m_Title,false);
         this.m_IsPrefixSuffixDirty = true;
         this.m_IsTitleDirty = false;
      }
      
      private function updateTitlePrefixSuffix() : void
      {
         var countSuffix:* = "";
         var timerPrefix:* = "";
         if(this.m_Timer > 0)
         {
            timerPrefix = GlobalFunc.FormatTimeString(this.m_Timer) + " ";
         }
         if(this.m_CountMax > 0)
         {
            countSuffix = " (" + this.m_Count + "/" + this.m_CountMax + ")";
         }
         if(this.m_IsOptional)
         {
            this.Title_mc.ShowTitleText(OPTIONAL_LABEL + " " + timerPrefix,countSuffix);
         }
         else
         {
            this.Title_mc.ShowTitleText(timerPrefix,countSuffix);
         }
         if(this.m_State == HUDQuestTracker.QUEST_STATE_FAILED)
         {
            this.TitleCompleted_mc.ShowTitleText(FAILED_LABEL + " " + timerPrefix,countSuffix);
         }
         else
         {
            this.TitleCompleted_mc.ShowTitleText(COMPLETED_LABEL + " " + timerPrefix,countSuffix);
         }
         this.updateAlertPos();
         this.m_IsPrefixSuffixDirty = false;
      }
      
      public function set questID(aQuestID:uint) : void
      {
         this.m_QuestID = aQuestID;
      }
      
      public function get questID() : uint
      {
         return this.m_QuestID;
      }
      
      public function set objectiveID(aObjectiveID:uint) : void
      {
         this.m_ObjectiveID = aObjectiveID;
      }
      
      public function get objectiveID() : uint
      {
         return this.m_ObjectiveID;
      }
      
      public function set isOrObjective(aIsOrObjective:Boolean) : void
      {
         this.m_IsOrObjective = aIsOrObjective;
      }
      
      public function get isOrObjective() : Boolean
      {
         return this.m_IsOrObjective;
      }
      
      public function set isOffMap(aIsOffMap:Boolean) : void
      {
         this.m_IsOffMap = aIsOffMap;
         this.handleIconVisibility();
      }
      
      public function get isOffMap() : Boolean
      {
         return this.m_IsOffMap;
      }
      
      private function handleIconVisibility() : void
      {
         if(this.m_IsOffMap && this.m_IsMergedLeaderObjective)
         {
            this.MergedLeaderIcon_mc.Internal_mc.visible = false;
            this.VertiibirdIcon_mc.Internal_mc.visible = true;
         }
         else
         {
            this.VertiibirdIcon_mc.Internal_mc.visible = this.m_IsOffMap;
            this.MergedLeaderIcon_mc.Internal_mc.visible = this.m_IsMergedLeaderObjective;
         }
      }
      
      public function set contextQuestID(aContextQuestID:uint) : void
      {
         this.m_ContextQuestID = aContextQuestID;
      }
      
      public function get contextQuestID() : uint
      {
         return this.m_ContextQuestID;
      }
      
      public function get count() : Number
      {
         return this.m_Count;
      }
      
      public function set count(aCount:Number) : void
      {
         if(this.m_Count != aCount)
         {
            this.m_Count = aCount;
            this.m_IsPrefixSuffixDirty = true;
         }
      }
      
      public function set countMax(aCount:Number) : void
      {
         if(this.m_CountMax != aCount)
         {
            this.m_CountMax = aCount;
            this.m_IsPrefixSuffixDirty = true;
         }
      }
      
      public function set state(aState:Number) : *
      {
         if(this.m_State != aState)
         {
            this.m_State = aState;
            this.m_IsPrefixSuffixDirty = true;
         }
      }
      
      public function get state() : Number
      {
         return this.m_State;
      }
      
      public function fadeIn() : void
      {
         var Offset:Number = Math.floor(Math.random() * (5 - 0 + 1)) + 0;
         gotoAndPlay(2 + Offset);
      }
      
      public function fadeOut(aFast:Boolean = false) : void
      {
         if(this.m_State >= HUDQuestTracker.QUEST_STATE_COMPLETE)
         {
            gotoAndPlay(aFast ? "FadeOutFast" : "FadeOut");
         }
         else
         {
            gotoAndPlay(aFast ? "FadeOutIncompleteFast" : "FadeOutIncomplete");
         }
      }
      
      public function ProcessTitleUpdates() : void
      {
         if(this.m_IsTitleDirty)
         {
            this.updateTitleText();
         }
         if(this.m_IsPrefixSuffixDirty)
         {
            this.updateTitlePrefixSuffix();
         }
      }
      
      public function stateUpdate(aAnimate:Boolean = false) : void
      {
         var completed:Boolean = this.m_State == HUDQuestTracker.QUEST_STATE_COMPLETE || this.m_State == HUDQuestTracker.QUEST_STATE_FAILED;
         if(completed)
         {
            if(aAnimate)
            {
               gotoAndPlay("Complete");
            }
            else
            {
               gotoAndPlay("CompleteIdle");
            }
         }
         else
         {
            gotoAndPlay("Idle");
         }
      }
      
      public function animateUpdate() : void
      {
         gotoAndPlay("Update");
      }
      
      public function mergeStateUpdate() : void
      {
         gotoAndPlay("MergeLeaderChange");
      }
      
      public function set isOptional(aIsOptional:Boolean) : *
      {
         if(this.m_IsOptional != aIsOptional)
         {
            this.m_IsOptional = aIsOptional;
            this.m_IsPrefixSuffixDirty = true;
         }
      }
      
      public function set title(aTitle:String) : *
      {
         if(this.m_Title != aTitle)
         {
            this.m_Title = aTitle;
            this.m_IsTitleDirty = true;
         }
      }
      
      public function get title() : String
      {
         return this.m_Title;
      }
      
      public function setYPos(aPos:Number, aAnimate:Boolean = false) : void
      {
         this.clearTween();
         if(aAnimate && visible)
         {
            this.m_posTween = new Tween(this,"y",Regular.easeInOut,this.y,aPos,HUDQuestTracker.EVENT_DURATION_REARRANGE / 1000,true);
         }
         else
         {
            this.y = aPos;
         }
      }
      
      private function clearTween() : void
      {
         if(this.m_posTween != null)
         {
            this.m_posTween.stop();
            this.m_posTween = null;
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame16() : *
      {
         stop();
      }
      
      internal function frame39() : *
      {
         stop();
      }
      
      internal function frame44() : *
      {
         stop();
      }
      
      internal function frame116() : *
      {
         stop();
      }
      
      internal function frame168() : *
      {
         stop();
      }
      
      internal function frame172() : *
      {
         stop();
      }
      
      internal function frame205() : *
      {
         stop();
      }
      
      internal function frame239() : *
      {
         stop();
      }
      
      internal function frame254() : *
      {
         stop();
      }
      
      internal function frame269() : *
      {
         stop();
      }
   }
}

