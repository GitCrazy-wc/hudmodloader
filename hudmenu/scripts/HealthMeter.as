package
{
   import Shared.AS3.BSUIComponent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class HealthMeter extends BSUIComponent
   {
      
      public var MeterBar_mc:MovieClip;
      
      public var MeterBarEnemy_mc:MovieClip;
      
      public var MeterBarFriendly_mc:MovieClip;
      
      public var MeterFrame_mc:MovieClip;
      
      public var Optional_mc:MovieClip;
      
      public var DisplayText_mc:MovieClip;
      
      public var LegendaryIcon_mc:MovieClip;
      
      public var RadsBar_mc:MovieClip;
      
      public var EncounterHolder_mc:EncounterHolder;
      
      public var CampRepairIcon_mc:MovieClip;
      
      public var LevelText_mc:MovieClip;
      
      public var OwnerInfo_mc:MovieClip;
      
      public var DoTIconsManager_mc:DoTIconsManager;
      
      public var HealthBarFrame_mc:MovieClip;
      
      public var BossIcon_mc:MovieClip;
      
      private var m_IsHostile:Boolean = true;
      
      private var m_IsFriendly:Boolean = true;
      
      private var m_OwningPlayerName:String = "";
      
      private var m_AvatarID:String = "";
      
      private var m_IsBoss:Boolean = false;
      
      private var m_TargetLevel:int = 0;
      
      private var m_Wanted:Boolean = false;
      
      private var m_DoTDamage:Boolean = false;
      
      private var m_EncounterIconLevel:int = 0;
      
      private var m_EncounterIconType:int = 0;
      
      private var m_ShowPassiveRepairIcon:Boolean = false;
      
      private var DisplayText_tf:TextField;
      
      public function HealthMeter()
      {
         super();
         Extensions.enabled = true;
         if(this.OwnerInfo_mc)
         {
            TextFieldEx.setTextAutoSize(this.OwnerInfo_mc.Name_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            this.OwnerInfo_mc.AccountIcon_mc.clipWidth = this.OwnerInfo_mc.AccountIcon_mc.width * (1 / this.OwnerInfo_mc.AccountIcon_mc.scaleX);
            this.OwnerInfo_mc.AccountIcon_mc.clipHeight = this.OwnerInfo_mc.AccountIcon_mc.height * (1 / this.OwnerInfo_mc.AccountIcon_mc.scaleY);
         }
         if(Boolean(this.LevelText_mc) && Boolean(this.LevelText_mc.LevelText_tf))
         {
            TextFieldEx.setTextAutoSize(this.LevelText_mc.LevelText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         if(Boolean(this.DisplayText_mc) && Boolean(this.DisplayText_mc.DisplayText_tf))
         {
            TextFieldEx.setTextAutoSize(this.DisplayText_mc.DisplayText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         if(this.DoTIconsManager_mc)
         {
            this.DoTIconsManager_mc.alignment = DoTIconsManager.ALIGNMENT_LEFT;
            this.DoTIconsManager_mc.SetStealthMeterAwareness(false);
            addEventListener(DoTIconsManager.EVENT_DOT_COMPLETE,this.onDamageComplete);
         }
         if(this.CampRepairIcon_mc)
         {
            this.CampRepairIcon_mc.alpha = 1;
         }
         if(this.EncounterHolder_mc)
         {
            this.EncounterHolder_mc.visible = false;
         }
      }
      
      public function set IsHostile(value:Boolean) : *
      {
         if(this.m_IsHostile != value)
         {
            this.m_IsHostile = value;
            this.UpdateBarFlag();
         }
      }
      
      public function set IsFriendly(value:Boolean) : *
      {
         if(this.m_IsFriendly != value)
         {
            this.m_IsFriendly = value;
            this.UpdateBarFlag();
         }
      }
      
      public function set OwningPlayerName(aValue:String) : void
      {
         if(aValue != this.m_OwningPlayerName)
         {
            this.m_OwningPlayerName = aValue;
            SetIsDirty();
         }
      }
      
      public function set AvatarID(aValue:String) : void
      {
         if(aValue != this.m_AvatarID)
         {
            this.m_AvatarID = aValue;
            SetIsDirty();
         }
      }
      
      public function set IsBoss(value:Boolean) : *
      {
         if(this.m_IsBoss != value)
         {
            this.m_IsBoss = value;
            this.UpdateBarFlag();
         }
      }
      
      public function set TargetLevel(value:int) : *
      {
         if(this.m_TargetLevel != value)
         {
            this.m_TargetLevel = value;
            this.UpdateBarFlag();
         }
      }
      
      public function set Wanted(value:Boolean) : *
      {
         if(this.m_Wanted != value)
         {
            this.m_Wanted = value;
            this.UpdateBarFlag();
         }
      }
      
      public function set DoTDamage(aValue:Boolean) : *
      {
         if(this.m_DoTDamage != aValue)
         {
            this.m_DoTDamage = aValue;
            this.UpdateBarFlag();
            this.DoTIconsManager_mc.reset();
         }
      }
      
      public function set EncounterIconType(aValue:int) : *
      {
         if(this.m_EncounterIconType != aValue)
         {
            this.m_EncounterIconType = aValue;
            SetIsDirty();
         }
         if(Boolean(this.EncounterHolder_mc) && !this.EncounterHolder_mc.hasEventListener(Event.ENTER_FRAME))
         {
            this.EncounterHolder_mc.addEventListener(Event.ENTER_FRAME,this.onSetEncounterIcon);
         }
      }
      
      public function set EncounterIconLevel(aValue:int) : *
      {
         if(this.m_EncounterIconLevel != aValue)
         {
            this.m_EncounterIconLevel = aValue;
            SetIsDirty();
         }
         if(Boolean(this.EncounterHolder_mc) && !this.EncounterHolder_mc.hasEventListener(Event.ENTER_FRAME))
         {
            this.EncounterHolder_mc.addEventListener(Event.ENTER_FRAME,this.onSetEncounterIcon);
         }
      }
      
      public function set DoTDamageList(aValues:Array) : *
      {
         if(this.DoTIconsManager_mc)
         {
            this.DoTDamage = this.DoTIconsManager_mc.populateIcons(aValues);
         }
      }
      
      public function SetStealthVisible(abStealthVisible:Boolean) : void
      {
         if(this.DoTIconsManager_mc)
         {
            this.DoTIconsManager_mc.SetStealthMeterStatus(abStealthVisible);
         }
      }
      
      private function onDamageComplete(aEvent:Event) : void
      {
         if(this.DoTIconsManager_mc)
         {
            if(!this.DoTIconsManager_mc.isActive() && this.m_DoTDamage)
            {
               this.DoTDamage = false;
            }
         }
      }
      
      private function UpdateBarFlag() : *
      {
         if(this.m_IsHostile || this.m_Wanted)
         {
            gotoAndStop("Hostile");
         }
         else
         {
            gotoAndStop(this.m_IsFriendly ? "Friendly" : "Nonhostile");
         }
         if(this.m_DoTDamage)
         {
            this.HealthBarFrame_mc.gotoAndPlay("StartDoTFlash");
         }
         else
         {
            this.HealthBarFrame_mc.gotoAndStop("static");
         }
         this.LevelText_mc.gotoAndStop(this.m_IsBoss ? "star" : "square");
         this.LevelText_mc.LevelText_tf.text = this.m_TargetLevel.toString();
         SetIsDirty();
      }
      
      public function SetMeterPercent(afPercent:Number) : *
      {
         this.MeterBar_mc.Percent = afPercent / 100;
      }
      
      override public function redrawUIComponent() : void
      {
         if(this.OwnerInfo_mc)
         {
            if(this.m_OwningPlayerName.length > 0)
            {
               this.OwnerInfo_mc.visible = true;
               this.OwnerInfo_mc.Name_tf.text = this.m_OwningPlayerName;
               (this.OwnerInfo_mc.AccountIcon_mc as ImageFixture).LoadExternal(GlobalFunc.GetAccountIconPath(this.m_AvatarID),GlobalFunc.PLAYER_ICON_TEXTURE_BUFFER);
               this.OwnerInfo_mc.x = this.LevelText_mc.x - this.LevelText_mc.width - this.OwnerInfo_mc.width;
            }
            else
            {
               this.OwnerInfo_mc.visible = false;
            }
         }
      }
      
      public function SetDamageList(aDamageList:Array) : void
      {
         if(this.DoTIconsManager_mc)
         {
            this.DoTDamage = this.DoTIconsManager_mc.populateIcons(aDamageList);
         }
      }
      
      private function onSetEncounterIcon() : *
      {
         if(this.m_EncounterIconLevel > 0 && this.m_EncounterIconType > EncounterHolder.ENCOUNTER_TYPE_NONE)
         {
            this.EncounterHolder_mc.visible = true;
            this.EncounterHolder_mc.SetIcon(this.m_EncounterIconType,this.m_EncounterIconLevel,this.m_IsBoss);
            this.EncounterHolder_mc.x = this.LevelText_mc.x + this.LevelText_mc.width / 2 - this.EncounterHolder_mc.GetIconLevelFramePadding(this.m_EncounterIconLevel);
         }
         else
         {
            this.EncounterHolder_mc.visible = false;
         }
         this.EncounterHolder_mc.removeEventListener(Event.ENTER_FRAME,this.onSetEncounterIcon);
      }
      
      public function set ShowPassiveRepairIcon(aValue:Boolean) : *
      {
         if(this.m_ShowPassiveRepairIcon != aValue)
         {
            this.m_ShowPassiveRepairIcon = aValue;
            SetIsDirty();
         }
         if(!this.CampRepairIcon_mc.hasEventListener(Event.ENTER_FRAME))
         {
            this.CampRepairIcon_mc.addEventListener(Event.ENTER_FRAME,this.onSetShowPassiveRepairIcon);
         }
      }
      
      private function onSetShowPassiveRepairIcon() : *
      {
         this.CampRepairIcon_mc.visible = this.m_ShowPassiveRepairIcon;
         this.CampRepairIcon_mc.removeEventListener(Event.ENTER_FRAME,this.onSetShowPassiveRepairIcon);
         SetIsDirty();
      }
   }
}

