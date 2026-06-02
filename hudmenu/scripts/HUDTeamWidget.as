package
{
   import Overlay.PublicTeams.PublicTeamsBondMeter;
   import Overlay.PublicTeams.PublicTeamsIcon;
   import Overlay.PublicTeams.PublicTeamsShared;
   import Shared.AS3.BSScrollingListEntry;
   import Shared.AS3.BSUIComponent;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Data.UIDataFromClient;
   import Shared.AS3.StyleSheet;
   import Shared.AS3.Styles.HUDPartyListStyle;
   import Shared.GlobalFunc;
   import Shared.HUDModes;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol966")]
   public dynamic class HUDTeamWidget extends BSUIComponent
   {
      
      public static const PUBLIC_TEAMS_HEADER_OFFSET:Number = 20;
      
      public static const PUBLIC_TEAMS_ICON_OFFSET:Number = 3;
      
      public static const AREA_VOICE_LIST_OFFSET:Number = 20;
      
      public static const TEAM_MAX_PLAYERS:uint = 4;
      
      public static const FLA_FPS:uint = 30;
      
      private static const EVENT_EXP_FLARE_ANIM_COMPLETE:String = "PartyListEntry::EmbarkAnimComplete";
      
      private static var _inPowerArmor:Boolean = false;
      
      public var PartyList:MenuListComponent;
      
      public var AreaVoiceList_mc:AreaVoiceList;
      
      public var PTPartyListHeader_mc:MovieClip;
      
      public var PTPartyHeaderTeamType_mc:MovieClip;
      
      public var PTPartyHeaderBonus_mc:MovieClip;
      
      public var PTHUDIcon_mc:PublicTeamsIcon;
      
      public var BonusMultiplier_tf:TextField;
      
      public var Bonus_tf:TextField;
      
      public var TeamType_tf:TextField;
      
      private var m_AreaVoiceListBaseY:Number;
      
      private var partyListData:Array = new Array();
      
      private var partyListMenuData:Array = new Array();
      
      private var m_HudMode:String = "All";
      
      private var m_TeamType:uint = 0;
      
      private var m_LoadingMenuOpen:Boolean = false;
      
      public function HUDTeamWidget()
      {
         super();
         StyleSheet.apply(this.PartyList,false,HUDPartyListStyle);
         this.m_AreaVoiceListBaseY = this.AreaVoiceList_mc.y;
         this.PTPartyListHeader_mc.visible = false;
         this.PTPartyHeaderTeamType_mc = this.PTPartyListHeader_mc.PTPartyHeaderTeamType_mc;
         this.PTPartyHeaderBonus_mc = this.PTPartyListHeader_mc.PTPartyHeaderBonus_mc;
         this.PTHUDIcon_mc = this.PTPartyListHeader_mc.PTHUDIcon_mc;
         this.BonusMultiplier_tf = this.PTPartyHeaderBonus_mc.BonusMultiplier_tf;
         this.Bonus_tf = this.PTPartyHeaderBonus_mc.Bonus_tf;
         this.TeamType_tf = this.PTPartyHeaderTeamType_mc.TeamType_tf;
         TextFieldEx.setTextAutoSize(this.TeamType_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.BonusMultiplier_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Bonus_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public static function get inPA() : Boolean
      {
         return _inPowerArmor;
      }
      
      public static function set inPA(aBool:Boolean) : void
      {
         _inPowerArmor = aBool;
      }
      
      override public function onAddedToStage() : void
      {
         BSUIDataManager.Subscribe("PartyMenuList",function(arEvent:FromClientDataEvent):*
         {
            m_TeamType = arEvent.data.teamType;
            partyListData = arEvent.data.members;
            var len:uint = partyListData.length;
            partyListMenuData.splice(0);
            var i:uint = 0;
            while(i < TEAM_MAX_PLAYERS && i < len)
            {
               if(partyListData[i] != null && partyListData[i].isVisible && partyListData[i].avatarId != "IconAddFriend" && Boolean(partyListData[i].isOnServer))
               {
                  partyListMenuData.push(partyListData[i]);
               }
               i++;
            }
            PartyList.List_mc.MenuListData = partyListMenuData;
            PartyList.addEventListener(PublicTeamsBondMeter.EVENT_BOND_METER_COMPLETE,onBondComplete);
            PartyList.SetIsDirty();
            PublicTeamsBondMeter.LAST_BOND_UPDATE_TIME = new Date().getTime() / 1000;
            SetIsDirty();
         });
         BSUIDataManager.Subscribe("HUDModeData",function(arEvent:FromClientDataEvent):*
         {
            m_HudMode = arEvent.data.hudMode;
            SetIsDirty();
         });
         BSUIDataManager.Subscribe("MenuStackData",function(arEvent:FromClientDataEvent):*
         {
            SetIsDirty();
         });
      }
      
      override public function redrawUIComponent() : void
      {
         var partyListClip:BSScrollingListEntry = null;
         var clipHeight:* = undefined;
         var clip:PartyListEntry = null;
         var it:uint = 0;
         var entryClip:PartyListEntry = null;
         this.PartyList.visible = this.determinePartyListVisibility();
         var fadeOut:Boolean = this.m_HudMode == HUDModes.CONTAINER_MODE || this.m_HudMode == HUDModes.WORKSHOP_MODE || this.m_HudMode == HUDModes.WORKSHOP_NO_CROSSHAIR_MODE || this.m_HudMode == HUDModes.PIPBOY || this.m_HudMode == HUDModes.TERMINAL_MODE;
         this.PartyList.alpha = fadeOut ? 0.5 : 1;
         this.PTPartyListHeader_mc.alpha = fadeOut ? 0.5 : 1;
         var partyListLen:uint = this.partyListMenuData.length;
         this.UpdatePublicTeamsHeader();
         if(partyListLen > 0)
         {
            partyListClip = this.PartyList.List_mc.GetClipByIndex(0);
            clipHeight = partyListClip.Sizer_mc ? partyListClip.Sizer_mc.height : partyListClip.height;
            this.AreaVoiceList_mc.y = this.m_AreaVoiceListBaseY - this.PTPartyListHeader_mc.height - clipHeight * partyListLen - AREA_VOICE_LIST_OFFSET;
         }
         else
         {
            this.AreaVoiceList_mc.y = this.m_AreaVoiceListBaseY;
         }
         var animatingExpFlareCount:uint = 0;
         var expFlareCountToShow:uint = 0;
         for(var i:uint = 0; i < TEAM_MAX_PLAYERS; i++)
         {
            clip = this.PartyList.List_mc.GetClipByIndex(i) as PartyListEntry;
            if(clip && clip.BondMeter_mc && !clip.visible && clip.BondMeter_mc.bondMeterState == PublicTeamsBondMeter.BOND_METER_FILLING)
            {
               clip.BondMeter_mc.bondMeterState = PublicTeamsBondMeter.BOND_METER_OFF;
            }
            if(Boolean(clip) && (!clip.visible || !this.PartyList.visible))
            {
               clip.showExpeditionFlare = false;
            }
            if(Boolean(clip) && clip.visible)
            {
               if(clip.isExpFlareAnimating)
               {
                  animatingExpFlareCount++;
               }
               else if(clip.showExpeditionFlare)
               {
                  expFlareCountToShow++;
               }
            }
         }
         if(animatingExpFlareCount == 0 && expFlareCountToShow > 0)
         {
            for(it = 0; it < TEAM_MAX_PLAYERS; it++)
            {
               entryClip = this.PartyList.List_mc.GetClipByIndex(it) as PartyListEntry;
               if(entryClip && entryClip.visible && entryClip.showExpeditionFlare)
               {
                  entryClip.animateExpFlare();
               }
            }
            GlobalFunc.PlayMenuSound("UIXpdHudFlair");
         }
         if(this.PartyList.visible && (animatingExpFlareCount > 0 || expFlareCountToShow > 0))
         {
            stage.addEventListener(EVENT_EXP_FLARE_ANIM_COMPLETE,this.onEmbarkAnimComplete);
         }
         else
         {
            stage.removeEventListener(EVENT_EXP_FLARE_ANIM_COMPLETE,this.onEmbarkAnimComplete);
         }
      }
      
      private function determinePartyListVisibility() : Boolean
      {
         var menuStackData:UIDataFromClient = null;
         var loadingMenuFound:Boolean = false;
         var menuStackA:Array = null;
         var i:int = 0;
         var shouldShowPartyList:Boolean = true;
         if(this.partyListMenuData.length == 0)
         {
            shouldShowPartyList = false;
         }
         if(shouldShowPartyList)
         {
            switch(this.m_HudMode)
            {
               case HUDModes.INSPECT_MODE:
               case HUDModes.CONTAINER_MODE:
               case HUDModes.PERKS_MODE:
               case HUDModes.LEGENDARY_PERKS_MODE:
               case HUDModes.MAP_MENU:
               case HUDModes.FURNITURE_ENTER_EXIT:
               case HUDModes.WORKSHOP_MODE:
               case HUDModes.WORKSHOP_NO_CROSSHAIR_MODE:
               case HUDModes.EXAMINE_CONFIRM_MODE:
                  shouldShowPartyList = false;
            }
         }
         if(shouldShowPartyList)
         {
            menuStackData = BSUIDataManager.GetDataFromClient("MenuStackData");
            if(menuStackData && menuStackData.data && Boolean(menuStackData.data.menuStackA))
            {
               loadingMenuFound = false;
               for(menuStackA = menuStackData.data.menuStackA; i < menuStackA.length; )
               {
                  if(menuStackA[i].menuName == "ExamineMenu" || menuStackA[i].menuName == "MapMenu")
                  {
                     shouldShowPartyList = false;
                  }
                  else if(menuStackA[i].menuName == "LoadingMenu")
                  {
                     loadingMenuFound = true;
                  }
                  i++;
               }
               if(!loadingMenuFound && this.m_LoadingMenuOpen)
               {
                  this.PartyList.SetIsDirty();
               }
               this.m_LoadingMenuOpen = loadingMenuFound;
            }
         }
         return shouldShowPartyList;
      }
      
      private function UpdatePublicTeamsHeader() : void
      {
         var teamType:uint = 0;
         var typeString:String = null;
         var numOfBonds:int = 0;
         var numOfEntries:int = 0;
         var i:int = 0;
         var entry:PartyListEntry = null;
         if(PublicTeamsShared.IsValidPublicTeamType(this.m_TeamType) && this.PartyList.visible)
         {
            teamType = this.m_TeamType;
            typeString = PublicTeamsShared.DecideTeamTypeString(teamType);
            this.TeamType_tf.text = GlobalFunc.LocalizeFormattedString("{1} {2}","$PT" + typeString,"$TEAM");
            this.PTHUDIcon_mc.setIconType(teamType);
            this.PTHUDIcon_mc.x = this.PTPartyHeaderTeamType_mc.x + this.TeamType_tf.textWidth + PUBLIC_TEAMS_ICON_OFFSET;
            numOfBonds = 0;
            numOfEntries = int(this.PartyList.List_mc.entryList.length);
            for(i = 0; i < numOfEntries; i++)
            {
               entry = this.PartyList.List_mc.GetClipByIndex(i) as PartyListEntry;
               if(entry.BondMeter_mc.isBonded)
               {
                  numOfBonds++;
               }
            }
            this.PTPartyHeaderBonus_mc.visible = true;
            this.BonusMultiplier_tf.text = "X" + (numOfBonds + 1).toString();
            if(numOfEntries > 0)
            {
               this.PTPartyListHeader_mc.y = this.PartyList.List_mc.GetClipByIndex(numOfEntries - 1).y - this.PTPartyListHeader_mc.height - PUBLIC_TEAMS_HEADER_OFFSET;
               this.PTPartyListHeader_mc.visible = true;
            }
         }
         else
         {
            this.PTPartyListHeader_mc.visible = false;
         }
      }
      
      private function onBondComplete(aEvent:Event) : void
      {
         this.UpdatePublicTeamsHeader();
      }
      
      public function onEmbarkAnimComplete(aEvent:Event) : void
      {
         var i:uint = 0;
         var clip:PartyListEntry = null;
         if(this.PartyList.visible)
         {
            aEvent.stopPropagation();
            GlobalFunc.PlayMenuSound("UIXpdHudFlair");
            for(i = 0; i < TEAM_MAX_PLAYERS; i++)
            {
               clip = this.PartyList.List_mc.GetClipByIndex(i) as PartyListEntry;
               if(clip && clip.visible && clip.showExpeditionFlare && !clip.isExpFlareAnimating)
               {
                  clip.animateExpFlare();
               }
            }
         }
      }
   }
}

