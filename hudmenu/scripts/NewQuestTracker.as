package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import Shared.HUDModes;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class NewQuestTracker extends MovieClip
   {
      
      private static const QUEST_TRACKER_PROVIDER:String = "QuestTrackerProvider";
      
      private static const REMOVE_TIMEOUT_MS:Number = 500;
      
      public static const QUEST_STATE_INVALID:Number = 0;
      
      public static const QUEST_STATE_INPROGRESS:Number = 1;
      
      public static const QUEST_STATE_COMPLETE:Number = 2;
      
      public static const QUEST_STATE_FAILED:Number = 3;
      
      public static const QUEST_SPACING:Number = 16;
      
      public var EventQuestDivider_mc:MovieClip;
      
      private var m_DisplayedQuests:Dictionary;
      
      private var m_ValidHudModes:Array;
      
      private var m_QuestsToRemove:Vector.<HUDQuestTrackerEntry>;
      
      private var m_ObjectivesToRemove:Vector.<RemoveObjectiveData>;
      
      private var m_Initialized:Boolean = false;
      
      private var m_IsValidHudMode:Boolean = true;
      
      private var m_Displayed:Boolean = true;
      
      private var m_ShouldDisplay:Boolean = false;
      
      private var m_EventQuestDividerVisible:Boolean = false;
      
      private var m_IsActive:Boolean = true;
      
      private var m_BusyAnimating:Boolean = false;
      
      private var m_DataUpdateQueued:Boolean = false;
      
      private var m_HasTimers:Boolean = false;
      
      private var m_PreviousTime:Number;
      
      public function NewQuestTracker()
      {
         super();
         this.m_ValidHudModes = new Array(HUDModes.ALL,HUDModes.ACTIVATE_TYPE,HUDModes.SIT_WAIT_MODE,HUDModes.VERTIBIRD_MODE,HUDModes.POWER_ARMOR,HUDModes.IRON_SIGHTS,HUDModes.DEFAULT_SCOPE_MENU,HUDModes.INSIDE_MEMORY,HUDModes.CAMP_PLACEMENT,HUDModes.PIPBOY,HUDModes.TERMINAL_MODE,HUDModes.INSPECT_MODE,HUDModes.DIALOGUE_MODE,HUDModes.MESSAGE_MODE,HUDModes.FISHING_MODE);
         this.m_DisplayedQuests = new Dictionary();
         this.m_QuestsToRemove = new Vector.<HUDQuestTrackerEntry>();
         this.m_ObjectivesToRemove = new Vector.<RemoveObjectiveData>();
         BSUIDataManager.Subscribe("MenuStackData",this.onMenuStackChange);
         BSUIDataManager.Subscribe("HUDModeData",this.onHUDModeUpdate);
         BSUIDataManager.Subscribe("QuestTrackerProvider",this.onQuestTrackerData);
         this.setDisplayed(false);
      }
      
      public function get isActive() : Boolean
      {
         return this.m_IsActive;
      }
      
      public function set isActive(aBool:Boolean) : void
      {
         var questDataA:Array = null;
         if(aBool != this.m_IsActive)
         {
            this.m_IsActive = aBool;
            if(this.m_IsActive)
            {
               questDataA = BSUIDataManager.GetDataFromClient(QUEST_TRACKER_PROVIDER).data.quests;
               this.initializeQuestTracker(questDataA);
               this.setDisplayed(true);
            }
            else
            {
               this.setDisplayed(false);
            }
         }
      }
      
      public function setDisplayed(aDisplayed:Boolean) : void
      {
         this.m_ShouldDisplay = aDisplayed;
         if(this.m_IsValidHudMode && this.isActive && this.m_ShouldDisplay)
         {
            this.m_Displayed = true;
            this.visible = true;
            this.alpha = 1;
         }
         else
         {
            this.m_Displayed = false;
            this.visible = false;
         }
      }
      
      private function eventQuestDividerVisible(aVisible:Boolean) : *
      {
         if(aVisible)
         {
            if(!this.m_EventQuestDividerVisible)
            {
               this.EventQuestDivider_mc.gotoAndPlay("rollOn");
            }
         }
         else if(this.m_EventQuestDividerVisible)
         {
            this.EventQuestDivider_mc.gotoAndPlay("rollOff");
         }
         this.m_EventQuestDividerVisible = aVisible;
      }
      
      private function updateQuestTracker(aQuestDataA:Array) : void
      {
         var questId:String = null;
         var newQuestData:Object = null;
         var questEntry:HUDQuestTrackerEntry = null;
         var updatedObjectives:Dictionary = null;
         var it:uint = 0;
         var j:uint = 0;
         var foundIndex:uint = 0;
         var foundObjective:HUDQuestTrackerObjective = null;
         var newObjective:HUDQuestTrackerObjective = null;
         var objectiveToRemove:HUDQuestTrackerObjective = null;
         var questToRemove:HUDQuestTrackerEntry = null;
         var obj:HUDQuestTrackerObjective = null;
         var updatedQuests:Dictionary = new Dictionary();
         for(var i:uint = 0; i < aQuestDataA.length; i++)
         {
            newQuestData = aQuestDataA[i];
            questEntry = this.m_DisplayedQuests[newQuestData.questId];
            if(questEntry)
            {
               this.initializeQuest(newQuestData,questEntry,false);
               questEntry.stateUpdate();
               updatedObjectives = new Dictionary();
               for(it = 0; it < newQuestData.objectives.length; it++)
               {
                  foundIndex = questEntry.getObjectiveIndexById(newQuestData.objectives[it].objectiveId);
                  if(foundIndex < questEntry.objectives.length)
                  {
                     foundObjective = questEntry.objectives[foundIndex];
                     this.initializeObjective(newQuestData.objectives[it],foundObjective);
                     foundObjective.displayIndex = it;
                     updatedObjectives[foundObjective.objectiveID] = foundObjective;
                  }
                  else
                  {
                     newObjective = new HUDQuestTrackerObjective();
                     questEntry.addObjective(newObjective);
                     this.initializeObjective(newQuestData.objectives[it],newObjective);
                     newObjective.displayIndex = it;
                     newObjective.fadeIn();
                     updatedObjectives[newObjective.objectiveID] = newObjective;
                  }
               }
               for(j = 0; j < questEntry.objectives.length; j++)
               {
                  if(!updatedObjectives[questEntry.objectives[j].objectiveID])
                  {
                     objectiveToRemove = questEntry.objectives[j];
                     objectiveToRemove.fadeOut(true);
                     this.m_ObjectivesToRemove.push(new RemoveObjectiveData(objectiveToRemove,questEntry));
                  }
               }
               questEntry.newArrangeObjectives();
            }
            else
            {
               questEntry = this.addQuest(newQuestData,true);
            }
            updatedQuests[newQuestData.questId] = questEntry;
         }
         for(questId in this.m_DisplayedQuests)
         {
            if(!updatedQuests[questId])
            {
               questToRemove = this.m_DisplayedQuests[questId];
               if(questToRemove)
               {
                  questToRemove.fadeOut(true);
                  for each(obj in questToRemove.objectives)
                  {
                     obj.fadeOut(true);
                  }
                  this.m_QuestsToRemove.push(questToRemove);
               }
            }
         }
         this.arrangeQuests(true);
         if(this.m_QuestsToRemove.length > 0 || this.m_ObjectivesToRemove.length > 0)
         {
            this.m_BusyAnimating = true;
            setTimeout(this.onRemoveTimeout,REMOVE_TIMEOUT_MS);
         }
         this.m_DataUpdateQueued = false;
      }
      
      private function initializeQuestTracker(aQuestDataA:Array) : void
      {
         this.m_BusyAnimating = false;
         this.clearQuestTracker();
         this.setDisplayed(true);
         for(var i:uint = 0; i < aQuestDataA.length; i++)
         {
            this.addQuest(aQuestDataA[i]);
         }
         this.arrangeQuests();
         this.m_Initialized = true;
      }
      
      private function addQuest(aQuestData:Object, aAnimate:Boolean = false) : HUDQuestTrackerEntry
      {
         var newQuest:HUDQuestTrackerEntry = new HUDQuestTrackerEntry();
         this.initializeQuest(aQuestData,newQuest,true);
         newQuest.isNew = true;
         newQuest.stateUpdate();
         this.m_DisplayedQuests[aQuestData.questId] = newQuest;
         addChild(newQuest);
         if(aAnimate)
         {
            newQuest.fadeIn();
         }
         return newQuest;
      }
      
      private function clearQuestTracker() : void
      {
         var questId:String = null;
         for(questId in this.m_DisplayedQuests)
         {
            this.removeQuest(this.m_DisplayedQuests[questId]);
         }
      }
      
      private function removeQuest(aQuest:HUDQuestTrackerEntry) : void
      {
         if(aQuest)
         {
            removeChild(aQuest);
            delete this.m_DisplayedQuests[aQuest.questID];
         }
      }
      
      private function arrangeQuests(aAnimate:Boolean = false) : void
      {
         var questClip:HUDQuestTrackerEntry = null;
         var showDivider:Boolean = false;
         var eventSection:Boolean = false;
         var posY:Number = 0;
         var questDataA:Array = BSUIDataManager.GetDataFromClient("QuestTrackerProvider").data.quests;
         for(var i:uint = 0; i < questDataA.length; i++)
         {
            questClip = this.m_DisplayedQuests[questDataA[i].questId];
            if(questClip)
            {
               if(questClip.isEvent)
               {
                  eventSection = true;
               }
               else
               {
                  if(eventSection)
                  {
                     this.EventQuestDivider_mc.y = posY + QUEST_SPACING;
                     posY += this.EventQuestDivider_mc.Sizer_mc.height + QUEST_SPACING;
                     showDivider = true;
                  }
                  eventSection = false;
               }
               questClip.setYPos(posY,aAnimate && !questClip.isNew);
               posY = posY + questClip.fullHeight + QUEST_SPACING;
               questClip.isNew = false;
            }
         }
         this.eventQuestDividerVisible(showDivider);
      }
      
      private function addTimer(aTime:Number, aUseCountdownTimer:Boolean) : *
      {
         if(aTime > 0 && aUseCountdownTimer || !aUseCountdownTimer)
         {
            if(!this.m_HasTimers)
            {
               this.m_PreviousTime = new Date().getTime() / 1000;
               addEventListener(Event.ENTER_FRAME,this.onUpdateTimers);
               this.m_HasTimers = true;
            }
         }
      }
      
      private function initializeObjective(aObjectiveData:Object, aHUDObjective:HUDQuestTrackerObjective) : void
      {
         aHUDObjective.title = aObjectiveData.title;
         aHUDObjective.state = aObjectiveData.state;
         aHUDObjective.isOptional = aObjectiveData.isOptional;
         aHUDObjective.objectiveID = aObjectiveData.objectiveId;
         aHUDObjective.questID = aObjectiveData.questId;
         aHUDObjective.isOrObjective = aObjectiveData.isOrObjective;
         aHUDObjective.isOffMap = aObjectiveData.isOffMap;
         aHUDObjective.useProvider = false;
         aHUDObjective.useCountdownTimer = aObjectiveData.timer.count_down;
         aHUDObjective.isTimerPaused = aObjectiveData.timer.is_paused;
         aHUDObjective.progress = aObjectiveData.progress;
         aHUDObjective.alertMessage = aObjectiveData.announce;
         aHUDObjective.alertState = aObjectiveData.announceState;
         aHUDObjective.contextQuestID = aObjectiveData.contextQuestID;
         aHUDObjective.meterType = aObjectiveData.isTwoWayProgressMeter ? HUDQuestTrackerObjective.METER_TYPE_TWO_WAY : HUDQuestTrackerObjective.METER_TYPE_DEFAULT;
         aHUDObjective.isProximityTracker = aObjectiveData.isProximityTracker;
         if(!aHUDObjective.isProximityTracker)
         {
            aHUDObjective.progress = aObjectiveData.progress;
         }
         if(aHUDObjective.m_TimestampLow != aObjectiveData.timer.timestamp_low || aHUDObjective.m_TimestampHigh != aObjectiveData.timer.timestamp_high)
         {
            aHUDObjective.timer = aObjectiveData.timer.total_time;
         }
         aHUDObjective.m_TimestampLow = aObjectiveData.timer.timestamp_low;
         aHUDObjective.m_TimestampHigh = aObjectiveData.timer.timestamp_high;
         if(!aHUDObjective.isTimerPaused)
         {
            this.addTimer(aHUDObjective.timer,aHUDObjective.useCountdownTimer);
         }
         if(aHUDObjective.isOrObjective)
         {
            aHUDObjective.title = "$$QUEST_TRACKER_OBJECTIVE_OR_PREFIX " + aHUDObjective.title;
         }
         aHUDObjective.isMergedLeaderObjective = aObjectiveData.isMergedLeaderObj;
         aHUDObjective.ProcessTitleUpdates();
         aHUDObjective.stateUpdate();
      }
      
      private function initializeQuest(aQuestData:Object, aQuestEntry:HUDQuestTrackerEntry, aInitObjectives:Boolean) : void
      {
         var objectiveData:Object = null;
         var objectiveKey:* = undefined;
         var newObjective:HUDQuestTrackerObjective = null;
         aQuestEntry.title = aQuestData.title;
         aQuestEntry.questID = aQuestData.questId;
         aQuestEntry.state = aQuestData.state;
         aQuestEntry.isEvent = aQuestData.displayType == GlobalFunc.QUEST_DISPLAY_TYPE_EVENT;
         aQuestEntry.questDisplayType = aQuestData.displayType;
         aQuestEntry.isDisplayedToTeam = aQuestData.isDisplayedToTeam;
         aQuestEntry.isShareable = aQuestData.isShareable;
         aQuestEntry.useProvider = false;
         aQuestEntry.useCountdownTimer = aQuestData.startTime.count_down;
         aQuestEntry.isTimerPaused = aQuestData.startTime.is_paused;
         if(aQuestEntry.m_TimestampLow != aQuestData.startTime.timestamp_low || aQuestEntry.m_TimestampHigh != aQuestData.startTime.timestamp_high)
         {
            aQuestEntry.timer = aQuestData.startTime.total_time;
         }
         aQuestEntry.m_TimestampLow = aQuestData.startTime.timestamp_low;
         aQuestEntry.m_TimestampHigh = aQuestData.startTime.timestamp_high;
         if(!aQuestEntry.isTimerPaused)
         {
            this.addTimer(aQuestEntry.timer,aQuestEntry.useCountdownTimer);
         }
         if(aInitObjectives)
         {
            for(objectiveKey in aQuestData.objectives)
            {
               newObjective = new HUDQuestTrackerObjective();
               objectiveData = aQuestData.objectives[objectiveKey];
               aQuestEntry.addObjective(newObjective);
               this.initializeObjective(objectiveData,newObjective);
               newObjective.displayIndex = objectiveKey;
               newObjective.stateUpdate();
            }
            aQuestEntry.arrangeObjectivesNoSort();
         }
      }
      
      private function isValidHUDMode(aHUDMode:String) : Boolean
      {
         return this.m_ValidHudModes.indexOf(aHUDMode) != -1;
      }
      
      private function onHUDModeUpdate(arEvent:FromClientDataEvent) : void
      {
         this.m_IsValidHudMode = this.isValidHUDMode(arEvent.data.hudMode);
         if(arEvent.data.hudMode == HUDModes.ALL)
         {
            this.setDisplayed(true);
         }
         else
         {
            this.setDisplayed(this.m_ShouldDisplay);
         }
      }
      
      private function onMenuStackChange(arEvent:FromClientDataEvent) : void
      {
         var i:* = undefined;
         var invalidMenuFound:Boolean = false;
         if(arEvent.data.menuStackA.length > 0)
         {
            for(i = 0; i < arEvent.data.menuStackA.length; i++)
            {
               switch(arEvent.data.menuStackA[i].menuName)
               {
                  case "PerksMenu":
                  case "WorkshopMenu":
                  case "CampVendingMenu":
                  case "NPCVendingMenu":
                  case "ContainerMenu":
                  case "MapMenu":
                  case "NewPlayerLoadoutsMenu":
                     invalidMenuFound = true;
                     break;
               }
            }
            if(invalidMenuFound)
            {
               this.setDisplayed(false);
            }
            else
            {
               this.setDisplayed(true);
            }
         }
      }
      
      private function onQuestTrackerData(arEvent:FromClientDataEvent) : void
      {
         if(Boolean(arEvent) && Boolean(arEvent.data))
         {
            this.isActive = arEvent.data.active;
            if(this.isActive && Boolean(arEvent.data.quests))
            {
               if(!this.m_Initialized)
               {
                  this.initializeQuestTracker(arEvent.data.quests);
                  this.m_Initialized = true;
               }
               else if(!this.m_BusyAnimating)
               {
                  this.updateQuestTracker(arEvent.data.quests);
               }
               else
               {
                  this.m_DataUpdateQueued = true;
               }
            }
         }
      }
      
      private function onUpdateTimers(aEvent:Event) : void
      {
         var timerCount:uint = 0;
         var deltaTime:Number = NaN;
         var quest:HUDQuestTrackerEntry = null;
         var i:uint = 0;
         var newFrameTime:Number = new Date().getTime() / 1000;
         if(newFrameTime - this.m_PreviousTime >= 1)
         {
            timerCount = 0;
            deltaTime = newFrameTime - this.m_PreviousTime;
            if(this.m_HasTimers)
            {
               for each(quest in this.m_DisplayedQuests)
               {
                  if(!quest.isTimerPaused)
                  {
                     if(quest.timer > 0 && quest.useCountdownTimer)
                     {
                        timerCount++;
                        quest.timer -= deltaTime;
                     }
                     else if(!quest.useCountdownTimer)
                     {
                        timerCount++;
                        quest.timer += deltaTime;
                     }
                  }
                  for(i = 0; i < quest.objectives.length; i++)
                  {
                     if(!quest.objectives[i].isTimerPaused)
                     {
                        if(quest.objectives[i].timer > 0 && quest.objectives[i].useCountdownTimer)
                        {
                           timerCount++;
                           quest.objectives[i].timer -= deltaTime;
                           quest.objectives[i].ProcessTitleUpdates();
                        }
                        else if(!quest.objectives[i].useCountdownTimer)
                        {
                           timerCount++;
                           quest.objectives[i].timer += deltaTime;
                           quest.objectives[i].ProcessTitleUpdates();
                        }
                     }
                  }
               }
            }
            if(timerCount == 0)
            {
               removeEventListener(Event.ENTER_FRAME,this.onUpdateTimers);
               this.m_HasTimers = false;
            }
            this.m_PreviousTime = newFrameTime;
         }
      }
      
      private function onRemoveTimeout() : void
      {
         var removeData:RemoveObjectiveData = null;
         var questEntry:HUDQuestTrackerEntry = null;
         var i:uint = 0;
         while(this.m_ObjectivesToRemove.length > 0)
         {
            removeData = this.m_ObjectivesToRemove.pop();
            questEntry = removeData.owningQuest;
            if(Boolean(removeData) && Boolean(questEntry))
            {
               questEntry.deleteObjective(removeData.objectiveToRemove);
               questEntry.arrangeObjectivesNoSort(true);
            }
            for(i = 0; i < questEntry.objectives.length; i++)
            {
               questEntry.objectives[i].displayIndex = i;
            }
         }
         while(this.m_QuestsToRemove.length > 0)
         {
            this.removeQuest(this.m_QuestsToRemove.pop());
         }
         this.arrangeQuests(true);
         this.m_BusyAnimating = false;
         if(this.m_DataUpdateQueued)
         {
            this.updateQuestTracker(BSUIDataManager.GetDataFromClient(QUEST_TRACKER_PROVIDER).data.quests);
         }
      }
   }
}

