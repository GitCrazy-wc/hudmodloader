package
{
   import Shared.AS3.BSButtonHintBar;
   import Shared.AS3.BSButtonHintData;
   import Shared.AS3.BSButtonHintHoldProcessor;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Data.UIDataFromClient;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.NetworkedUIEvent;
   import Shared.AS3.Events.QuestEvent;
   import Shared.AS3.IHoldHandler;
   import Shared.AS3.IMenu;
   import Shared.GlobalFunc;
   import Shared.HUDModes;
   import fl.motion.AnimatorFactory3D;
   import fl.motion.MotionBase;
   import fl.motion.motion_internal;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.UncaughtErrorEvent;
   import flash.filters.*;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import flash.utils.setTimeout;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class HUDMenu extends IMenu implements IHoldHandler
   {
      
      public static const EVENT_LEVELUP_VISIBLE:String = "HUD::LevelUpVisible";
      
      public static const EVENT_LEVELUP_HIDDEN:String = "HUD::LevelUpHidden";
      
      public static const EVENT_LEVELUP_START:String = "HUD::LevelUpStart";
      
      public static const EVENT_QUICK_HOLD_TOGGLE:String = "HUD::QuickHoldToggle";
      
      public static const EVENT_FOCUS_LOST:String = "BSButtonHintHoldProcessor::FocusLost";
      
      public static const EVENT_SCOREBOARD_CATEGORY_CHANGE:String = "Scoreboard::StatFilterChanged";
      
      public static const CURRENCY_UPDATE_LEVELUP_OFFSETY:Number = -160;
      
      public static const CURRENCY_REPUTATION_CHANGE_OFFSETY:Number = -90;
      
      public static const WANTED_POWER_ARMOR_Y_OFFSET:Number = 175;
      
      public static const WANTED_SCOREBOARD_RANK_Y_OFFSET:Number = 6;
      
      public static const ON_STARTEDITTEXT:String = "ControlMap::StartEditText";
      
      public static const ON_ENDEDITTEXT:String = "ControlMap::EndEditText";
      
      private static const NOTIFICATION_OFFSET_Y_DIALOGUE:Number = 275;
      
      private static const NOTIFICATION_OFFSET_Y_CONTAINER:Number = 15;
      
      private static const NOTIFICATION_OFFSET_X_MAP:Number = -50;
      
      private static const NOTIFICATION_OFFSET_Y_MAP:Number = 250;
      
      private static const NOTIFICATION_OFFSET_X_MAP_MESSAGES:Number = -35;
      
      private static const NOTIFICATION_OFFSET_Y_MAP_MESSAGES:Number = 270;
      
      private static const NOTIFICATION_OFFSET_Y_MAP_SURVIVAL:Number = 225;
      
      private static const NOTIFICATION_X_WORKSHOP:Number = 1315;
      
      private static const NOTIFICATION_Y_WORKSHOP:Number = 900;
      
      private static const TUTORIAL_X_PADDING:Number = 21;
      
      private static const TUTORIAL_Y_PADDING:Number = 110;
      
      public var __SFCodeObj:Object;
      
      public var modLoader:Loader;
      
      private var errorMessage:TextField;
      
      public var __animFactory_SafeRect_mcaf1:AnimatorFactory3D;
      
      public var __animArray_SafeRect_mcaf1:Array;
      
      public var ____motion_SafeRect_mcaf1_mat3DVec__:Vector.<Number>;
      
      public var ____motion_SafeRect_mcaf1_matArray__:Array;
      
      public var __motion_SafeRect_mcaf1:MotionBase;
      
      public var FloatingQuestMarkerBase:MovieClip;
      
      public var TeammateMarkerBase:TeammateMarkersManager;
      
      public var networkIndicator_mc:MovieClip;
      
      public var HUDNotificationsGroup_mc:MovieClip;
      
      public var TopCenterGroup_mc:MovieClip;
      
      public var TopRightGroup_mc:MovieClip;
      
      public var HUDChatBase_mc:MovieClip;
      
      public var PartyResolutionContainer_mc:MovieClip;
      
      public var CenterGroup_mc:MovieClip;
      
      public var LeftMeters_mc:MovieClip;
      
      public var BottomCenterGroup_mc:BottomCenterGroup;
      
      public var RightMeters_mc:HUDRightMeters;
      
      public var SafeRect_mc:MovieClip;
      
      public var questMessagingQuest_mc:MovieClip;
      
      public var testItem_deleteME:MovieClip;
      
      public var fanfareItem_mc:MovieClip;
      
      public var uniqueItemContainer_mc:MovieClip;
      
      public var questRewardContainer_mc:MovieClip;
      
      public var dpadMapContainer:MovieClip;
      
      public var CompassWidget_mc:MovieClip;
      
      public var ScreenEdgeHitIndicator_mc:MovieClip;
      
      public var AnnounceEventWidget_mc:HUDAnnounceEventWidget;
      
      public var WorkshopMarkersBase_mc:HUDWorkshopMarkers;
      
      public var PvPScoreboard_mc:HUDPvPScoreboard;
      
      public var LevelUpAnimation_mc:MovieClip;
      
      public var YouAreWanted_mc:MovieClip;
      
      public var ScoreboardRank_mc:MovieClip;
      
      public var DamageNumbers_mc:DamageNumbers;
      
      public var ReputationUpdates_mc:HUDReputationUpdatesWidget;
      
      public var FrobberWidget_mc:HUDFrobberWidget;
      
      public var RightGroup_mc:MovieClip;
      
      public var PingMarkers_mc:MovieClip;
      
      public var LocalEmote_mc:EmoteWidget;
      
      public var FloatingTargetManager_mc:HUDFloatingTargetManager;
      
      public var AnnounceAvailableQuest_mc:MovieClip;
      
      public var QuestTracker:HUDQuestTracker;
      
      public var NewQuestTracker_mc:NewQuestTracker;
      
      public var RequestUsername:String = "";
      
      public var BGSCodeObj:Object;
      
      private var m_EntityID:uint = 0;
      
      private var DpadMap_mc:MovieClip;
      
      private var m_QuestTrackerBaseX:Number = 0;
      
      private var m_QuestTrackerBaseY:Number = 0;
      
      private var m_MessagesBaseX:Number = 0;
      
      private var m_MessagesBaseY:Number = 0;
      
      private var m_PromptMessageBaseX:Number = 0;
      
      private var m_PromptMessageBaseY:Number = 0;
      
      private var m_TutorialTextBaseX:Number = 0;
      
      private var m_TutorialTextBaseY:Number = 0;
      
      private var m_PartyListBaseX:Number = 0;
      
      private var m_PartyListBaseY:Number = 0;
      
      private var m_CompassBaseY:Number = 0;
      
      private var m_XPBarBaseY:Number = 0;
      
      private var m_CurrencyUpdateBaseY:Number = 0;
      
      private var m_ValidWantedHUDModes:Array;
      
      private var m_LastHUDMode:String = "All";
      
      private var m_IsWanted:Boolean = false;
      
      private var m_ValidWantedHUDMode:Boolean = false;
      
      private var m_LastPowerArmor:Boolean = false;
      
      private var m_WantedBaseY:Number = 0;
      
      private var m_RankBaseY:Number = 0;
      
      private var m_ScoreboardRank:Number = 0;
      
      private var m_ScoreboardValue:Number = 0;
      
      private var m_WorldType:uint = 0;
      
      private var m_LastBounty:Number = 0;
      
      private var m_ScoreboardFilterData:UIDataFromClient;
      
      private var m_ScoreboardFilterDataUpdated:Boolean = false;
      
      private var m_WorldRankFilterOverride:int = -1;
      
      private var m_LevelUpVisible:Boolean = false;
      
      private var m_RepLevelUpVisible:Boolean = false;
      
      private var m_RepChangeVisible:Boolean = false;
      
      private var m_FanfareAnimating:Boolean = false;
      
      private var m_IsFreeCamMode:Boolean = false;
      
      private var ControlMapData:Object;
      
      private var CharacterInfoData:Object;
      
      private var m_QuestAnnounceQueue:Vector.<QuestEvent>;
      
      private var m_QuestAnnounceBusy:Boolean = false;
      
      private var m_UniqueFanfareActive:Boolean = false;
      
      private var m_HoldProcessor:BSButtonHintHoldProcessor = null;
      
      public var RevivePrompt_mc:MovieClip;
      
      private var m_RevivePromptVisible:Boolean = false;
      
      private var m_PrevReviveTime:Number = -1;
      
      private var ReviveButtonCallForHelp:BSButtonHintData;
      
      private var ReviveButtonGiveUp:BSButtonHintData;
      
      public function HUDMenu()
      {
         var reviveButtonBar:BSButtonHintBar;
         var buttonHintDataV:Vector.<BSButtonHintData>;
         var RankPlayerIcon:ImageFixture;
         this.__SFCodeObj = new Object();
         this.displayFormat();
         this.ReviveButtonCallForHelp = new BSButtonHintData("$CALLFORHELP","$SPACEBAR","PSN_Y","Xenon_Y",1,null);
         this.ReviveButtonGiveUp = new BSButtonHintData("$GIVEUP","TAB","PSN_B","Xenon_B",1,null);
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3);
         this.BGSCodeObj = new Object();
         Extensions.enabled = true;
         Extensions.noInvisibleAdvance = true;
         this.m_HoldProcessor = new BSButtonHintHoldProcessor(this);
         this.resetChatMode();
         this.HUDChatBase_mc.HUDChatEntryWidget_mc.ChatEntryText_tf.addEventListener(KeyboardEvent.KEY_UP,this.chatEntryKeyUp);
         this.HUDChatBase_mc.HUDChatEntryWidget_mc.ChatEntryText_tf.addEventListener(FocusEvent.FOCUS_OUT,this.chatEntryFocusOut);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageEvent);
         this.QuestTracker = this.TopRightGroup_mc.QuestTracker;
         this.NewQuestTracker_mc = this.TopRightGroup_mc.NewQuestTracker_mc;
         BSUIDataManager.Subscribe("DeathReviveData",function(event:FromClientDataEvent):*
         {
            var wholeNumberTime:Number = NaN;
            var promptData:* = event.data;
            var showPrompt:Boolean = false;
            if(promptData.isInBleedout)
            {
               if(!promptData.bleedoutDisabled)
               {
                  if(promptData.timeTillExpire > 0)
                  {
                     showPrompt = true;
                     wholeNumberTime = Math.ceil(promptData.timeTillExpire);
                     RevivePrompt_mc.reviveTimer.reviveTime_tf.text = "[" + wholeNumberTime + "s]";
                     if(m_PrevReviveTime != wholeNumberTime)
                     {
                        GlobalFunc.PlayMenuSound("UIMenuCriticallyInjuredCounterDecrement");
                        m_PrevReviveTime = wholeNumberTime;
                     }
                  }
                  else
                  {
                     m_PrevReviveTime = -1;
                  }
               }
               else
               {
                  showPrompt = true;
                  RevivePrompt_mc.reviveTimer.reviveTime_tf.text = "";
               }
            }
            if(showPrompt != m_RevivePromptVisible)
            {
               if(showPrompt)
               {
                  RevivePrompt_mc.gotoAndPlay("rollOn");
               }
               else
               {
                  RevivePrompt_mc.gotoAndPlay("rollOff");
               }
            }
            m_RevivePromptVisible = showPrompt;
         });
         reviveButtonBar = this.RevivePrompt_mc.ButtonHintBar_mc;
         buttonHintDataV = new Vector.<BSButtonHintData>();
         buttonHintDataV.push(this.ReviveButtonCallForHelp);
         buttonHintDataV.push(this.ReviveButtonGiveUp);
         reviveButtonBar.SetButtonHintData(buttonHintDataV);
         addEventListener(QuestEvent.EVENT_AVAILABLE,this.onQuestAvailable);
         this.LocalEmote_mc.align = EmoteWidget.ALIGN_RIGHT;
         BSUIDataManager.Subscribe("PVPData",function(arEvent:FromClientDataEvent):*
         {
            var announcementData:* = arEvent.data;
            if(announcementData.announcement.length > 0)
            {
               onPVPAnnounced(announcementData);
            }
         });
         this.m_QuestAnnounceQueue = new Vector.<QuestEvent>();
         this.m_QuestTrackerBaseX = this.QuestTracker.x;
         this.m_QuestTrackerBaseY = this.QuestTracker.y;
         this.m_MessagesBaseX = this.HUDNotificationsGroup_mc.Messages_mc.x;
         this.m_MessagesBaseY = this.HUDNotificationsGroup_mc.Messages_mc.y;
         this.m_PromptMessageBaseX = this.HUDNotificationsGroup_mc.PromptMessageHolder_mc.x;
         this.m_PromptMessageBaseY = this.HUDNotificationsGroup_mc.PromptMessageHolder_mc.y;
         this.m_TutorialTextBaseX = this.HUDNotificationsGroup_mc.TutorialText_mc.x;
         this.m_TutorialTextBaseY = this.HUDNotificationsGroup_mc.TutorialText_mc.y;
         this.m_PartyListBaseX = this.HUDPartyListBase_mc.x;
         this.m_PartyListBaseY = this.HUDPartyListBase_mc.y;
         this.m_XPBarBaseY = this.HUDNotificationsGroup_mc.XPMeter_mc.y;
         this.m_CurrencyUpdateBaseY = this.HUDNotificationsGroup_mc.CurrencyUpdates_mc.y;
         this.m_WantedBaseY = this.YouAreWanted_mc.y;
         this.m_RankBaseY = this.ScoreboardRank_mc.y;
         BSUIDataManager.Subscribe("FireForgetEvent",this.onFFEvent);
         BSUIDataManager.Subscribe("HUDModeData",this.onHUDModeUpdate);
         BSUIDataManager.Subscribe("MenuStackData",this.onMenuStackDataUpdate);
         BSUIDataManager.Subscribe("WorkshopStateData",this.onWorkshopStateUpdate);
         this.DpadMap_mc = this.dpadMapContainer["DpadMap_mc"];
         this.CompassWidget_mc = this.BottomCenterGroup_mc.CompassWidget_mc;
         this.m_CompassBaseY = this.CompassWidget_mc.y;
         BSUIDataManager.Subscribe("RadialMenuStatus",this.onRadialMenuStatusUpdate);
         BSUIDataManager.Subscribe("ScreenResolutionData",this.onResolutionUpdate);
         addEventListener(HUDAnnounceEventWidget.EVENT_ACTIVE,this.onFanfareActive);
         addEventListener(HUDAnnounceEventWidget.EVENT_CLEARED,this.onFanfareCleared);
         addEventListener(EVENT_LEVELUP_VISIBLE,function(e:Event):*
         {
            levelUpVisible = true;
         });
         addEventListener(EVENT_LEVELUP_HIDDEN,function(e:Event):*
         {
            levelUpVisible = false;
         });
         addEventListener(HUDReputationUpdatesWidget.EVENT_LEVELUP_VISIBLE,function(e:Event):*
         {
            repLevelUpVisible = true;
         });
         addEventListener(HUDReputationUpdatesWidget.EVENT_CHANGE_VISIBLE,function(e:Event):*
         {
            repChangeVisible = true;
         });
         addEventListener(HUDReputationUpdatesWidget.EVENT_HIDDEN,function(e:Event):*
         {
            repLevelUpVisible = false;
            repChangeVisible = false;
         });
         addEventListener(EVENT_LEVELUP_START,function(arEvent:CustomEvent):*
         {
            LevelUpAnimation_mc.LevelUpText.textField.text = arEvent.params.displayText;
            LevelUpAnimation_mc.gotoAndPlay("On");
         });
         this.m_ValidWantedHUDModes = new Array(HUDModes.ALL,HUDModes.ACTIVATE_TYPE,HUDModes.VERTIBIRD_MODE,HUDModes.POWER_ARMOR,HUDModes.IRON_SIGHTS,HUDModes.DEFAULT_SCOPE_MENU,HUDModes.INSIDE_MEMORY);
         BSUIDataManager.Subscribe("AccountInfoData",this.onAccountInfoUpdate);
         RankPlayerIcon = this.ScoreboardRank_mc.AccountIcon_mc;
         RankPlayerIcon.clipWidth = RankPlayerIcon.width * (1 / RankPlayerIcon.scaleX);
         RankPlayerIcon.clipHeight = RankPlayerIcon.height * (1 / RankPlayerIcon.scaleY);
         BSUIDataManager.Subscribe("ScoreboardData",this.onLeaderboardDataUpdate);
         this.m_ScoreboardFilterData = BSUIDataManager.GetDataFromClient("ScoreboardFilterData");
         BSUIDataManager.Subscribe("ScoreboardFilterData",function(arEvent:FromClientDataEvent):*
         {
            if(arEvent.data.worldRankFilter.statType == GlobalFunc.STAT_TYPE_INVALID)
            {
               m_WorldRankFilterOverride = GlobalFunc.STAT_TYPE_SURVIVAL_SCORE;
            }
            else
            {
               m_WorldRankFilterOverride = -1;
            }
            if(!m_ScoreboardFilterDataUpdated)
            {
               revertScoreboardFilter();
               m_ScoreboardFilterDataUpdated = true;
            }
         });
         TextFieldEx.setTextAutoSize(this.YouAreWanted_mc.bountyAmount.bounty_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         addEventListener(Event.ADDED_TO_STAGE,this.__setPerspectiveProjection_);
         if(this.__animFactory_SafeRect_mcaf1 == null)
         {
            this.__animArray_SafeRect_mcaf1 = new Array();
            this.__motion_SafeRect_mcaf1 = new MotionBase();
            this.__motion_SafeRect_mcaf1.duration = 3;
            this.__motion_SafeRect_mcaf1.overrideTargetTransform();
            this.__motion_SafeRect_mcaf1.addPropertyArray("blendMode",["normal","normal","normal"]);
            this.__motion_SafeRect_mcaf1.addPropertyArray("cacheAsBitmap",[false,false,false]);
            this.__motion_SafeRect_mcaf1.addPropertyArray("opaqueBackground",[null,null,null]);
            this.__motion_SafeRect_mcaf1.addPropertyArray("visible",[false,false,false]);
            this.__motion_SafeRect_mcaf1.is3D = true;
            this.__motion_SafeRect_mcaf1.motion_internal::spanStart = 0;
            this.____motion_SafeRect_mcaf1_matArray__ = new Array();
            this.____motion_SafeRect_mcaf1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion_SafeRect_mcaf1_mat3DVec__[0] = 1.5;
            this.____motion_SafeRect_mcaf1_mat3DVec__[1] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[2] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[3] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[4] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[5] = 1.5;
            this.____motion_SafeRect_mcaf1_mat3DVec__[6] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[7] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[8] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[9] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[10] = 1;
            this.____motion_SafeRect_mcaf1_mat3DVec__[11] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[12] = 960;
            this.____motion_SafeRect_mcaf1_mat3DVec__[13] = 540;
            this.____motion_SafeRect_mcaf1_mat3DVec__[14] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[15] = 1;
            this.____motion_SafeRect_mcaf1_matArray__.push(new Matrix3D(this.____motion_SafeRect_mcaf1_mat3DVec__));
            this.____motion_SafeRect_mcaf1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion_SafeRect_mcaf1_mat3DVec__[0] = 1.5;
            this.____motion_SafeRect_mcaf1_mat3DVec__[1] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[2] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[3] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[4] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[5] = 1.664917;
            this.____motion_SafeRect_mcaf1_mat3DVec__[6] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[7] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[8] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[9] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[10] = 1;
            this.____motion_SafeRect_mcaf1_mat3DVec__[11] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[12] = 960;
            this.____motion_SafeRect_mcaf1_mat3DVec__[13] = 539.950012;
            this.____motion_SafeRect_mcaf1_mat3DVec__[14] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[15] = 1;
            this.____motion_SafeRect_mcaf1_matArray__.push(new Matrix3D(this.____motion_SafeRect_mcaf1_mat3DVec__));
            this.____motion_SafeRect_mcaf1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion_SafeRect_mcaf1_mat3DVec__[0] = 1.999985;
            this.____motion_SafeRect_mcaf1_mat3DVec__[1] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[2] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[3] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[4] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[5] = 1.5;
            this.____motion_SafeRect_mcaf1_mat3DVec__[6] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[7] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[8] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[9] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[10] = 1;
            this.____motion_SafeRect_mcaf1_mat3DVec__[11] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[12] = 959.950012;
            this.____motion_SafeRect_mcaf1_mat3DVec__[13] = 540;
            this.____motion_SafeRect_mcaf1_mat3DVec__[14] = 0;
            this.____motion_SafeRect_mcaf1_mat3DVec__[15] = 1;
            this.____motion_SafeRect_mcaf1_matArray__.push(new Matrix3D(this.____motion_SafeRect_mcaf1_mat3DVec__));
            this.__motion_SafeRect_mcaf1.addPropertyArray("matrix3D",this.____motion_SafeRect_mcaf1_matArray__);
            this.__animArray_SafeRect_mcaf1.push(this.__motion_SafeRect_mcaf1);
            this.__animFactory_SafeRect_mcaf1 = new AnimatorFactory3D(null,this.__animArray_SafeRect_mcaf1);
            this.__animFactory_SafeRect_mcaf1.sceneName = "Scene 1";
            this.__animFactory_SafeRect_mcaf1.addTargetInfo(this,"SafeRect_mc",0,true,0,true,null,-1);
         }
         this.modLoader = new Loader();
         addChild(this.modLoader);
         try
         {
            this.modLoader.load(new URLRequest("hudmodloader.swf"),new LoaderContext(false,ApplicationDomain.currentDomain));
            this.modLoader.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.uncaughtErrorHandler);
         }
         catch(e:Error)
         {
            this.displayError("Error loading hudmodloader: " + e.toString());
         }
      }
      
      public function uncaughtErrorHandler(param1:UncaughtErrorEvent) : *
      {
         this.displayError(param1.toString());
      }
      
      private function displayFormat() : void
      {
         this.errorMessage = new TextField();
         this.errorMessage.width = 1600;
         GlobalFunc.SetText(this.errorMessage,"",false);
         TextFieldEx.setTextAutoSize(this.errorMessage,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.errorMessage.autoSize = TextFieldAutoSize.LEFT;
         this.errorMessage.wordWrap = true;
         this.errorMessage.multiline = true;
         var font:TextFormat = new TextFormat("Arial",15,this.calcColor(255,255,255));
         this.errorMessage.defaultTextFormat = font;
         this.errorMessage.setTextFormat(font);
         this.errorMessage.visible = false;
         this.errorMessage.mouseEnabled = false;
      }
      
      private function calcColor(red:uint, green:uint, blue:uint) : uint
      {
         return red * 256 * 256 + green * 256 + blue;
      }
      
      public function displayError(param1:String) : void
      {
         GlobalFunc.SetText(this.errorMessage,this.errorMessage.text + "\n" + param1);
         this.errorMessage.visible = true;
         addChild(this.errorMessage);
      }
      
      public function __setPerspectiveProjection_(evt:Event) : void
      {
         root.transform.perspectiveProjection.fieldOfView = 1.002611;
         root.transform.perspectiveProjection.projectionCenter = new Point(960,540);
      }
      
      private function get HUDPartyListBase_mc() : HUDTeamWidget
      {
         return this.PartyResolutionContainer_mc.HUDPartyListBase_mc;
      }
      
      public function set levelUpVisible(aVisible:Boolean) : void
      {
         this.m_LevelUpVisible = aVisible;
         this.updateCurrencyUpdatesPos();
         if(aVisible)
         {
            this.HUDNotificationsGroup_mc.XPMeter_mc.gotoAndStop("levelup");
            this.HUDNotificationsGroup_mc.XPMeter_mc.NumberText.visible = false;
         }
         else
         {
            this.HUDNotificationsGroup_mc.XPMeter_mc.gotoAndStop("xp");
            this.HUDNotificationsGroup_mc.XPMeter_mc.NumberText.visible = true;
         }
      }
      
      public function set repLevelUpVisible(aVisible:Boolean) : void
      {
         this.m_RepLevelUpVisible = aVisible;
         this.updateCurrencyUpdatesPos();
      }
      
      public function set repChangeVisible(aVisible:Boolean) : void
      {
         this.m_RepChangeVisible = aVisible;
         this.updateCurrencyUpdatesPos();
      }
      
      public function onAddedToStageEvent(e:Event) : void
      {
         this.onAddedToStage();
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.CharacterInfoData = BSUIDataManager.GetDataFromClient("CharacterInfoData").data;
         this.ControlMapData = BSUIDataManager.GetDataFromClient("ControlMapData").data;
         BSUIDataManager.Subscribe("CharacterInfoData",this.onCharacterInfoUpdate);
         addEventListener(Messages.EVENT_MESSAGE_VISIBILITY_UPDATE,this.onMessageVisibilityUpdate);
      }
      
      private function onMessageVisibilityUpdate(aEvent:CustomEvent) : void
      {
         if(aEvent && aEvent.params && Boolean(aEvent.params.messageType) && aEvent.params.messageType == HUDMessageItemData.TYPE_INFESTATION)
         {
            this.AnnounceEventWidget_mc.SetTrackingButtonVisibility(!aEvent.params.fadedIn);
         }
      }
      
      private function revertScoreboardFilter() : void
      {
         if(this.m_WorldRankFilterOverride >= 0)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_SCOREBOARD_CATEGORY_CHANGE,{"statTypeFilter":this.m_WorldRankFilterOverride}));
         }
         else if(this.m_ScoreboardFilterData && this.m_ScoreboardFilterData.data && Boolean(this.m_ScoreboardFilterData.data.worldRankFilter))
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_SCOREBOARD_CATEGORY_CHANGE,{"statTypeFilter":this.m_ScoreboardFilterData.data.worldRankFilter.statType}));
         }
      }
      
      private function onHUDModeUpdate(arEvent:FromClientDataEvent) : void
      {
         var mode:String = arEvent.data.hudMode;
         var partyXOffset:Number = 0;
         var partyYOffset:Number = 0;
         var questXOffset:Number = 0;
         var questYOffset:Number = 0;
         var XPBarYOffset:Number = 0;
         this.m_LastPowerArmor = Boolean(arEvent.data.inPowerArmor) && Boolean(arEvent.data.powerArmorHUDEnabled);
         switch(mode)
         {
            case HUDModes.WORKSHOP_MODE:
            case HUDModes.WORKSHOP_NO_CROSSHAIR_MODE:
               partyXOffset = 100;
               questXOffset = -285;
               questYOffset = 80;
               break;
            case HUDModes.INSPECT_MODE:
               XPBarYOffset = 133;
         }
         if(this.m_LastPowerArmor && mode != HUDModes.PHOTO_MODE && mode != HUDModes.MAP_MENU && mode != HUDModes.DIALOGUE_MODE)
         {
            partyXOffset = 205;
            partyYOffset = -226;
         }
         this.QuestTracker.x = this.m_QuestTrackerBaseX + questXOffset;
         this.QuestTracker.y = this.m_QuestTrackerBaseY + questYOffset;
         this.NewQuestTracker_mc.x = this.m_QuestTrackerBaseX + questXOffset;
         this.NewQuestTracker_mc.y = this.m_QuestTrackerBaseY + questYOffset;
         HUDTeamWidget.inPA = this.m_LastPowerArmor;
         this.HUDPartyListBase_mc.x = this.m_PartyListBaseX + partyXOffset;
         this.HUDPartyListBase_mc.y = this.m_PartyListBaseY + partyYOffset;
         this.HUDPartyListBase_mc.PartyList.SetIsDirty();
         this.HUDNotificationsGroup_mc.XPMeter_mc.y = this.m_XPBarBaseY + XPBarYOffset;
         this.m_ValidWantedHUDMode = this.m_ValidWantedHUDModes.indexOf(mode) != -1;
         if(mode != this.m_LastHUDMode && (this.m_LastHUDMode == HUDModes.MAP_MENU || this.m_LastHUDMode == HUDModes.PAUSE))
         {
            this.revertScoreboardFilter();
         }
         this.m_LastHUDMode = mode;
         this.updateWantedVis();
         this.updateRankVis();
         this.LevelUpAnimation_mc.visible = mode != HUDModes.PERKS_MODE && mode != HUDModes.LEGENDARY_PERKS_MODE;
         this.updateHUDNotificationsOffset();
      }
      
      private function onMenuStackDataUpdate(arEvent:FromClientDataEvent) : void
      {
         var mapMenuOpen:Boolean = false;
         var i:int = 0;
         if(Boolean(arEvent.data) && Boolean(arEvent.data.menuStackA))
         {
            mapMenuOpen = false;
            if(Boolean(arEvent.data) && Boolean(arEvent.data.menuStackA))
            {
               mapMenuOpen = false;
               i = arEvent.data.menuStackA.length - 1;
               while(i > -1)
               {
                  if(arEvent.data.menuStackA[i].menuName == "MapMenu")
                  {
                     mapMenuOpen = true;
                     break;
                  }
                  i--;
               }
            }
            this.TeammateMarkerBase.hideMarkers = mapMenuOpen;
         }
      }
      
      private function onWorkshopStateUpdate(arEvent:FromClientDataEvent) : void
      {
         this.m_IsFreeCamMode = arEvent.data.freeCamMode;
         this.updateHUDNotificationsOffset();
      }
      
      private function updateHUDNotificationsOffset() : void
      {
         var notificationsXOffset:Number = 0;
         var notificationsYOffset:Number = 0;
         var tutorialXOffset:Number = 0;
         var tutorialYOffset:Number = 0;
         var bUseMapMessageOffsets:Boolean = false;
         var isWorkshopMode:* = this.m_LastHUDMode == HUDModes.WORKSHOP_MODE || this.m_LastHUDMode == HUDModes.WORKSHOP_NO_CROSSHAIR_MODE;
         HUDMessageItemBase.showBottomRight = isWorkshopMode;
         this.HUDNotificationsGroup_mc.Messages_mc.showBottomRight = isWorkshopMode;
         switch(this.m_LastHUDMode)
         {
            case HUDModes.DIALOGUE_MODE:
               notificationsYOffset = NOTIFICATION_OFFSET_Y_DIALOGUE;
               tutorialYOffset = NOTIFICATION_OFFSET_Y_DIALOGUE;
               break;
            case HUDModes.WORKSHOP_NO_CROSSHAIR_MODE:
            case HUDModes.WORKSHOP_MODE:
               notificationsXOffset = NOTIFICATION_X_WORKSHOP - this.m_MessagesBaseX;
               notificationsYOffset = NOTIFICATION_Y_WORKSHOP - this.m_MessagesBaseX;
               tutorialXOffset = NOTIFICATION_X_WORKSHOP - this.m_TutorialTextBaseX - TUTORIAL_X_PADDING;
               tutorialYOffset = NOTIFICATION_Y_WORKSHOP - this.m_TutorialTextBaseY - TUTORIAL_Y_PADDING;
               break;
            case HUDModes.CONTAINER_MODE:
               notificationsYOffset = NOTIFICATION_OFFSET_Y_CONTAINER;
               tutorialYOffset = NOTIFICATION_OFFSET_Y_CONTAINER;
               break;
            case HUDModes.MAP_MENU:
               if(this.m_WorldType == GlobalFunc.WORLD_TYPE_SURVIVAL)
               {
                  notificationsYOffset = NOTIFICATION_OFFSET_Y_MAP_SURVIVAL;
                  tutorialYOffset = NOTIFICATION_OFFSET_Y_MAP_SURVIVAL;
               }
               else if(this.m_WorldType == GlobalFunc.WORLD_TYPE_NORMAL || this.m_WorldType == GlobalFunc.WORLD_TYPE_PRIVATE)
               {
                  notificationsXOffset = NOTIFICATION_OFFSET_X_MAP;
                  notificationsYOffset = NOTIFICATION_OFFSET_Y_MAP;
                  tutorialXOffset = NOTIFICATION_OFFSET_X_MAP;
                  tutorialYOffset = NOTIFICATION_OFFSET_Y_MAP;
                  bUseMapMessageOffsets = true;
               }
         }
         this.HUDNotificationsGroup_mc.Messages_mc.x = this.m_MessagesBaseX + (bUseMapMessageOffsets ? NOTIFICATION_OFFSET_X_MAP_MESSAGES : notificationsXOffset);
         this.HUDNotificationsGroup_mc.Messages_mc.y = this.m_MessagesBaseY + (bUseMapMessageOffsets ? NOTIFICATION_OFFSET_Y_MAP_MESSAGES : notificationsYOffset);
         this.HUDNotificationsGroup_mc.PromptMessageHolder_mc.x = this.m_PromptMessageBaseX + (bUseMapMessageOffsets ? NOTIFICATION_OFFSET_X_MAP_MESSAGES : notificationsXOffset);
         this.HUDNotificationsGroup_mc.PromptMessageHolder_mc.y = this.m_PromptMessageBaseY + (bUseMapMessageOffsets ? NOTIFICATION_OFFSET_Y_MAP_MESSAGES : notificationsYOffset);
         this.HUDNotificationsGroup_mc.TutorialText_mc.x = this.m_TutorialTextBaseX + tutorialXOffset;
         this.HUDNotificationsGroup_mc.TutorialText_mc.y = this.m_TutorialTextBaseY + tutorialYOffset;
         this.TopRightGroup_mc.enabled = !bNuclearWinterMode;
         this.TopRightGroup_mc.visible = !bNuclearWinterMode;
         this.AnnounceEventWidget_mc.enabled = !bNuclearWinterMode;
         this.AnnounceEventWidget_mc.visible = !bNuclearWinterMode;
         this.AnnounceAvailableQuest_mc.enabled = !bNuclearWinterMode;
         this.AnnounceAvailableQuest_mc.visible = !bNuclearWinterMode;
         var Compass:HUDCompassWidget = this.CompassWidget_mc as HUDCompassWidget;
         Compass.bNuclearWinterMode = bNuclearWinterMode;
      }
      
      private function updateRankVis() : void
      {
         var rankVisible:Boolean = this.m_ValidWantedHUDMode && this.m_WorldType == GlobalFunc.WORLD_TYPE_SURVIVAL && (this.m_ScoreboardRank > 1 || this.m_ScoreboardValue > 0);
         if(this.ScoreboardRank_mc.visible != rankVisible)
         {
            this.ScoreboardRank_mc.visible = rankVisible;
         }
         var wantedOffset:Number = 0;
         if(this.m_IsWanted)
         {
            wantedOffset += this.YouAreWanted_mc.Sizer_mc.height + WANTED_SCOREBOARD_RANK_Y_OFFSET;
         }
         if(this.m_LastPowerArmor)
         {
            this.ScoreboardRank_mc.y = this.m_RankBaseY - WANTED_POWER_ARMOR_Y_OFFSET - wantedOffset;
         }
         else
         {
            this.ScoreboardRank_mc.y = this.m_RankBaseY - wantedOffset;
         }
      }
      
      private function updateWantedVis(aBounty:Number = 0) : void
      {
         var wantedVisible:Boolean = this.m_ValidWantedHUDMode && this.m_IsWanted;
         if(this.YouAreWanted_mc.visible != wantedVisible)
         {
            this.YouAreWanted_mc.visible = wantedVisible;
            if(wantedVisible)
            {
               this.YouAreWanted_mc.gotoAndPlay("rollOn");
            }
         }
         else if(wantedVisible && aBounty > 0 && aBounty > this.m_LastBounty)
         {
            this.YouAreWanted_mc.gotoAndPlay("update");
         }
         if(aBounty > 0)
         {
            this.YouAreWanted_mc.bountyAmount.bounty_tf.text = aBounty;
            if(this.m_LastBounty == 0)
            {
               GlobalFunc.PlayMenuSound("UIBountyStingerRecipient");
            }
            this.m_LastBounty = aBounty;
         }
         if(this.m_LastPowerArmor)
         {
            this.YouAreWanted_mc.y = this.m_WantedBaseY - WANTED_POWER_ARMOR_Y_OFFSET;
         }
         else
         {
            this.YouAreWanted_mc.y = this.m_WantedBaseY;
         }
      }
      
      private function updateCurrencyUpdatesPos() : void
      {
         if(this.m_LevelUpVisible || this.m_RepLevelUpVisible)
         {
            this.HUDNotificationsGroup_mc.CurrencyUpdates_mc.y = this.m_CurrencyUpdateBaseY + CURRENCY_UPDATE_LEVELUP_OFFSETY;
            GlobalFunc.PlayMenuSound("UIReputationLevelUp");
         }
         else if(this.m_RepChangeVisible)
         {
            this.HUDNotificationsGroup_mc.CurrencyUpdates_mc.y = this.m_CurrencyUpdateBaseY + CURRENCY_REPUTATION_CHANGE_OFFSETY;
         }
         else
         {
            this.HUDNotificationsGroup_mc.CurrencyUpdates_mc.y = this.m_CurrencyUpdateBaseY;
         }
      }
      
      private function onLeaderboardDataUpdate(arEvent:FromClientDataEvent) : void
      {
         var rankInfo:* = arEvent.data.localScoreboardEntry;
         this.m_ScoreboardRank = rankInfo.rank;
         this.m_ScoreboardValue = rankInfo.value;
         this.ScoreboardRank_mc.LeaderBoardRank_mc.LeaderBoardRank_tf.text = this.m_ScoreboardRank;
         this.ScoreboardRank_mc.AccountIcon_mc.LoadInternal(GlobalFunc.GetAccountIconPath(rankInfo.iconPath),GlobalFunc.PLAYER_ICON_TEXTURE_BUFFER);
         if(this.m_ScoreboardRank >= 1 && this.m_ScoreboardRank <= 3)
         {
            this.ScoreboardRank_mc.RankPip_mc.visible = true;
            this.ScoreboardRank_mc.RankPip_mc.gotoAndStop(this.m_ScoreboardRank);
         }
         else
         {
            this.ScoreboardRank_mc.RankPip_mc.visible = false;
         }
         this.updateRankVis();
      }
      
      private function onAccountInfoUpdate(arEvent:FromClientDataEvent) : void
      {
         this.m_WorldType = arEvent.data.worldType;
         this.updateHUDNotificationsOffset();
         this.updateRankVis();
      }
      
      private function onResolutionUpdate(arEvent:FromClientDataEvent) : *
      {
         gotoAndStop(arEvent.data.AspectRatio);
      }
      
      private function isUniqueFanfareVisible() : Boolean
      {
         var uniqueMC:* = this.AnnounceEventWidget_mc.UniqueItemContainer_mc;
         return uniqueMC && uniqueMC.currentFrameLabel != "off";
      }
      
      private function isOtherFanfareVisible() : Boolean
      {
         var isClipActive:Function = function(currClip:MovieClip):Boolean
         {
            if(currClip != null && currClip.currentFrameLabel != null)
            {
               return currClip.currentFrameLabel != "off";
            }
            return false;
         };
         var announceWidget:* = this.AnnounceEventWidget_mc;
         if(announceWidget == null)
         {
            return false;
         }
         return Boolean(isClipActive(announceWidget.QuestRewardContainer_mc)) || Boolean(isClipActive(announceWidget.QuestCompleteContainer_mc)) || Boolean(isClipActive(announceWidget.AnnounceAvailableQuest_mc)) || Boolean(isClipActive(announceWidget.AnnounceActiveQuest_mc)) || Boolean(isClipActive(announceWidget.AnnounceMessage_mc)) || Boolean(isClipActive(announceWidget.EventHUDNotification_mc)) || Boolean(isClipActive(announceWidget.MiscAvailableAnnounce_mc));
      }
      
      private function updateStealthMeterVisibility() : void
      {
         var bUniqueVisible:Boolean = this.isUniqueFanfareVisible();
         var bOtherVisible:Boolean = this.isOtherFanfareVisible();
         if(bUniqueVisible)
         {
            this.m_UniqueFanfareActive = true;
         }
         if(this.m_UniqueFanfareActive && !bOtherVisible)
         {
            this.TopCenterGroup_mc.StealthMeter_mc.visible = true;
            this.TopCenterGroup_mc.StealthMeter_mc.gotoAndPlay("rollOn");
         }
         else
         {
            this.TopCenterGroup_mc.StealthMeter_mc.gotoAndPlay("rollOff");
         }
      }
      
      private function onFanfareActive(e:Event) : *
      {
         this.updateStealthMeterVisibility();
         this.QuestTracker.SetAnimationBlocked(true);
         this.m_FanfareAnimating = true;
      }
      
      private function onFanfareCleared(e:Event) : *
      {
         if(!this.isUniqueFanfareVisible())
         {
            this.m_UniqueFanfareActive = false;
         }
         this.updateStealthMeterVisibility();
         this.TopCenterGroup_mc.StealthMeter_mc.gotoAndPlay("rollOn");
         this.TopCenterGroup_mc.StealthMeter_mc.visible = true;
         this.QuestTracker.SetAnimationBlocked(false);
         this.m_FanfareAnimating = false;
      }
      
      private function onRadialMenuStatusUpdate(arEvent:FromClientDataEvent) : void
      {
         this.CompassWidget_mc.y = arEvent.data.isShowing ? this.m_CompassBaseY + 1500 : this.m_CompassBaseY;
      }
      
      private function evaluateQuestAnnounceQueue() : void
      {
         var nextEvent:QuestEvent = null;
         if(!this.m_QuestAnnounceBusy && this.m_QuestAnnounceQueue.length > 0)
         {
            nextEvent = this.m_QuestAnnounceQueue.shift();
            switch(nextEvent.type)
            {
               case QuestEvent.EVENT_AVAILABLE:
                  this.onQuestAvailable(nextEvent);
            }
         }
      }
      
      public function onDpadPress(direction:String) : *
      {
         var stimpaks:String = String(Math.max(BSUIDataManager.GetDataFromClient("CharacterInfoData").data.StimpakCount - 1,0));
         this.dpadMapContainer.DpadMap_mc.StimpakText_mc.StimpakText_tf.text = stimpaks;
         this.dpadMapContainer.gotoAndPlay("dPadOn");
         this.DpadMap_mc.gotoAndStop(direction);
      }
      
      public function onQuestAvailable(aEvent:QuestEvent) : void
      {
         if(this.m_QuestAnnounceBusy)
         {
            this.m_QuestAnnounceQueue.push(aEvent);
            return;
         }
         if(aEvent.pvpFlag)
         {
            this.onPVPAnnounced(aEvent.data);
         }
      }
      
      public function onPVPAnnounced(eData:Object) : void
      {
         if(this.m_QuestAnnounceBusy)
         {
            this.m_QuestAnnounceQueue.push(new QuestEvent(QuestEvent.EVENT_AVAILABLE,eData,true,false,true));
            return;
         }
         this.m_QuestAnnounceBusy = true;
         this.AnnounceAvailableQuest_mc.Name_mc.Name_tf.text = eData.announcement;
         this.AnnounceAvailableQuest_mc.Desc_mc.Desc_tf.text = "";
         this.AnnounceAvailableQuest_mc.Title_mc.visible = false;
         this.AnnounceAvailableQuest_mc.Prompt_mc.visible = false;
         this.AnnounceAvailableQuest_mc.gotoAndPlay("rollOn");
         this.TopCenterGroup_mc.StealthMeter_mc.gotoAndPlay("rollOff");
         setTimeout(function():*
         {
            AnnounceAvailableQuest_mc.gotoAndPlay("expand");
         },3000);
         setTimeout(function():*
         {
            AnnounceAvailableQuest_mc.gotoAndPlay("rollOff");
         },8000);
         setTimeout(function():*
         {
            m_QuestAnnounceBusy = false;
            evaluateQuestAnnounceQueue();
         },11000);
      }
      
      public function onCharacterInfoUpdate(arEvent:FromClientDataEvent) : void
      {
         this.LocalEmote_mc.entityID = arEvent.data.entityID;
         this.m_IsWanted = arEvent.data.wanted;
         if(arEvent.data.showNetworkIndicator)
         {
            this.networkIndicator_mc.visible = true;
         }
         else
         {
            this.networkIndicator_mc.visible = false;
         }
         this.updateWantedVis(arEvent.data.bounty);
         this.updateRankVis();
      }
      
      internal function enterChatMode() : *
      {
         this.HUDChatBase_mc.HUDChatEntryWidget_mc.ChatEntryText_tf.border = true;
         stage.focus = this.HUDChatBase_mc.HUDChatEntryWidget_mc.ChatEntryText_tf;
         BSUIDataManager.dispatchEvent(new CustomEvent(ON_STARTEDITTEXT,{"tag":"Chat"}));
      }
      
      internal function resetChatMode() : *
      {
         this.HUDChatBase_mc.HUDChatEntryWidget_mc.ChatEntryText_tf.border = false;
         stage.focus = stage;
         this.HUDChatBase_mc.HUDChatEntryWidget_mc.ChatEntryText_tf.text = "";
         BSUIDataManager.dispatchEvent(new CustomEvent(ON_ENDEDITTEXT,{"tag":"Chat"}));
      }
      
      internal function chatEntryKeyUp(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ESCAPE)
         {
            this.resetChatMode();
         }
         if(event.keyCode == Keyboard.ENTER)
         {
            this.sendChatMessage(this.HUDChatBase_mc.HUDChatEntryWidget_mc.ChatEntryText_tf.text);
            this.resetChatMode();
            BSUIDataManager.dispatchEvent(new CustomEvent(GlobalFunc.PLAY_MENU_SOUND,{"soundID":"UIGeneralTextPopUp"}));
         }
      }
      
      internal function chatEntryFocusOut(event:FocusEvent) : void
      {
         this.resetChatMode();
      }
      
      public function sendChatMessage(Message:String) : *
      {
         var Username:String = "NoUsername";
         if(this.CharacterInfoData)
         {
            Username = this.CharacterInfoData.name;
         }
         if(Message.length > 0 && Message != "")
         {
            BSUIDataManager.dispatchEvent(new NetworkedUIEvent("networked::UIEVENT","ChatMessage",Username,"All",Message));
         }
      }
      
      public function OnNetworkedUIEventReceived(EventType:String, EventSender:String, EventTarget:String, EventData:String) : *
      {
         if(EventType == "ChatMessage")
         {
            this.HUDChatBase_mc.HUDChatWidget_mc.addChatMessage(EventData,EventSender);
         }
      }
      
      private function onFFEvent(arEvent:FromClientDataEvent) : void
      {
         var data:* = arEvent.data;
         if(GlobalFunc.HasFFEvent(data,EVENT_FOCUS_LOST))
         {
            this.clearButtonHold();
         }
      }
      
      public function ProcessUserEvent(strEventName:String, abPressed:Boolean) : Boolean
      {
         var data:Object = null;
         this.m_FanfareAnimating = true;
         var bhandled:Boolean = false;
         dispatchEvent(new HUDModUserEvent(strEventName,abPressed));
         if(this.FrobberWidget_mc.show && !bhandled)
         {
            bhandled = this.FrobberWidget_mc.ProcessUserEvent(strEventName,abPressed);
         }
         if(!bhandled && this.HUDNotificationsGroup_mc.Messages_mc.pressAndHoldActive && Boolean(this.HUDNotificationsGroup_mc.Messages_mc.currentPressAndHoldMessage))
         {
            data = {
               "eventName":strEventName,
               "pressed":abPressed,
               "buttonsOrBar":this.HUDNotificationsGroup_mc.Messages_mc.currentPressAndHoldMessage.ButtonHintBar_mc,
               "handled":false
            };
            this.m_HoldProcessor.processButtonHold(data);
            bhandled = Boolean(data.handled);
         }
         if(this.m_FanfareAnimating && !bhandled)
         {
            bhandled = this.AnnounceEventWidget_mc.ProcessUserEvent(strEventName,abPressed);
         }
         if(!bhandled && !abPressed)
         {
            switch(strEventName)
            {
               case "TeamChat":
                  if(this.ControlMapData.textEntryMode == "")
                  {
                     this.enterChatMode();
                  }
                  bhandled = true;
            }
         }
         return bhandled;
      }
      
      private function clearButtonHold() : void
      {
         if(this.HUDNotificationsGroup_mc.Messages_mc.currentPressAndHoldMessage)
         {
            this.HUDNotificationsGroup_mc.Messages_mc.currentPressAndHoldMessage.ButtonHintBar_mc.HideAllButtons();
            this.HUDNotificationsGroup_mc.Messages_mc.ClearPressAndHoldMessage();
            this.m_HoldProcessor.reset();
         }
      }
      
      public function onButtonPressEvent(strInputEventName:String, strDispatchEventName:String, abButtonDisplayed:Boolean = false, aDataID:uint = 0) : Boolean
      {
         var bhandled:* = false;
         if(strDispatchEventName != "")
         {
            if(this.hasOwnProperty(strDispatchEventName))
            {
               this[strDispatchEventName]();
            }
            else if(strDispatchEventName == HUDMessageItemRecentActivity.EVENT_JOIN)
            {
               if(this.HUDNotificationsGroup_mc.Messages_mc.currentPressAndHoldMessage)
               {
                  BSUIDataManager.dispatchEvent(new CustomEvent(strDispatchEventName,{"locationID":this.HUDNotificationsGroup_mc.Messages_mc.currentPressAndHoldMessage.data.data.recentActivityId}));
               }
               this.clearButtonHold();
            }
            else
            {
               BSUIDataManager.dispatchEvent(new CustomEvent(strDispatchEventName,{"ID":aDataID}));
            }
            bhandled = true;
         }
         return bhandled;
      }
      
      override protected function onSetSafeRect() : void
      {
         GlobalFunc.LockToSafeRect(this.CenterGroup_mc,"CC",SafeX,SafeY);
      }
      
      public function onCodeObjCreate() : *
      {
         (this.RightMeters_mc.PowerArmorLowBatteryWarning_mc.WarningTextHolder_mc as PAWarningText).codeObj = this.BGSCodeObj;
      }
      
      public function onCodeObjDestruction() : *
      {
         this.BGSCodeObj = null;
         (this.RightMeters_mc.PowerArmorLowBatteryWarning_mc.WarningTextHolder_mc as PAWarningText).codeObj = null;
      }
      
      private function handleTeamInviteAccept() : *
      {
         BSUIDataManager.dispatchEvent(new NetworkedUIEvent("networked::UIEVENT","TeamInviteAccepted",this.CharacterInfoData.name,this.RequestUsername,"NoData"));
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
      
      internal function frame3() : *
      {
         stop();
      }
   }
}

