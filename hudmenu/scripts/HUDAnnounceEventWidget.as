package
{
   import Shared.AS3.BSButtonHintBar;
   import Shared.AS3.BSButtonHintData;
   import Shared.AS3.BSButtonHintHoldTimer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Data.UIDataFromClient;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.VaultBoyImageLoader;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import Shared.HUDModes;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol956")]
   public class HUDAnnounceEventWidget extends MovieClip
   {
      
      private static const LOC_DISCOVERED_ANIM_TIME_OFFSET:* = 2800;
      
      private static const FLA_FPS:Number = 30;
      
      private static const BONUS_REWARD_ANIM_TIME:Number = 3250;
      
      private static const HOLD_METER_TICK_AMOUNT:Number = 0.05;
      
      private static const MAX_STARS:Number = 4;
      
      public static const EVENT_CONSUME:String = "HUD::DiscardFanfare";
      
      public static const EVENT_CLEAR_COMPLETION_REWARD_FLAG:String = "HUD::ClearCompletionRewardsFlag";
      
      public static const EVENT_UPDATEMODEL:String = "HUD::UpdateInventory3DModel";
      
      public static const EVENT_PLAYITEMSOUND:String = "HUD::PlaySoundForItem";
      
      public static const EVENT_CURRENCYREWARD:String = "HUD::ShowCurrencyReward";
      
      public static const EVENT_XPREWARD:String = "HUD::ShowXPReward";
      
      public static const EVENT_LISTENFORACCEPT:String = "HUD::ListenForQuestTrack";
      
      public static const EVENT_ACCEPT:String = "HUD::AcceptFanfare";
      
      public static const EVENT_LOC_BUSY:String = "HUD::LocationBusy";
      
      public static const EVENT_SHOWDAILYOPSMODAL:String = "HUD::ShowDOModal";
      
      public static const EVENT_DO_COMPLETE:String = "HUD:DOCompleteFanfare";
      
      public static const EVENT_CLEAR_DO:String = "HUDNotificationsModel::ClearDOFanfare";
      
      public static const EVENT_BONUS_REWARDS_SHOWN:String = "HUDAnnounce::BonusRewardsComplete";
      
      public static const EVENT_TRACK_QUEST:String = "HUDNotificationsModel::TrackQuest";
      
      public static const EVENT_FADERMENU:String = "HUDNotificationsModel::FaderMenu";
      
      public static const EVENT_CLEARED:String = "HUDAnnounceEvent::Cleared";
      
      public static const EVENT_ACTIVE:String = "HUDAnnounceEvent::Active";
      
      public static const FANFARE_TYPE_QUESTCOMPLETE:uint = EnumHelper.GetEnum(0);
      
      public static const FANFARE_TYPE_QUESTFAILED:uint = EnumHelper.GetEnum();
      
      public static const FANFARE_TYPE_ITEMREWARD:uint = EnumHelper.GetEnum();
      
      public static const FANFARE_TYPE_QUESTAVAILABLE:uint = EnumHelper.GetEnum();
      
      public static const FANFARE_TYPE_QUESTACTIVE:uint = EnumHelper.GetEnum();
      
      public static const FANFARE_TYPE_FEATUREDITEM:uint = EnumHelper.GetEnum();
      
      public static const FANFARE_TYPE_LOCATIONDISCOVERED:uint = EnumHelper.GetEnum();
      
      public static const FANFARE_TYPE_MESSAGETEXT:uint = EnumHelper.GetEnum();
      
      public static const FANFARE_TYPE_QUICKPLAYANNOUNCE:uint = EnumHelper.GetEnum();
      
      public static const FANFARE_TYPE_COUNT:uint = EnumHelper.GetEnum();
      
      private static const MAX_QUEST_REWARDS:uint = 6;
      
      private static const COMPLETION_TO_REWARDS_FADE_TIME_MS:* = 1000;
      
      public var UniqueItemContainer_mc:MovieClip;
      
      public var QuestRewardContainer_mc:MovieClip;
      
      public var QuestCompleteContainer_mc:MovieClip;
      
      public var AnnounceAvailableQuest_mc:MovieClip;
      
      public var AnnounceActiveQuest_mc:MovieClip;
      
      public var AnnounceLocationDiscovered_mc:MovieClip;
      
      public var AnnounceMessage_mc:MovieClip;
      
      public var EventHUDNotification_mc:EventHUDNotification;
      
      public var MiscAvailableAnnounce_mc:MovieClip;
      
      private var m_ProcessedEventIDList:Array = new Array();
      
      private var m_IsBusy:Boolean = false;
      
      private var m_EventData:UIDataFromClient;
      
      private var m_CurEvent:Object;
      
      private var m_Active:Boolean = true;
      
      private var m_IsValidHudMode:Boolean = true;
      
      private var m_Enabled:Boolean = true;
      
      private var m_CurTimeout:int = -1;
      
      private var m_CurClip:MovieClip;
      
      private var m_ValidHudModes:Array;
      
      private var m_LastHudMode:String = "";
      
      private var m_LocationBusy:Boolean = false;
      
      private var m_LocationDiscoverAnimTime:Number = 5500;
      
      private var m_IsAnimating:Boolean = true;
      
      private var m_DOCompleteVisible:Boolean = false;
      
      private var m_DOCompleteID:uint = 0;
      
      private var m_WaitingForBonusRewards:Boolean = false;
      
      private var m_WaitingForFaderMenu:Boolean = false;
      
      private var m_AcceptButtonHint:BSButtonHintData = new BSButtonHintData("$RESET","T","PSN_Y","Xenon_Y",1,null);
      
      private var m_TrackButton:BSButtonHintData = new BSButtonHintData("$TRACK","G","_DPad_Down","_DPad_Down",1,null);
      
      private var m_ViewAndExitButtonHint:BSButtonHintData;
      
      private var m_HoldTimer:BSButtonHintHoldTimer;
      
      private var m_QuestTracked:Boolean = false;
      
      private var m_TrackButtonHidden:Boolean = false;
      
      private const TRACK_BUTTON_PADDING:Rectangle = new Rectangle(-9,-7,18,14);
      
      public var DOHUDAnnounce_mc:MovieClip;
      
      public var SuppliesUnlocked_mc:MovieClip;
      
      public var OpsComplete_mc:MovieClip;
      
      public var HUDAnnounce_mc:MovieClip;
      
      public var AnnounceTextCenter_mc:MovieClip;
      
      public var OpsTextLeft_mc:MovieClip;
      
      public var OpsTextRight_mc:MovieClip;
      
      public var SuppliesTextLeft_mc:MovieClip;
      
      public var SuppliesTextRight_mc:MovieClip;
      
      public var OpsButtonHintBar_mc:BSButtonHintBar;
      
      public var EXPHUDAnnounce_mc:MovieClip;
      
      public var EXPComplete_mc:MovieClip;
      
      public var EXPAnnounceTextCenter_mc:MovieClip;
      
      public var EXPCompleteTextCenter_mc:MovieClip;
      
      public var EXPCompleteTextCenterShadow_mc:MovieClip;
      
      public var EXPCompleteUpdateText_mc:MovieClip;
      
      public function HUDAnnounceEventWidget()
      {
         this.m_ViewAndExitButtonHint = new BSButtonHintData("$DO_VIEWEXIT","ESC","PSN_Start","Xenon_Start",1,this.onOpsViewAndExit);
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.m_LocationDiscoverAnimTime = this.AnnounceLocationDiscovered_mc.totalFrames * 1000 / stage.frameRate - LOC_DISCOVERED_ANIM_TIME_OFFSET;
         this.OpsTextLeft_mc = this.OpsComplete_mc.OpsTextLeft_mc;
         this.OpsTextRight_mc = this.OpsComplete_mc.OpsTextRight_mc;
         this.AnnounceTextCenter_mc = this.HUDAnnounce_mc.AnnounceTextCenter_mc;
         this.SuppliesTextLeft_mc = this.SuppliesUnlocked_mc.SuppliesTextLeft_mc;
         this.SuppliesTextRight_mc = this.SuppliesUnlocked_mc.SuppliesTextRight_mc;
         this.EXPAnnounceTextCenter_mc = this.EXPHUDAnnounce_mc.EXPAnnounceTextCenter_mc;
         this.EXPCompleteTextCenter_mc = this.EXPComplete_mc.EXPCompleteTextCenter_mc;
         this.EXPCompleteTextCenterShadow_mc = this.EXPComplete_mc.EXPCompleteTextCenterShadow_mc;
         this.EXPCompleteUpdateText_mc = this.EXPComplete_mc.EXPCompleteUpdateText_mc;
         TextFieldEx.setTextAutoSize(this.AnnounceLocationDiscovered_mc.Area_mc.Area_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.m_ViewAndExitButtonHint.userEventMapping = "Map";
         this.m_ViewAndExitButtonHint.ButtonVisible = false;
         this.OpsButtonHintBar_mc = this.OpsComplete_mc.OpsButtonHintBar_mc;
         this.OpsButtonHintBar_mc.useBackground = false;
         this.OpsButtonHintBar_mc.SetButtonHintData(new <BSButtonHintData>[this.m_ViewAndExitButtonHint]);
      }
      
      private function updateIsAnimating() : void
      {
         var isAnimating:Boolean = this.m_IsBusy && this.m_Active;
         if(this.m_IsAnimating != isAnimating)
         {
            this.m_IsAnimating = isAnimating;
            if(this.m_IsAnimating)
            {
               dispatchEvent(new Event(EVENT_ACTIVE,true));
            }
            else
            {
               dispatchEvent(new Event(EVENT_CLEARED,true));
            }
         }
      }
      
      public function set isBusy(aBusy:Boolean) : void
      {
         if(aBusy != this.m_IsBusy)
         {
            this.m_IsBusy = aBusy;
            this.updateIsAnimating();
         }
      }
      
      public function set active(aActive:Boolean) : void
      {
         var eventArray:Array = null;
         var eventsLen:uint = 0;
         var event:Object = null;
         var i:uint = 0;
         if(aActive != this.m_Active)
         {
            this.m_Active = aActive;
            this.updateIsAnimating();
            if(!this.m_Active)
            {
               if(this.m_CurTimeout != -1)
               {
                  clearTimeout(this.m_CurTimeout);
                  this.m_CurTimeout = -1;
               }
               this.QuestCompleteContainer_mc.gotoAndStop("off");
               this.QuestRewardContainer_mc.gotoAndStop("off");
               this.UniqueItemContainer_mc.gotoAndStop("off");
               this.AnnounceAvailableQuest_mc.gotoAndStop("off");
               this.MiscAvailableAnnounce_mc.gotoAndStop("off");
               this.AnnounceActiveQuest_mc.gotoAndStop("off");
               this.AnnounceMessage_mc.gotoAndStop("off");
               this.OpsComplete_mc.gotoAndStop("off");
               this.HUDAnnounce_mc.gotoAndStop("off");
               this.SuppliesUnlocked_mc.gotoAndStop("off");
               this.EXPHUDAnnounce_mc.gotoAndStop("off");
               this.EXPComplete_mc.gotoAndStop("off");
               this.EventHUDNotification_mc.gotoAndStop("off");
               BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_LISTENFORACCEPT,{"isPlaying":false}));
               this.onClearModel(null);
               if(this.m_CurEvent && this.m_CurEvent.markedAsDisplay && Boolean(this.m_CurEvent.isCompletionRewards) && this.m_CurEvent.fanfareEventType == FANFARE_TYPE_QUESTCOMPLETE)
               {
                  eventArray = this.m_EventData.data.fanfareEvents;
                  eventsLen = eventArray.length;
                  for(i = 0; i < eventsLen; i++)
                  {
                     event = eventArray[i];
                     if(event.questInstanceId == this.m_CurEvent.questInstanceId && event.fanfareEventType == FANFARE_TYPE_ITEMREWARD)
                     {
                        BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CLEAR_COMPLETION_REWARD_FLAG,{"fanfareEventID":event.fanfareEventID}));
                     }
                  }
               }
               if(this.ShouldClearCurEvent())
               {
                  this.m_CurEvent = null;
                  this.m_CurClip = null;
               }
               this.onAnimEnd(false);
            }
         }
      }
      
      private function updateEnabled() : void
      {
         this.active = this.m_Enabled && this.m_IsValidHudMode;
      }
      
      private function onDataUpdate(arEvent:FromClientDataEvent) : void
      {
         this.m_ProcessedEventIDList = new Array();
         this.m_Enabled = arEvent.data.isFanfareEnabled;
         this.updateEnabled();
         this.evaluateQueue();
      }
      
      private function isValidFanfareQuest(aQuestID:String) : Boolean
      {
         var curQuest:Object = null;
         var qIndex:uint = 0;
         var oIndex:uint = 0;
         var i:uint = 0;
         var questData:Object = BSUIDataManager.GetDataFromClient("QuestTrackerData").data;
         var newQuestData:Object = BSUIDataManager.GetDataFromClient("QuestTrackerProvider").data;
         if(questData.active)
         {
            qIndex = 0;
            while(questData.quests != null && qIndex < questData.quests.length)
            {
               curQuest = questData.quests[qIndex];
               if(curQuest.questBaseID == aQuestID)
               {
                  oIndex = 0;
                  while(curQuest.objectives != null && oIndex < curQuest.objectives.length)
                  {
                     if(curQuest.objectives[oIndex].isDisplayed)
                     {
                        return true;
                     }
                     oIndex++;
                  }
               }
               qIndex++;
            }
         }
         else if(newQuestData.active)
         {
            i = 0;
            while(newQuestData.quests != null && i < newQuestData.quests.length)
            {
               curQuest = newQuestData.quests[i];
               if(curQuest.questId == aQuestID)
               {
                  return true;
               }
               i++;
            }
         }
         return false;
      }
      
      private function evaluateQueue(abContinuationAnim:Boolean = false) : void
      {
         var startedNewAnimation:Boolean = false;
         var onlyShowCompletionRewards:Boolean = false;
         var fanfareEvent:Object = null;
         var isEventProcessed:Boolean = false;
         var canStartNewAnimation:Boolean = false;
         if(this.m_Active && this.m_EventData.data.fanfareEvents != null)
         {
            startedNewAnimation = false;
            onlyShowCompletionRewards = Boolean(this.m_CurEvent) && Boolean(this.m_CurEvent.isCompletionRewards) && this.m_CurEvent.fanfareEventType == FANFARE_TYPE_QUESTCOMPLETE;
            for each(fanfareEvent in this.m_EventData.data.fanfareEvents)
            {
               if(this.m_ProcessedEventIDList.indexOf(fanfareEvent.fanfareEventID) == -1)
               {
                  isEventProcessed = false;
                  canStartNewAnimation = !startedNewAnimation && (!this.m_IsBusy || abContinuationAnim);
                  if(this.m_LastHudMode == HUDModes.INSPECT_MODE)
                  {
                     if(fanfareEvent.fanfareEventType != FANFARE_TYPE_FEATUREDITEM)
                     {
                        continue;
                     }
                  }
                  canStartNewAnimation &&= !onlyShowCompletionRewards || fanfareEvent.isCompletionRewards && fanfareEvent.fanfareEventType == FANFARE_TYPE_ITEMREWARD && fanfareEvent.questInstanceId == this.m_CurEvent.questInstanceId;
                  switch(fanfareEvent.fanfareEventType)
                  {
                     case FANFARE_TYPE_LOCATIONDISCOVERED:
                        if(!this.m_LocationBusy && !this.m_WaitingForFaderMenu)
                        {
                           this.animateLocationDiscovered(fanfareEvent);
                           isEventProcessed = true;
                        }
                        break;
                     case FANFARE_TYPE_QUESTAVAILABLE:
                     case FANFARE_TYPE_QUESTACTIVE:
                        if(canStartNewAnimation && (fanfareEvent.fanfareEventType == FANFARE_TYPE_QUESTAVAILABLE || this.isValidFanfareQuest(fanfareEvent.questId)))
                        {
                           startedNewAnimation = this.animateEvent(fanfareEvent);
                           isEventProcessed = startedNewAnimation;
                        }
                        else if(Boolean(this.m_CurEvent) && this.m_CurEvent.questInstanceId == fanfareEvent.questInstanceId)
                        {
                           if(this.m_CurClip == this.AnnounceAvailableQuest_mc)
                           {
                              this.AnnounceAvailableQuest_mc.Desc_mc.Desc_tf.text = fanfareEvent.shortDescription;
                           }
                           else if(this.m_CurClip == this.AnnounceActiveQuest_mc)
                           {
                              this.AnnounceActiveQuest_mc.Desc_mc.Desc_tf.text = fanfareEvent.shortDescription;
                           }
                           isEventProcessed = true;
                        }
                        break;
                     case FANFARE_TYPE_QUICKPLAYANNOUNCE:
                     case FANFARE_TYPE_QUESTCOMPLETE:
                     case FANFARE_TYPE_QUESTFAILED:
                     case FANFARE_TYPE_ITEMREWARD:
                     case FANFARE_TYPE_FEATUREDITEM:
                     case FANFARE_TYPE_MESSAGETEXT:
                        if(canStartNewAnimation)
                        {
                           startedNewAnimation = this.animateEvent(fanfareEvent);
                           isEventProcessed = startedNewAnimation;
                        }
                  }
                  if(isEventProcessed)
                  {
                     this.m_ProcessedEventIDList.push(fanfareEvent.fanfareEventID);
                  }
               }
            }
            if(abContinuationAnim)
            {
               this.isBusy = startedNewAnimation;
            }
            else
            {
               this.isBusy = this.m_IsBusy || startedNewAnimation;
            }
         }
      }
      
      private function getEventTypeData(aType:uint) : Object
      {
         return aType < FANFARE_TYPE_COUNT ? this.m_EventData.data.fanfareTypes[aType] : null;
      }
      
      private function animateLocationDiscovered(discoverEvent:Object) : void
      {
         var titleTF:TextField;
         this.m_LocationBusy = true;
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_LOC_BUSY,{"isLocationBusy":true}));
         this.AnnounceLocationDiscovered_mc.Area_mc.Area_tf.text = discoverEvent.locationName;
         this.AnnounceLocationDiscovered_mc.gotoAndPlay("rollOn");
         if(Boolean(discoverEvent.soundName) && discoverEvent.soundName.length > 0)
         {
            GlobalFunc.PlayMenuSound(discoverEvent.soundName);
         }
         titleTF = this.AnnounceLocationDiscovered_mc.Title_mc.Title_tf;
         if(discoverEvent.isRegion)
         {
            GlobalFunc.PlayMenuSound("UIDiscoverRegion");
            titleTF.text = "$DiscoveredRegion";
         }
         else
         {
            GlobalFunc.PlayMenuSound("UIDiscoverLocation");
            titleTF.text = "$Discovered";
         }
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CONSUME,{"fanfareEventID":discoverEvent.fanfareEventID}));
         setTimeout(function():*
         {
            m_LocationBusy = false;
            BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_LOC_BUSY,{"isLocationBusy":false}));
            evaluateQueue();
         },this.m_LocationDiscoverAnimTime);
      }
      
      private function IsSimpleType(aType:String) : Boolean
      {
         return aType == "int" || aType == "uint" || aType == "Number" || aType == "String" || aType == "Boolean";
      }
      
      private function CloneKey(key:String, aClone:*, aOriginal:*) : void
      {
         var type:String = getQualifiedClassName(aOriginal[key]);
         if(type == "Object")
         {
            aClone[key] = this.CloneObjectData(aOriginal[key]);
         }
         else if(type == "Array")
         {
            aClone[key] = this.CloneArrayData(aOriginal[key]);
         }
         else
         {
            GlobalFunc.BSASSERT(this.IsSimpleType(type),"Can\'t clone non-basic types. Trying to clone a " + type);
            aClone[key] = aOriginal[key];
         }
      }
      
      private function CloneArrayData(aArray:Array) : Array
      {
         var clone:Array = new Array();
         for(var i:uint = 0; i < aArray.length; i++)
         {
            this.CloneKey(i.toString(),clone,aArray);
         }
         return clone;
      }
      
      private function CloneObjectData(aData:Object) : Object
      {
         var key:* = undefined;
         var cloneData:Object = new Object();
         for(key in aData)
         {
            this.CloneKey(key,cloneData,aData);
         }
         return cloneData;
      }
      
      private function ShouldCloneEvent(aEvent:Object) : Boolean
      {
         var shouldClone:Boolean = true;
         if(this.m_CurEvent && aEvent && this.m_CurEvent.fanfareEventID == aEvent.fanfareEventID && Boolean(this.m_CurEvent.isDLOPComplete))
         {
            shouldClone = false;
         }
         return shouldClone;
      }
      
      private function ShouldClearCurEvent() : Boolean
      {
         var shouldClear:Boolean = true;
         if(Boolean(this.m_CurEvent) && Boolean(this.m_CurEvent.isDLOPComplete))
         {
            shouldClear = false;
         }
         return shouldClear;
      }
      
      private function animateEvent(aEvent:Object) : Boolean
      {
         var eventTypeData:Object;
         var startedAnim:Boolean;
         var eventClip:MovieClip = null;
         var vaultBoyImage:VaultBoyImageLoader = null;
         var description:String = null;
         var secondaryClip:MovieClip = null;
         var fanfareTitle:String = null;
         var name:String = null;
         var editorNewlinePattern:RegExp = null;
         var parsedDesc:String = null;
         var rewardIndex:int = 0;
         var anyItemsAdded:Boolean = false;
         var tooManyRewards:Boolean = false;
         var reward:* = undefined;
         var nameText:String = null;
         var bonusRewardIndex:int = 0;
         var tooManyBonusRewards:Boolean = false;
         var bonusReward:* = undefined;
         var rewardText:String = null;
         var i:int = 0;
         var s:int = 0;
         var availableQuestHintBar:BSButtonHintBar = null;
         var dlopMarkupRemovedText:String = null;
         var xpdMarkupRemovedText:String = null;
         if(this.ShouldCloneEvent(aEvent))
         {
            this.m_CurEvent = this.CloneObjectData(aEvent);
         }
         eventTypeData = this.getEventTypeData(aEvent.fanfareEventType);
         GlobalFunc.BSASSERT(eventTypeData != null,"Event type data is null.");
         startedAnim = false;
         this.AnnounceActiveQuest_mc.EventMutationsBG_mc.gotoAndStop("off");
         this.m_TrackButton.ButtonVisible = false;
         switch(this.m_CurEvent.fanfareEventType)
         {
            case FANFARE_TYPE_QUESTCOMPLETE:
            case FANFARE_TYPE_QUESTFAILED:
               eventClip = this.QuestCompleteContainer_mc;
               fanfareTitle = this.m_CurEvent.isEvent ? "$$EVENT" : "$$QUEST";
               if(this.m_CurEvent.fanfareEventType == FANFARE_TYPE_QUESTFAILED)
               {
                  fanfareTitle += "FAILED";
                  GlobalFunc.PlayMenuSound("UIEventFail");
               }
               else
               {
                  fanfareTitle += "COMPLETED";
                  if(this.m_CurEvent.isEvent)
                  {
                     GlobalFunc.PlayMenuSound("UIEventComplete");
                  }
                  else
                  {
                     GlobalFunc.PlayMenuSound("UIQuestComplete");
                  }
               }
               description = this.m_CurEvent.shortDescription;
               if(description != null && description.length > 0)
               {
                  this.m_CurEvent.useDescAnim = true;
               }
               eventClip.FanfareType_mc.FanfareType_tf.text = this.m_CurEvent.sharedPlayerPrefix + fanfareTitle;
               eventClip.FanfareName_mc.FanfareName_tf.text = this.m_CurEvent.questTitle;
               TextFieldEx.setTextAutoSize(eventClip.FanfareName_mc.FanfareName_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
               vaultBoyImage = eventClip.FanfareQuestCompleted_mc.QuestAnimCatcher_mc.ClipContainer_mc;
               eventClip.FanfareDescription_mc.FanfareDescription_tf.text = this.m_CurEvent.useDescAnim ? description : "";
               vaultBoyImage.ClipAlignment_Inspectable = "Center";
               vaultBoyImage.SWFLoad(this.m_CurEvent.swfName);
               break;
            case FANFARE_TYPE_ITEMREWARD:
               if(this.m_CurEvent.rewardsA.length > 0)
               {
                  eventClip = this.QuestRewardContainer_mc;
                  eventClip.FanfareType_mc.FanfareType_tf.text = "$$ITEMREWARD";
                  eventClip.FanfareType_mc.FanfareType_tf.text = this.m_CurEvent.sharedPlayerPrefix + eventClip.FanfareType_mc.FanfareType_tf.text;
                  rewardIndex = 1;
                  anyItemsAdded = false;
                  tooManyRewards = this.m_CurEvent.rewardsA.length > MAX_QUEST_REWARDS;
                  for each(reward in this.m_CurEvent.rewardsA)
                  {
                     if(tooManyRewards && rewardIndex == MAX_QUEST_REWARDS)
                     {
                        nameText = "...";
                     }
                     else
                     {
                        nameText = reward.strRewardName;
                        if(reward.uRewardCount > 1)
                        {
                           nameText = "(" + reward.uRewardCount + ") " + nameText;
                        }
                     }
                     if(nameText.length > 0)
                     {
                        eventClip["FanfareName_mc" + rewardIndex].FanfareName_tf.text = nameText;
                        eventClip["FanfareName_mc" + rewardIndex].visible = true;
                        rewardIndex++;
                        anyItemsAdded = true;
                     }
                     if(rewardIndex > MAX_QUEST_REWARDS)
                     {
                        break;
                     }
                  }
                  while(rewardIndex <= MAX_QUEST_REWARDS)
                  {
                     eventClip["FanfareName_mc" + rewardIndex].visible = false;
                     rewardIndex++;
                  }
                  this.m_WaitingForBonusRewards = false;
                  if(this.m_CurEvent.mutatedRewards.length > 0)
                  {
                     eventClip.BonusFanfareType_mc.visible = true;
                     eventClip.BonusFanfareType_mc.FanfareType_tf.text = "$POTENTIALMUTATEDREWARDS";
                     bonusRewardIndex = 1;
                     tooManyBonusRewards = this.m_CurEvent.mutatedRewards.length > MAX_QUEST_REWARDS;
                     for each(bonusReward in this.m_CurEvent.mutatedRewards)
                     {
                        if(tooManyBonusRewards && bonusRewardIndex == MAX_QUEST_REWARDS)
                        {
                           rewardText = "...";
                        }
                        else
                        {
                           rewardText = bonusReward.strRewardName;
                           if(bonusReward.uRewardCount > 1)
                           {
                              rewardText = "(" + bonusReward.uRewardCount + ") " + rewardText;
                           }
                        }
                        if(rewardText.length > 0)
                        {
                           eventClip["BonusFanfareName_mc" + bonusRewardIndex].FanfareName_tf.text = rewardText;
                           eventClip["BonusFanfareName_mc" + bonusRewardIndex].visible = true;
                           bonusRewardIndex++;
                           anyItemsAdded = true;
                           this.m_WaitingForBonusRewards = true;
                        }
                        if(bonusRewardIndex > MAX_QUEST_REWARDS)
                        {
                           break;
                        }
                     }
                     while(bonusRewardIndex <= MAX_QUEST_REWARDS)
                     {
                        eventClip["BonusFanfareName_mc" + bonusRewardIndex].visible = false;
                        bonusRewardIndex++;
                     }
                  }
                  if(this.m_WaitingForBonusRewards)
                  {
                     eventTypeData.showTimer += BONUS_REWARD_ANIM_TIME;
                  }
                  else
                  {
                     eventClip.BonusFanfareType_mc.visible = false;
                     for(i = 1; i <= MAX_QUEST_REWARDS; i++)
                     {
                        eventClip["BonusFanfareName_mc" + i].visible = false;
                     }
                  }
                  if(!anyItemsAdded)
                  {
                     eventClip = null;
                  }
               }
               else if(!this.m_CurEvent.isCompletionRewards)
               {
                  this.DisplaySimpleRewards(this.m_CurEvent);
               }
               break;
            case FANFARE_TYPE_FEATUREDITEM:
               eventClip = this.UniqueItemContainer_mc;
               name = this.m_CurEvent.featuredItem;
               editorNewlinePattern = /\r\n/g;
               parsedDesc = this.m_CurEvent.shortDescription.replace(editorNewlinePattern," \n");
               eventClip.FanfareDescription_mc.FanfareDescription_tf.text = parsedDesc;
               for(s = 1; s <= MAX_STARS; s++)
               {
                  eventClip.FanfareInternal_mc["LegendaryStar0" + s + "_mc"].visible = s <= this.m_CurEvent.numLegendaryStars;
               }
               if(this.m_CurEvent.numLegendaryStars > 0)
               {
                  name = GlobalFunc.StringTrim(name.split("¬").join(""));
                  GlobalFunc.PlayMenuSound("UIFanfareLegendaryCrafted0" + this.m_CurEvent.numLegendaryStars);
               }
               eventClip.NewAnim_mc.visible = this.m_CurEvent.featuredItemShowNew;
               eventClip.FanfareInternal_mc.Name_mc.Name_tf.text = name;
               break;
            case FANFARE_TYPE_QUESTAVAILABLE:
               if(!this.m_CurEvent.isMiscQuest)
               {
                  eventClip = this.AnnounceAvailableQuest_mc;
                  description = this.m_CurEvent.shortDescription;
                  this.m_CurEvent.useDescAnim = description != null && description.length > 0;
                  eventClip.Header_mc.gotoAndPlay("default");
                  eventClip.BGBox_mc.gotoAndStop(this.m_CurEvent.useDescAnim ? "default" : "noDesc");
                  TextFieldEx.setTextAutoSize(eventClip.Title_mc.Title_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
                  TextFieldEx.setTextAutoSize(eventClip.Desc_mc.Desc_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
                  TextFieldEx.setTextAutoSize(eventClip.Header_mc.QuestAvailable_mc.QuestAvailable_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
                  TextFieldEx.setTextAutoSize(eventClip.Header_mc.TrackedText_mc.TrackedText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
                  eventClip.Title_mc.Title_tf.text = this.m_CurEvent.questTitle;
                  eventClip.Desc_mc.Desc_tf.text = description;
                  this.m_HoldTimer = null;
                  this.m_TrackButton.holdPercent = 0;
                  this.m_TrackButton.ButtonVisible = !this.m_TrackButtonHidden;
                  this.m_QuestTracked = false;
                  availableQuestHintBar = eventClip.ButtonHintBar_mc as BSButtonHintBar;
                  availableQuestHintBar.paddingRect = this.TRACK_BUTTON_PADDING;
               }
               else
               {
                  eventClip = this.MiscAvailableAnnounce_mc;
                  this.m_CurEvent.shortDescription = null;
                  this.m_CurEvent.useDescAnim = false;
               }
               GlobalFunc.PlayMenuSound("UIQuestNewPopup");
               break;
            case FANFARE_TYPE_QUESTACTIVE:
               eventClip = this.AnnounceActiveQuest_mc;
               description = this.m_CurEvent.shortDescription;
               if(description == null || description.length == 0)
               {
                  description = "INVALID DESCRIPTION";
               }
               eventClip.Title_mc.Title_tf.text = "$QUESTSTARTED";
               eventClip.Name_mc.Name_tf.text = this.m_CurEvent.questTitle;
               eventClip.MutatedName_mc.Name_tf.text = this.m_CurEvent.questTitle;
               eventClip.Desc_mc.Desc_tf.text = description;
               this.m_AcceptButtonHint.ButtonText = "$TRACK";
               this.AnnounceActiveQuest_mc.EventMutationsBG_mc.gotoAndStop("off");
               this.m_AcceptButtonHint.ButtonVisible = !this.m_CurEvent.hideOptInPrompt;
               if(this.m_CurEvent.eventMutation)
               {
                  this.AnnounceActiveQuest_mc.EventMutationsBG_mc.MutationType_mc.gotoAndStop(this.m_CurEvent.eventMutation);
                  secondaryClip = this.AnnounceActiveQuest_mc.EventMutationsBG_mc;
               }
               this.AnnounceActiveQuest_mc.MutatedName_mc.visible = this.m_CurEvent.eventMutation;
               this.AnnounceActiveQuest_mc.Name_mc.visible = !this.m_CurEvent.eventMutation;
               vaultBoyImage = eventClip.QuestVaultBoy_mc;
               vaultBoyImage.ClipAlignment_Inspectable = "Center";
               vaultBoyImage.SWFLoad(this.m_CurEvent.swfName);
               if(this.m_CurEvent.isEvent)
               {
                  GlobalFunc.PlayMenuSound("UIEventStart");
               }
               else
               {
                  GlobalFunc.PlayMenuSound("UIQuestNew");
               }
               break;
            case FANFARE_TYPE_MESSAGETEXT:
               eventClip = this.AnnounceMessage_mc;
               eventClip.Text_mc.Text_tf.text = this.m_CurEvent.messageText;
               break;
            case FANFARE_TYPE_QUICKPLAYANNOUNCE:
               if(this.m_CurEvent.messageText.indexOf("[#DLOP_ANNOUNCE]") != -1)
               {
                  dlopMarkupRemovedText = this.m_CurEvent.messageText.replace("[#DLOP_ANNOUNCE]","");
                  this.AnnounceTextCenter_mc.textField_tf.text = dlopMarkupRemovedText;
                  eventTypeData.showTimer = this.HUDAnnounce_mc.totalFrames / FLA_FPS * 1000;
                  eventClip = this.HUDAnnounce_mc;
                  GlobalFunc.PlayMenuSound("UIDailyOpsHudAnnounce");
                  BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CONSUME,{"fanfareEventID":this.m_CurEvent.fanfareEventID}));
               }
               else if(this.m_CurEvent.messageText.indexOf("[#DLOP_COMPLETE]") != -1)
               {
                  eventClip = this.OpsComplete_mc;
                  this.m_DOCompleteID = this.m_CurEvent.fanfareEventID;
                  this.m_DOCompleteVisible = true;
                  eventTypeData.showTimer = this.OpsComplete_mc.totalFrames / FLA_FPS * 1000;
                  this.m_CurEvent.useCustomAnim = true;
                  if(!this.m_CurEvent.isDLOPComplete)
                  {
                     GlobalFunc.PlayMenuSound("UIDailyOpsHudComplete");
                     this.m_CurEvent.isDLOPComplete = true;
                     eventClip.gotoAndPlay("rollOn");
                  }
                  else if(this.m_CurEvent.markedAsDisplay)
                  {
                     this.clearDOFanfareEvents();
                  }
                  else
                  {
                     eventClip.gotoAndStop(eventClip.totalFrames);
                  }
                  dispatchEvent(new Event(EVENT_CLEARED,true));
               }
               else if(this.m_CurEvent.messageText.indexOf("[#DLOP_SUPPLY]") != -1)
               {
                  this.SuppliesTextLeft_mc.textField_tf.text = "$DO_SUPPLIES";
                  this.SuppliesTextRight_mc.textField_tf.text = "$DO_UNLOCKED";
                  eventTypeData.showTimer = this.SuppliesUnlocked_mc.totalFrames / FLA_FPS * 1000;
                  eventClip = this.SuppliesUnlocked_mc;
                  BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CONSUME,{"fanfareEventID":this.m_CurEvent.fanfareEventID}));
               }
               else if(this.m_CurEvent.messageText.indexOf("[#XPD_ANNOUNCE]") != -1)
               {
                  xpdMarkupRemovedText = this.m_CurEvent.messageText.replace("[#XPD_ANNOUNCE]","").toUpperCase();
                  this.EXPAnnounceTextCenter_mc.textField_tf.text = xpdMarkupRemovedText;
                  eventTypeData.showTimer = this.EXPHUDAnnounce_mc.totalFrames / FLA_FPS * 1000;
                  eventClip = this.EXPHUDAnnounce_mc;
                  GlobalFunc.PlayMenuSound("UIXpdHudFanfareSm");
                  BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CONSUME,{"fanfareEventID":this.m_CurEvent.fanfareEventID}));
               }
               else if(this.m_CurEvent.messageText.indexOf("[#XPD_COMPLETE]") != -1)
               {
                  eventTypeData.showTimer = this.EXPComplete_mc.totalFrames / FLA_FPS * 1000;
                  eventClip = this.EXPComplete_mc;
                  GlobalFunc.PlayMenuSound("UIXpdHudFanfareLg");
                  BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CONSUME,{"fanfareEventID":this.m_CurEvent.fanfareEventID}));
               }
               else if(this.m_CurEvent.messageText.indexOf("[#XPD_POSTMATCH]") != -1)
               {
                  BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CONSUME,{"fanfareEventID":this.m_CurEvent.fanfareEventID}));
                  BSUIDataManager.dispatchEvent(new Event("Expeditions::ShowPostMatch"));
               }
               else if(this.EventHUDNotification_mc.isEventNotification(this.m_CurEvent.messageText))
               {
                  eventClip = this.EventHUDNotification_mc;
                  eventTypeData.showTimer = this.EventHUDNotification_mc.totalFrames / FLA_FPS * 1000;
                  this.EventHUDNotification_mc.setData(this.m_CurEvent);
                  GlobalFunc.PlayMenuSound("UIEventNotification");
                  BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CONSUME,{"fanfareEventID":this.m_CurEvent.fanfareEventID}));
               }
               else
               {
                  eventClip = this.AnnounceMessage_mc;
                  eventClip.Text_mc.Text_tf.text = this.m_CurEvent.messageText;
               }
               if(this.m_CurEvent.soundId != 0)
               {
                  GlobalFunc.PlayMenuSoundWithFormID(this.m_CurEvent.soundId);
               }
         }
         if(eventClip != null && eventTypeData != null)
         {
            startedAnim = true;
            if(this.m_CurEvent.fanfareEventType == FANFARE_TYPE_ITEMREWARD)
            {
               GlobalFunc.PlayMenuSound("UIQuestCompleteRewardItem");
            }
            if(this.m_CurEvent.useDescAnim)
            {
               eventClip.gotoAndPlay("rollOnDesc");
            }
            else if(!this.m_CurEvent.useCustomAnim)
            {
               eventClip.gotoAndPlay("rollOn");
            }
            if(secondaryClip)
            {
               secondaryClip.gotoAndPlay("rollOn");
            }
            this.m_CurClip = eventClip;
            if(this.m_CurEvent.fanfareEventType == FANFARE_TYPE_QUESTAVAILABLE && !this.m_CurEvent.isMiscQuest)
            {
               BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_LISTENFORACCEPT,{
                  "fanfareEventID":this.m_CurEvent.fanfareEventID,
                  "isQuestPending":true,
                  "isPlaying":true
               }));
            }
            this.m_CurTimeout = setTimeout(function():*
            {
               if((m_CurEvent.fanfareEventType == FANFARE_TYPE_QUESTACTIVE || m_CurEvent.fanfareEventType == FANFARE_TYPE_QUESTAVAILABLE) && m_AcceptButtonHint.holdPercent > 0)
               {
                  BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_ACCEPT,{"fanfareEventID":m_CurEvent.fanfareEventID}));
               }
               if(!m_DOCompleteVisible)
               {
                  endFanfare();
               }
            },eventTypeData.showTimer);
         }
         else
         {
            this.m_CurClip = null;
         }
         return startedAnim;
      }
      
      private function DisplaySimpleRewards(aEvent:Object) : void
      {
         var xpDelay:Number;
         var xpReward:Number = NaN;
         this.ShowCurrencyReward(aEvent.currencyID,aEvent.currencyRewarded);
         xpDelay = 700;
         xpReward = Number(aEvent.xpRewarded);
         setTimeout(function():*
         {
            ShowXPReward(xpReward);
         },xpDelay);
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CONSUME,{"fanfareEventID":aEvent.fanfareEventID}));
      }
      
      private function endFanfare() : void
      {
         var eventTypeData:Object = null;
         var fadeTime:Number = NaN;
         var standardRollOffAnimName:String = null;
         var itemID:* = undefined;
         var pairedRewardsFanfare:* = undefined;
         var fanfareEvent:Object = null;
         if(this.m_CurClip != null)
         {
            eventTypeData = this.getEventTypeData(this.m_CurEvent.fanfareEventType);
            GlobalFunc.BSASSERT(eventTypeData != null,"Event type data is null.");
            fadeTime = Number(eventTypeData.gapTimer);
            standardRollOffAnimName = "RollOff";
            if(this.m_CurEvent.isCompletionRewards)
            {
               if(this.m_CurEvent.fanfareEventType == FANFARE_TYPE_QUESTCOMPLETE)
               {
                  pairedRewardsFanfare = null;
                  for each(fanfareEvent in this.m_EventData.data.fanfareEvents)
                  {
                     if(fanfareEvent.isCompletionRewards && fanfareEvent.fanfareEventType == FANFARE_TYPE_ITEMREWARD && fanfareEvent.questInstanceId == this.m_CurEvent.questInstanceId)
                     {
                        pairedRewardsFanfare = fanfareEvent;
                        break;
                     }
                  }
                  if(pairedRewardsFanfare != null && pairedRewardsFanfare.rewardsA.length > 0)
                  {
                     this.m_CurClip.gotoAndPlay("rollOffForRewards");
                     fadeTime = COMPLETION_TO_REWARDS_FADE_TIME_MS;
                  }
                  else
                  {
                     this.m_CurClip.gotoAndPlay(standardRollOffAnimName);
                     this.m_CurEvent.isCompletionRewards = false;
                     this.DisplaySimpleRewards(pairedRewardsFanfare);
                  }
               }
               else if(this.m_CurEvent.fanfareEventType == FANFARE_TYPE_ITEMREWARD)
               {
                  this.m_CurClip.gotoAndPlay(standardRollOffAnimName);
                  this.QuestCompleteContainer_mc.gotoAndPlay("rollOffAfterRewards");
               }
               else
               {
                  trace("Finished showing fanfare marked as a completion reward, but it\'s niether an item reward or quest complete. Something is wrong with the data!");
                  trace(new Error().getStackTrace());
               }
            }
            else if(this.m_CurEvent.fanfareEventType == FANFARE_TYPE_QUESTAVAILABLE)
            {
               this.m_CurClip.gotoAndPlay(this.m_CurEvent.useDescAnim ? "rollOffDesc" : "rollOff");
               BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_LISTENFORACCEPT,{
                  "fanfareEventID":this.m_CurEvent.fanfareEventID,
                  "isQuestPending":true,
                  "isPlaying":false
               }));
            }
            else
            {
               this.m_CurClip.gotoAndPlay(this.m_CurEvent.useDescAnim ? "rollOffDesc" : standardRollOffAnimName);
            }
            itemID = 0;
            if(this.m_CurEvent.fanfareEventType == FANFARE_TYPE_FEATUREDITEM)
            {
               itemID = this.m_CurEvent.itemHandle;
            }
            BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CONSUME,{"fanfareEventID":this.m_CurEvent.fanfareEventID}));
            BSUIDataManager.dispatchEvent(new CustomEvent("FanfareEvent::FadeOut",{"fadedItemHandleID":itemID}));
            this.m_CurTimeout = setTimeout(this.onAnimEnd,fadeTime);
         }
         else
         {
            this.onAnimEnd();
         }
         this.m_AcceptButtonHint.holdPercent = 0;
      }
      
      public function onFarefanFullyDisplayed(e:Event) : void
      {
         this.m_CurEvent.markedAsDisplay = true;
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CONSUME,{"fanfareEventID":this.m_CurEvent.fanfareEventID}));
      }
      
      public function onShowModel(e:Event) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_UPDATEMODEL,{
            "itemHandle":this.m_CurEvent.itemHandle,
            "showingItem":true
         }));
      }
      
      public function onClearModel(e:Event) : void
      {
         if(this.m_CurEvent)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_UPDATEMODEL,{
               "itemHandle":this.m_CurEvent.itemHandle,
               "showingItem":false
            }));
         }
      }
      
      public function SetTrackingButtonVisibility(aToggled:Boolean) : *
      {
         this.m_TrackButtonHidden = !aToggled;
         this.m_TrackButton.ButtonVisible = aToggled;
      }
      
      private function GetOnPlayItemSoundFunc(aItemIndex:uint, aBonusReward:Boolean) : Function
      {
         return function():void
         {
            if(aBonusReward)
            {
               if(m_CurEvent.mutatedRewards.length > aItemIndex)
               {
                  BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_PLAYITEMSOUND,{"uItemHandle":m_CurEvent.mutatedRewards[aItemIndex].uItemHandle}));
               }
            }
            else if(m_CurEvent.rewardsA.length > aItemIndex)
            {
               BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_PLAYITEMSOUND,{"uItemHandle":m_CurEvent.rewardsA[aItemIndex].uItemHandle}));
            }
         };
      }
      
      private function onShowXPReward(e:Event) : void
      {
         if(!this.m_WaitingForBonusRewards)
         {
            this.ShowXPReward(this.m_CurEvent.xpRewarded);
         }
      }
      
      private function ShowXPReward(aXP:Number) : void
      {
         if(aXP)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_XPREWARD,{"xpRewarded":aXP}));
         }
      }
      
      private function onShowCurrencyReward(e:Event) : void
      {
         if(!this.m_WaitingForBonusRewards)
         {
            this.ShowCurrencyReward(this.m_CurEvent.currencyID,this.m_CurEvent.currencyRewarded);
         }
      }
      
      private function ShowCurrencyReward(aCurrencyID:uint, aCurrencyRewarded:uint) : void
      {
         if(aCurrencyRewarded)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CURRENCYREWARD,{
               "currencyID":aCurrencyID,
               "currencyRewarded":aCurrencyRewarded
            }));
         }
      }
      
      private function onBonusRewardsShown(e:Event) : void
      {
         this.m_WaitingForBonusRewards = false;
      }
      
      public function onAnimEnd(aEvaluateQueue:Boolean = true) : void
      {
         this.m_CurTimeout = -1;
         this.m_ViewAndExitButtonHint.ButtonVisible = false;
         this.m_DOCompleteVisible = false;
         this.m_TrackButton.ButtonVisible = false;
         if(aEvaluateQueue)
         {
            this.evaluateQueue(true);
         }
         else
         {
            this.isBusy = false;
         }
      }
      
      private function onQuestAcceptUpdate(arEvent:FromClientDataEvent) : void
      {
         if(arEvent.data.totalButtonHoldTime > 0)
         {
            this.m_AcceptButtonHint.holdPercent = Math.max(0,Math.min(1,arEvent.data.timeButtonHeld / arEvent.data.totalButtonHoldTime));
         }
         if(this.m_CurEvent != null && arEvent.data.fanfareEventID == this.m_CurEvent.fanfareEventID)
         {
            this.endFanfare();
         }
      }
      
      private function onHUDModeUpdate(arEvent:FromClientDataEvent) : void
      {
         this.m_LastHudMode = arEvent.data.hudMode;
         this.m_IsValidHudMode = this.m_ValidHudModes.indexOf(this.m_LastHudMode) != -1;
         if(this.m_DOCompleteVisible)
         {
            this.m_ProcessedEventIDList.pop();
         }
         this.updateEnabled();
         this.evaluateQueue();
      }
      
      private function onFFEvent(arEvent:FromClientDataEvent) : void
      {
         if(GlobalFunc.HasFFEvent(arEvent.data,EVENT_CLEAR_DO) && this.m_EventData.data.fanfareEvents != null)
         {
            this.clearDOFanfareEvents();
         }
      }
      
      private function clearDOFanfareEvents() : void
      {
         var fanfareEvent:Object = null;
         if(Boolean(this.m_CurEvent) && (this.m_CurEvent.isDLOPComplete || this.m_CurEvent.fanfareEventID == this.m_DOCompleteID))
         {
            this.OpsComplete_mc.gotoAndStop("off");
            this.isBusy = false;
            this.m_CurEvent.markedAsDisplay = true;
            BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CONSUME,{"fanfareEventID":this.m_CurEvent.fanfareEventID}));
         }
         for each(fanfareEvent in this.m_EventData.data.fanfareEvents)
         {
            if(fanfareEvent.messageText.indexOf("[#DLOP_ANNOUNCE]") != -1 || fanfareEvent.messageText.indexOf("[#DLOP_COMPLETE]") != -1 || fanfareEvent.messageText.indexOf("[#DLOP_SUPPLY]") != -1)
            {
               BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_CONSUME,{"fanfareEventID":fanfareEvent.fanfareEventID}));
            }
         }
      }
      
      private function onQuestDataUpdate(arEvent:FromClientDataEvent) : void
      {
         if(!this.m_IsBusy)
         {
            this.evaluateQueue();
         }
      }
      
      public function onShowDOButtonHint(e:Event) : void
      {
         BSUIDataManager.dispatchEvent(new Event(EVENT_DO_COMPLETE));
         this.m_ViewAndExitButtonHint.ButtonVisible = true;
      }
      
      public function ProcessUserEvent(strEventName:String, abPressed:Boolean) : Boolean
      {
         var bhandled:Boolean = false;
         if(!bhandled)
         {
            switch(strEventName)
            {
               case "Map":
                  if(!abPressed && this.m_ViewAndExitButtonHint.ButtonVisible)
                  {
                     bhandled = true;
                     this.onOpsViewAndExit();
                  }
                  break;
               case "QuickkeyDown":
               case "Emotes":
                  if(Boolean(this.m_CurEvent) && this.m_TrackButton.ButtonVisible)
                  {
                     bhandled = true;
                     if(abPressed)
                     {
                        this.m_HoldTimer = new BSButtonHintHoldTimer(500);
                        addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
                     }
                     else
                     {
                        this.m_HoldTimer = null;
                        this.m_TrackButton.holdPercent = 0;
                        removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
                     }
                  }
            }
         }
         return bhandled;
      }
      
      private function onEnterFrame(aEvent:Event) : void
      {
         if(this.m_HoldTimer)
         {
            this.m_TrackButton.holdPercent += HOLD_METER_TICK_AMOUNT;
            if(this.m_TrackButton.holdPercent >= 1)
            {
               removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
               this.onTrackQuest();
               this.m_HoldTimer = null;
            }
         }
      }
      
      private function onTrackQuest() : void
      {
         if(Boolean(this.m_CurEvent) && !this.m_QuestTracked)
         {
            this.m_QuestTracked = true;
            this.m_TrackButton.ButtonVisible = false;
            BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_TRACK_QUEST,{"questInstanceId":this.m_CurEvent.questInstanceId}));
            this.m_CurClip.Header_mc.gotoAndPlay("Tracked");
            GlobalFunc.PlayMenuSound("UIQuestNewTrack");
         }
      }
      
      private function onOpsViewAndExit() : void
      {
         GlobalFunc.PlayMenuSound("UIMenuOK");
         this.OpsComplete_mc.gotoAndStop("off");
         BSUIDataManager.dispatchEvent(new Event(EVENT_SHOWDAILYOPSMODAL));
      }
      
      private function onMenuStackChange(arEvent:FromClientDataEvent) : void
      {
         var menuName:String = null;
         var menuStack:Array = arEvent.data.menuStackA;
         var faderMenuOpen:Boolean = false;
         for(var i:* = 0; i < menuStack.length; i++)
         {
            menuName = menuStack[i].menuName;
            if(menuName == "FaderMenu")
            {
               faderMenuOpen = true;
               break;
            }
         }
         if(faderMenuOpen != this.m_WaitingForFaderMenu)
         {
            this.m_WaitingForFaderMenu = faderMenuOpen;
            BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_FADERMENU,{"isOpen":this.m_WaitingForFaderMenu}));
         }
         this.evaluateQueue();
      }
      
      private function onAddedToStage(e:Event) : void
      {
         this.m_ValidHudModes = new Array(HUDModes.ALL,HUDModes.ACTIVATE_TYPE,HUDModes.SIT_WAIT_MODE,HUDModes.VERTIBIRD_MODE,HUDModes.POWER_ARMOR,HUDModes.IRON_SIGHTS,HUDModes.DEFAULT_SCOPE_MENU,HUDModes.INSIDE_MEMORY,HUDModes.INSPECT_MODE,HUDModes.WORKSHOP_MODE,HUDModes.WORKSHOP_NO_CROSSHAIR_MODE,HUDModes.CAMP_PLACEMENT,HUDModes.FURNITURE_ENTER_EXIT,HUDModes.FISHING_MODE);
         BSUIDataManager.Subscribe("FireForgetEvent",this.onFFEvent);
         this.m_EventData = BSUIDataManager.GetDataFromClient("FanfareData");
         BSUIDataManager.Subscribe("FanfareData",this.onDataUpdate);
         addEventListener("HUDAnnouce::MarkFanfareAsDisplayed",this.onFarefanFullyDisplayed);
         addEventListener("HUDAnnounce::ShowModel",this.onShowModel);
         addEventListener("HUDAnnounce::ClearModel",this.onClearModel);
         addEventListener("HUDAnnounce::ShowDOButtonHint",this.onShowDOButtonHint);
         for(var rewardIndex:uint = 0; rewardIndex < MAX_QUEST_REWARDS; rewardIndex++)
         {
            addEventListener("HUDAnnounce::PlayQuestRewardSound" + (rewardIndex + 1),this.GetOnPlayItemSoundFunc(rewardIndex,false));
            addEventListener("HUDAnnounce::PlayQuestBonusRewardSound" + (rewardIndex + 1),this.GetOnPlayItemSoundFunc(rewardIndex,true));
         }
         addEventListener("HUDAnnounce::ShowXPReward",this.onShowXPReward);
         addEventListener("HUDAnnounce::ShowCurrencyReward",this.onShowCurrencyReward);
         addEventListener(EVENT_BONUS_REWARDS_SHOWN,this.onBonusRewardsShown);
         BSUIDataManager.Subscribe("FanfareQuestAcceptData",this.onQuestAcceptUpdate);
         BSUIDataManager.Subscribe("HUDModeData",this.onHUDModeUpdate);
         BSUIDataManager.Subscribe("QuestEventData",this.onQuestDataUpdate);
         BSUIDataManager.Subscribe("QuestTrackerProvider",this.onQuestDataUpdate);
         BSUIDataManager.Subscribe("MenuStackData",this.onMenuStackChange);
         var buttonHintDataV:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
         buttonHintDataV.push(this.m_AcceptButtonHint);
         this.m_AcceptButtonHint.canHold = true;
         this.AnnounceActiveQuest_mc.ButtonHintBar_mc.SetButtonHintData(buttonHintDataV);
         var availableQuestButtonData:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
         availableQuestButtonData.push(this.m_TrackButton);
         this.m_TrackButton.canHold = true;
         this.m_TrackButton.ButtonVisible = !this.m_TrackButtonHidden;
         this.AnnounceAvailableQuest_mc.ButtonHintBar_mc.SetButtonHintData(availableQuestButtonData);
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.UniqueItemContainer_mc.FanfareInternal_mc.Name_mc.Name_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.AnnounceActiveQuest_mc.Name_mc.Name_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.AnnounceActiveQuest_mc.Title_mc.Title_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.AnnounceTextCenter_mc.textField_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.OpsTextLeft_mc.textField_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.OpsTextRight_mc.textField_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.EXPAnnounceTextCenter_mc.textField_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.EXPCompleteTextCenter_mc.textField_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.EXPCompleteTextCenterShadow_mc.textField_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.EXPCompleteUpdateText_mc.textField_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
   }
}

