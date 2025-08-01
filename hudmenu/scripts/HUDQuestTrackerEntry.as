package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import fl.transitions.Tween;
   import fl.transitions.easing.*;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol618")]
   public class HUDQuestTrackerEntry extends MovieClip
   {
      
      public static const TIMER_CRITICAL_THRESHOLD:Number = 60;
      
      public var Marker_mc:MovieClip;
      
      public var Icon_mc:MovieClip;
      
      public var LinkedRewardsIcon_mc:MovieClip;
      
      public var Title_mc:MovieClip;
      
      public var Sizer_mc:MovieClip;
      
      public var Timer_mc:MovieClip;
      
      public var QuestTrackerEntryTitleDummy:MovieClip;
      
      public var VertiibirdIcon_mc:MovieClip;
      
      private var m_Objectives:Vector.<HUDQuestTrackerObjective>;
      
      private var m_Title:String;
      
      private var m_QuestID:uint;
      
      private var m_State:Number;
      
      private var m_posTween:Tween;
      
      private var m_focusQuest:Boolean = false;
      
      private var m_IsEvent:Boolean = false;
      
      private var m_IsDisplayedToTeam:Boolean = false;
      
      private var m_ToRemove:Boolean = false;
      
      private var m_TempDisplay:Boolean = false;
      
      private var m_SortIndex:int = 0;
      
      private var m_NeedArrangeObjectives:Boolean = false;
      
      private var m_Timer:Number = -1;
      
      private var m_UseCountdownTimer:Boolean = true;
      
      private var m_IsTimerPaused:Boolean = false;
      
      private var m_UseProvider:Boolean = false;
      
      private var m_UseTimer:Boolean = false;
      
      private var m_ProviderCallback:Function;
      
      private var m_Displayed:Boolean = false;
      
      private var m_Tracker:HUDQuestTracker;
      
      private var m_TimerCritical:Boolean = false;
      
      private var m_IsShareable:Boolean = false;
      
      private var m_QuestDisplayType:uint = 0;
      
      private var m_IsNew:Boolean = true;
      
      public function HUDQuestTrackerEntry()
      {
         super();
         addFrameScript(0,this.frame1,15,this.frame16,16,this.frame17,20,this.frame21,25,this.frame26,30,this.frame31,56,this.frame57,71,this.frame72);
         this.Timer_mc.Text_mc.visible = false;
         this.m_Objectives = new Vector.<HUDQuestTrackerObjective>();
         Extensions.enabled = true;
         if(this.Title_mc.textField != null)
         {
            TextFieldEx.setTextAutoSize(this.Title_mc.textField,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
      }
      
      public function set timerCritical(param1:Boolean) : void
      {
         if(param1 != this.m_TimerCritical)
         {
            this.m_TimerCritical = param1;
            if(this.m_TimerCritical)
            {
               this.Timer_mc.gotoAndPlay("warning");
            }
            else
            {
               this.Timer_mc.gotoAndStop("idle");
            }
         }
      }
      
      public function set tracker(param1:HUDQuestTracker) : void
      {
         this.m_Tracker = param1;
      }
      
      public function onQuestDataChange(param1:Array) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_].questID == this.m_QuestID)
            {
               this.timer = param1[_loc2_].timer;
               return;
            }
            _loc2_++;
         }
      }
      
      private function onProviderUpdate(param1:FromClientDataEvent) : *
      {
         var _loc2_:Array = param1.data.quests;
         this.onQuestDataChange(_loc2_);
      }
      
      public function set useProvider(param1:Boolean) : void
      {
         if(param1 != this.m_UseProvider)
         {
            this.m_UseProvider = param1;
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
      
      public function set useTimer(param1:Boolean) : void
      {
         if(param1 != this.m_UseTimer)
         {
            this.m_UseTimer = param1;
            this.needArrangeObjectives = true;
            this.Timer_mc.Text_mc.visible = this.m_UseTimer;
            if(this.m_Tracker)
            {
               this.m_Tracker.requestRearrange();
            }
         }
      }
      
      public function get useTimer() : Boolean
      {
         return this.m_UseTimer;
      }
      
      public function get timer() : Number
      {
         return this.m_Timer;
      }
      
      public function set timer(param1:Number) : void
      {
         this.m_Timer = param1;
         if(this.m_Timer >= 0)
         {
            this.useTimer = true;
            this.Timer_mc.Text_mc.Text_tf.text = "TIME REMAINING - " + GlobalFunc.FormatTimeString(this.m_Timer);
            this.timerCritical = this.m_Timer < TIMER_CRITICAL_THRESHOLD;
            this.UpdateTitleText();
         }
         else
         {
            this.useTimer = false;
            this.timerCritical = false;
         }
      }
      
      public function get useCountdownTimer() : Boolean
      {
         return this.m_UseCountdownTimer;
      }
      
      public function set useCountdownTimer(param1:Boolean) : void
      {
         this.m_UseCountdownTimer = param1;
      }
      
      public function get isTimerPaused() : Boolean
      {
         return this.m_IsTimerPaused;
      }
      
      public function set isTimerPaused(param1:Boolean) : void
      {
         this.m_IsTimerPaused = param1;
      }
      
      public function get fullHeight() : Number
      {
         var _loc1_:Number = this.Sizer_mc.height;
         var _loc2_:uint = 0;
         while(_loc2_ < this.m_Objectives.length)
         {
            _loc1_ += this.m_Objectives[_loc2_].Sizer_mc.height;
            if(this.m_Objectives[_loc2_].Meter_mc.visible)
            {
               _loc1_ += this.m_Objectives[_loc2_].Meter_mc.Internal_mc.Sizer_mc.height;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function set needArrangeObjectives(param1:Boolean) : void
      {
         this.m_NeedArrangeObjectives = param1;
      }
      
      public function get needArrangeObjectives() : Boolean
      {
         return this.m_NeedArrangeObjectives;
      }
      
      public function set sortIndex(param1:int) : void
      {
         this.m_SortIndex = param1;
      }
      
      public function get sortIndex() : int
      {
         return this.m_SortIndex;
      }
      
      public function set tempDisplay(param1:Boolean) : void
      {
         this.m_TempDisplay = param1;
      }
      
      public function get tempDisplay() : Boolean
      {
         return this.m_TempDisplay;
      }
      
      public function set toRemove(param1:Boolean) : void
      {
         this.m_ToRemove = param1;
      }
      
      public function get toRemove() : Boolean
      {
         return this.m_ToRemove;
      }
      
      public function set isShareable(param1:Boolean) : void
      {
         this.m_IsShareable = param1;
      }
      
      public function get isShareable() : Boolean
      {
         return this.m_IsShareable;
      }
      
      public function set questDisplayType(param1:uint) : void
      {
         this.m_QuestDisplayType = param1;
         this.updateQuestIconState();
      }
      
      public function get questDisplayType() : uint
      {
         return this.m_QuestDisplayType;
      }
      
      public function set isDisplayedToTeam(param1:Boolean) : void
      {
         this.m_IsDisplayedToTeam = param1;
         this.updateQuestIconState();
      }
      
      public function get isDisplayedToTeam() : Boolean
      {
         return this.m_IsDisplayedToTeam;
      }
      
      public function updateQuestIconState() : void
      {
         if(this.m_IsDisplayedToTeam)
         {
            this.Icon_mc.gotoAndStop("sharedQuestTracker");
         }
         else
         {
            switch(this.m_QuestDisplayType)
            {
               case GlobalFunc.QUEST_DISPLAY_TYPE_MAIN:
                  this.Icon_mc.gotoAndStop("MainQuestTracker");
                  break;
               case GlobalFunc.QUEST_DISPLAY_TYPE_SIDE:
                  this.Icon_mc.gotoAndStop("questTracker");
                  break;
               case GlobalFunc.QUEST_DISPLAY_TYPE_MISC:
                  this.Icon_mc.gotoAndStop("questTracker");
                  break;
               case GlobalFunc.QUEST_DISPLAY_TYPE_EVENT:
                  this.Icon_mc.gotoAndStop("questTracker");
                  break;
               case GlobalFunc.QUEST_DISPLAY_TYPE_FUEL:
               case GlobalFunc.QUEST_DISPLAY_TYPE_OTHER:
                  this.Icon_mc.gotoAndStop("questTracker");
                  break;
               default:
                  this.Icon_mc.gotoAndStop("questTracker");
                  trace("Quest Tracker: Quest (" + this.m_Title + ") is not defined as Main/Side/Misc/Shared. Setting to Side/Misc by default");
            }
         }
      }
      
      public function set isEvent(param1:Boolean) : void
      {
         this.m_IsEvent = param1;
      }
      
      public function get isEvent() : Boolean
      {
         return this.m_IsEvent;
      }
      
      public function set focusQuest(param1:Boolean) : void
      {
         this.m_focusQuest = param1;
      }
      
      public function get focusQuest() : Boolean
      {
         return this.m_focusQuest;
      }
      
      public function get state() : Number
      {
         return this.m_State;
      }
      
      public function stateUpdate(param1:Boolean = false) : void
      {
         var _loc2_:Boolean = this.m_State == HUDQuestTracker.QUEST_STATE_COMPLETE || this.m_State == HUDQuestTracker.QUEST_STATE_FAILED;
         if(_loc2_)
         {
            if(param1)
            {
               gotoAndPlay("Completed");
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
         this.m_Displayed = true;
      }
      
      public function set state(param1:Number) : void
      {
         this.m_State = param1;
      }
      
      public function get objectives() : Vector.<HUDQuestTrackerObjective>
      {
         return this.m_Objectives;
      }
      
      public function set questID(param1:uint) : void
      {
         this.m_QuestID = param1;
      }
      
      public function get questID() : uint
      {
         return this.m_QuestID;
      }
      
      public function set title(param1:String) : void
      {
         this.m_Title = param1;
         this.UpdateTitleText();
      }
      
      public function UpdateTitleText() : void
      {
         if(this.useTimer)
         {
            this.Title_mc.textField.text = this.m_Title.toUpperCase() + " [" + GlobalFunc.FormatTimeString(this.m_Timer) + "]";
         }
         else
         {
            this.Title_mc.textField.text = this.m_Title.toUpperCase();
         }
      }
      
      public function get title() : String
      {
         return this.m_Title;
      }
      
      public function get isNew() : Boolean
      {
         return this.m_IsNew;
      }
      
      public function set isNew(param1:Boolean) : void
      {
         this.m_IsNew = param1;
      }
      
      private function clearTween() : void
      {
         if(this.m_posTween != null)
         {
            this.m_posTween.stop();
            this.m_posTween = null;
         }
      }
      
      public function fadeIn() : void
      {
         this.m_Displayed = true;
         gotoAndPlay("FadeIn");
      }
      
      public function fadeOut(param1:Boolean = false) : void
      {
         gotoAndPlay(param1 ? "FadeOutFast" : "FadeOut");
      }
      
      public function addObjective(param1:HUDQuestTrackerObjective) : void
      {
         addChild(param1);
         param1.questID = this.m_QuestID;
         this.m_Objectives.push(param1);
      }
      
      public function deleteObjective(param1:HUDQuestTrackerObjective) : void
      {
         this.objectives.splice(this.objectives.indexOf(param1),1);
         param1.useProvider = false;
         this.removeChild(param1);
      }
      
      public function getObjectiveIndexById(param1:uint) : uint
      {
         var _loc3_:uint = 0;
         var _loc2_:uint = uint.MAX_VALUE;
         while(_loc3_ < this.objectives.length)
         {
            if(this.objectives[_loc3_].objectiveID == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function setYPos(param1:Number, param2:Boolean = false) : void
      {
         this.clearTween();
         if(param2 && this.m_Displayed)
         {
            this.m_posTween = new Tween(this,"y",Regular.easeInOut,this.y,param1,HUDQuestTracker.EVENT_DURATION_REARRANGE / 1000,true);
         }
         else
         {
            this.y = param1;
         }
      }
      
      public function arrangeObjectives(param1:Boolean = false) : void
      {
         var aAnimate:Boolean = param1;
         this.m_Objectives.sort(function(param1:HUDQuestTrackerObjective, param2:HUDQuestTrackerObjective):*
         {
            return Number(param1.objectiveID) - Number(param2.objectiveID);
         });
         this.arrangeObjectivesNoSort(aAnimate);
      }
      
      public function newArrangeObjectives(param1:Boolean = false) : void
      {
         var aAnimate:Boolean = param1;
         this.m_Objectives.sort(function(param1:HUDQuestTrackerObjective, param2:HUDQuestTrackerObjective):*
         {
            var _loc3_:int = 0;
            if(param1.displayIndex < param2.displayIndex)
            {
               _loc3_ = -1;
            }
            else if(param2.displayIndex < param1.displayIndex)
            {
               _loc3_ = 1;
            }
            return _loc3_;
         });
         this.arrangeObjectivesNoSort(aAnimate);
      }
      
      public function arrangeObjectivesNoSort(param1:Boolean = false) : void
      {
         var _loc3_:HUDQuestTrackerObjective = null;
         var _loc2_:Number = this.Sizer_mc.height;
         var _loc4_:int = 0;
         while(_loc4_ < this.m_Objectives.length)
         {
            _loc3_ = this.m_Objectives[_loc4_];
            _loc3_.setYPos(_loc2_,param1);
            _loc2_ += _loc3_.Sizer_mc.height;
            if(_loc3_.Meter_mc.visible)
            {
               _loc2_ += _loc3_.Meter_mc.Internal_mc.Sizer_mc.height;
            }
            _loc4_++;
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
      
      internal function frame17() : *
      {
         stop();
      }
      
      internal function frame21() : *
      {
         stop();
      }
      
      internal function frame26() : *
      {
         stop();
      }
      
      internal function frame31() : *
      {
         stop();
      }
      
      internal function frame57() : *
      {
         stop();
      }
      
      internal function frame72() : *
      {
         stop();
      }
   }
}

