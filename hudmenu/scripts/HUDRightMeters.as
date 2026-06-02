package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import Shared.HUDModes;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1759")]
   public class HUDRightMeters extends MovieClip
   {
      
      public static const FADE_DELAY:Number = 10000;
      
      public var PowerArmorLowBatteryWarning_mc:MovieClip;
      
      public var LocalEmote_mc:EmoteWidget;
      
      public var FlashLightWidget_mc:MovieClip;
      
      public var ExplosiveAmmoCount_mc:MovieClip;
      
      public var AmmoCount_mc:MovieClip;
      
      public var FatigueWarning_mc:MovieClip;
      
      public var ActionPointMeter_mc:MovieClip;
      
      public var OverheatMeter_mc:MovieClip;
      
      public var HUDActiveEffectsWidget_mc:HUDActiveEffectsWidget;
      
      public var HUDHungerMeter_mc:MovieClip;
      
      public var HUDThirstMeter_mc:MovieClip;
      
      public var FeralMeter_mc:MovieClip;
      
      public var HUDFusionCoreMeter_mc:MovieClip;
      
      private var bShowHunger:Boolean = false;
      
      private var bShowThirst:Boolean = false;
      
      private var bShowFusionCore:Boolean = false;
      
      private var bShowFeral:Boolean = false;
      
      private var m_FusionCorePercent:Number = 0;
      
      private var m_FusionCoreWarnPercent:Number = 0;
      
      private var m_FusionCoreCount:uint = 0;
      
      private var m_InPowerArmor:Boolean = false;
      
      private var m_PowerArmorHUDEnabled:Boolean = true;
      
      private var fHungerPercent:Number = -1;
      
      private var fThirstPercent:Number = -1;
      
      private var fFeralPercent:Number = -1;
      
      private var bHungerVisible:Boolean = false;
      
      private var bThirstVisible:Boolean = false;
      
      private var bFeralVisible:Boolean = false;
      
      private var HungerTimeout:int = -1;
      
      private var ThirstTimeout:int = -1;
      
      private var PercentIndefiniteShow:Number = 0.2;
      
      private const PercentChangeVal:Number = 0.03;
      
      private const PercentMax:Number = 1;
      
      private var m_ValidHudModes:Array;
      
      private var bIsPip:Boolean = false;
      
      private var oldHudMode:* = "All";
      
      public function HUDRightMeters()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
         BSUIDataManager.Subscribe("HUDRightMetersData",this.onStateUpdate);
         this.m_ValidHudModes = new Array(HUDModes.ALL,HUDModes.ACTIVATE_TYPE,HUDModes.IRON_SIGHTS,HUDModes.POWER_ARMOR,HUDModes.PIPBOY,HUDModes.DEFAULT_SCOPE_MENU,HUDModes.CAMERA_SCOPE_MENU,HUDModes.VERTIBIRD_MODE,HUDModes.SIT_WAIT_MODE,HUDModes.VATS_MODE);
         BSUIDataManager.Subscribe("HUDModeData",this.onHudModeDataChange);
         BSUIDataManager.Subscribe("PowerArmorInfoData",this.onPowerArmorInfoUpdate);
         gotoAndStop("defaultHUD");
         this.HUDHungerMeter_mc.gotoAndStop("off");
         this.HUDThirstMeter_mc.gotoAndStop("off");
         this.HUDFusionCoreMeter_mc.gotoAndStop("off");
         this.FeralMeter_mc.gotoAndStop("off");
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.AmmoCount_mc.ClipCount_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.AmmoCount_mc.ReserveCount_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.OverheatMeter_mc.visible = false;
         this.SetOverheatMeterPercent(0);
      }
      
      public function set showFusionCoreMeter(aShow:Boolean) : void
      {
         if(aShow != this.bShowFusionCore)
         {
            this.bShowFusionCore = aShow;
            if(aShow)
            {
               this.HUDFusionCoreMeter_mc.gotoAndPlay("rollOn");
            }
            else
            {
               this.HUDFusionCoreMeter_mc.gotoAndPlay("rollOff");
            }
         }
      }
      
      private function updateFusionCoreMeter() : void
      {
         var corePercent:Number = GlobalFunc.Clamp(this.m_FusionCorePercent,0,this.PercentMax) / this.PercentMax;
         var coreFrame:int = Math.ceil(corePercent * this.HUDFusionCoreMeter_mc.Meter_mc.totalFrames);
         this.HUDFusionCoreMeter_mc.Meter_mc.gotoAndStop(coreFrame);
         var displayCount:uint = GlobalFunc.Clamp(this.m_FusionCoreCount,0,9);
         this.HUDFusionCoreMeter_mc.CoreCount_mc.CoreCount_tf.text = "x" + this.m_FusionCoreCount;
         if(this.m_FusionCoreCount == 0 && this.m_FusionCorePercent < this.m_FusionCoreWarnPercent)
         {
            this.HUDFusionCoreMeter_mc.survivalMeterIcon_mc.gotoAndStop("coreNegative");
         }
         else
         {
            this.HUDFusionCoreMeter_mc.survivalMeterIcon_mc.gotoAndStop("corePositive");
         }
      }
      
      private function onPowerArmorInfoUpdate(arEvent:FromClientDataEvent) : void
      {
         this.m_FusionCorePercent = arEvent.data.fusionCorePercent;
         this.m_FusionCoreWarnPercent = arEvent.data.fusionCoreWarnPercent;
         this.m_FusionCoreCount = arEvent.data.fusionCoreCount;
         if(this.bShowFusionCore)
         {
            this.updateFusionCoreMeter();
         }
      }
      
      private function onHudModeDataChange(event:FromClientDataEvent) : *
      {
         this.visible = this.m_ValidHudModes.indexOf(event.data.hudMode) != -1;
         this.m_InPowerArmor = event.data.inPowerArmor;
         this.m_PowerArmorHUDEnabled = event.data.powerArmorHUDEnabled;
         this.showFusionCoreMeter = this.m_InPowerArmor && !this.m_PowerArmorHUDEnabled;
         if(this.bShowFusionCore)
         {
            this.updateFusionCoreMeter();
         }
         var bWasPip:Boolean = this.bIsPip;
         this.bIsPip = event.data.hudMode == HUDModes.PIPBOY;
         if(this.bIsPip)
         {
            if(this.fHungerPercent >= 0 && this.bHungerVisible)
            {
               this.endHungerHideTimeout();
               this.fadeInHunger();
            }
            if(this.fThirstPercent >= 0 && this.bThirstVisible)
            {
               this.endThirstHideTimeout();
               this.fadeInThirst();
            }
            if(this.fFeralPercent >= 0 && this.bFeralVisible)
            {
               this.fadeInFeral();
            }
         }
         else if(this.visible && bWasPip)
         {
            if(this.HungerTimeout == -1 && this.fHungerPercent >= this.PercentIndefiniteShow)
            {
               this.HungerTimeout = setTimeout(this.fadeOutHunger,FADE_DELAY);
            }
            if(this.ThirstTimeout == -1 && this.fThirstPercent >= this.PercentIndefiniteShow)
            {
               this.ThirstTimeout = setTimeout(this.fadeOutThirst,FADE_DELAY);
            }
         }
         if(Boolean(event.data.inPowerArmor) && Boolean(event.data.powerArmorHUDEnabled))
         {
            gotoAndStop("powerArmorHUD");
         }
         else
         {
            gotoAndStop("defaultHUD");
         }
         this.oldHudMode = event.data.hudMode;
      }
      
      private function onStateUpdate(arEvent:FromClientDataEvent) : *
      {
         var hungerFrame:int = 0;
         var hungerRestorePercent:Number = NaN;
         var hungerRestoreFrame:int = 0;
         var thirstFrame:int = 0;
         var thirstRestorePercent:Number = NaN;
         var thirstRestoreFrame:int = 0;
         var newData:Object = arEvent.data;
         this.HUDActiveEffectsWidget_mc.onDataUpdate(newData.activeEffects);
         var hungerPercentTmp:Number = Number(newData.hungerPercent);
         var thirstPercentTmp:Number = Number(newData.thirstPercent);
         var feralPercentTmp:Number = Number(newData.feralPercent);
         this.bHungerVisible = newData.hungerVisible;
         this.bThirstVisible = newData.thirstVisible;
         this.bFeralVisible = newData.feralVisible;
         if(this.bHungerVisible)
         {
            if(hungerPercentTmp < this.PercentIndefiniteShow)
            {
               this.endHungerHideTimeout();
               this.fadeInHunger();
            }
            else if(!GlobalFunc.CloseToNumber(this.fHungerPercent,hungerPercentTmp,this.PercentChangeVal) || hungerPercentTmp > this.fHungerPercent)
            {
               this.endHungerHideTimeout();
               this.fadeInHunger();
               this.HungerTimeout = setTimeout(this.fadeOutHunger,FADE_DELAY);
            }
            this.fHungerPercent = hungerPercentTmp;
            hungerPercentTmp = GlobalFunc.Clamp(hungerPercentTmp,0,this.PercentMax) / this.PercentMax;
            hungerFrame = Math.ceil(hungerPercentTmp * this.HUDHungerMeter_mc.Meter_mc.totalFrames);
            this.HUDHungerMeter_mc.Meter_mc.gotoAndStop(hungerFrame);
            this.HUDHungerMeter_mc.survivalMeterIcon_mc.gotoAndStop("foodPositive");
            if(newData.hunger_RestorePct is Number && newData.hunger_RestorePct > 0)
            {
               hungerRestorePercent = GlobalFunc.Clamp(this.fHungerPercent + newData.hunger_RestorePct,0,this.PercentMax) / this.PercentMax;
               hungerRestoreFrame = Math.ceil(hungerRestorePercent * this.HUDHungerMeter_mc.GhostMeter_mc.totalFrames);
               this.HUDHungerMeter_mc.GhostMeter_mc.gotoAndStop(hungerRestoreFrame);
               this.HUDHungerMeter_mc.GhostMeter_mc.visible = true;
            }
            else
            {
               this.HUDHungerMeter_mc.GhostMeter_mc.visible = false;
            }
         }
         else if(this.bShowHunger)
         {
            this.setHungerOff();
         }
         if(this.bThirstVisible)
         {
            if(thirstPercentTmp < this.PercentIndefiniteShow)
            {
               this.endThirstHideTimeout();
               this.fadeInThirst();
            }
            else if(!GlobalFunc.CloseToNumber(this.fThirstPercent,thirstPercentTmp,this.PercentChangeVal) || thirstPercentTmp > this.fThirstPercent)
            {
               this.endThirstHideTimeout();
               this.fadeInThirst();
               this.ThirstTimeout = setTimeout(this.fadeOutThirst,FADE_DELAY);
            }
            this.fThirstPercent = thirstPercentTmp;
            thirstPercentTmp = GlobalFunc.Clamp(thirstPercentTmp,0,this.PercentMax) / this.PercentMax;
            thirstFrame = Math.ceil(thirstPercentTmp * this.HUDThirstMeter_mc.Meter_mc.totalFrames);
            this.HUDThirstMeter_mc.Meter_mc.gotoAndStop(thirstFrame);
            this.HUDThirstMeter_mc.survivalMeterIcon_mc.gotoAndStop("thirstPositive");
            if(newData.thirst_RestorePct is Number && newData.thirst_RestorePct > 0)
            {
               thirstRestorePercent = GlobalFunc.Clamp(this.fThirstPercent + newData.thirst_RestorePct,0,this.PercentMax) / this.PercentMax;
               thirstRestoreFrame = Math.ceil(thirstRestorePercent * this.HUDThirstMeter_mc.GhostMeter_mc.totalFrames);
               this.HUDThirstMeter_mc.GhostMeter_mc.gotoAndStop(thirstRestoreFrame);
               this.HUDThirstMeter_mc.GhostMeter_mc.visible = true;
            }
            else
            {
               this.HUDThirstMeter_mc.GhostMeter_mc.visible = false;
            }
         }
         else if(this.bShowThirst)
         {
            this.setThirstOff();
         }
         if(this.bFeralVisible)
         {
            this.fadeInFeral();
            this.fFeralPercent = feralPercentTmp;
            feralPercentTmp = GlobalFunc.Clamp(feralPercentTmp,0,this.PercentMax) / this.PercentMax;
            if(feralPercentTmp == 0 && (this.FeralMeter_mc.FeralMeterInternal_mc.currentLabel != "empty" && this.FeralMeter_mc.FeralMeterInternal_mc.currentLabel != "emptyAnim"))
            {
               this.FeralMeter_mc.FeralMeterInternal_mc.gotoAndPlay("emptyAnim");
            }
            else if(feralPercentTmp != 0)
            {
               this.FeralMeter_mc.FeralMeterInternal_mc.gotoAndStop((1 - feralPercentTmp) * 100);
            }
         }
         else if(this.bShowFeral)
         {
            this.setFeralOff();
         }
         if(Boolean(newData.overheatWeaponEquipped) && !newData.currentWeaponSheathed)
         {
            this.OverheatMeter_mc.visible = true;
            this.SetOverheatMeterPercent(newData.overheatPercent);
         }
         else
         {
            this.OverheatMeter_mc.visible = false;
         }
      }
      
      public function fadeInHunger() : void
      {
         if(!this.bShowHunger)
         {
            this.bShowHunger = true;
            this.HUDHungerMeter_mc.gotoAndPlay("rollOn");
            dispatchEvent(new Event("HUD::HungerFadedIn"));
         }
      }
      
      public function fadeOutHunger() : void
      {
         if(this.bShowHunger && !this.bIsPip)
         {
            this.HungerTimeout = -1;
            this.bShowHunger = false;
            this.HUDHungerMeter_mc.gotoAndPlay("rollOff");
            dispatchEvent(new Event("HUD::HungerFadedOut"));
         }
      }
      
      public function setHungerOff() : *
      {
         if(this.bShowHunger && !this.bIsPip)
         {
            this.HungerTimeout = -1;
            this.bShowHunger = false;
            this.HUDHungerMeter_mc.gotoAndStop("off");
         }
      }
      
      private function endHungerHideTimeout() : void
      {
         if(this.HungerTimeout != -1)
         {
            clearTimeout(this.HungerTimeout);
            this.HungerTimeout = -1;
         }
      }
      
      public function fadeInThirst() : void
      {
         if(!this.bShowThirst)
         {
            this.bShowThirst = true;
            this.HUDThirstMeter_mc.gotoAndPlay("rollOn");
            dispatchEvent(new Event("HUD::ThirstFadedIn"));
         }
      }
      
      public function fadeOutThirst() : void
      {
         if(this.bShowThirst && !this.bIsPip)
         {
            this.ThirstTimeout = -1;
            this.bShowThirst = false;
            this.HUDThirstMeter_mc.gotoAndPlay("rollOff");
            dispatchEvent(new Event("HUD::ThirstFadedOut"));
         }
      }
      
      public function setThirstOff() : *
      {
         if(this.bShowThirst && !this.bIsPip)
         {
            this.ThirstTimeout = -1;
            this.bShowThirst = false;
            this.HUDThirstMeter_mc.gotoAndStop("off");
         }
      }
      
      private function endThirstHideTimeout() : void
      {
         if(this.ThirstTimeout != -1)
         {
            clearTimeout(this.ThirstTimeout);
            this.ThirstTimeout = -1;
         }
      }
      
      public function fadeInFeral() : void
      {
         if(!this.bShowFeral)
         {
            this.bShowFeral = true;
            this.FeralMeter_mc.gotoAndPlay("rollOn");
            dispatchEvent(new Event("HUD::FeralFadedIn"));
         }
      }
      
      public function fadeOutFeral() : void
      {
         if(this.bShowFeral && !this.bIsPip)
         {
            this.bShowFeral = false;
            this.FeralMeter_mc.gotoAndPlay("rollOff");
            dispatchEvent(new Event("HUD::FeralFadedOut"));
         }
      }
      
      public function setFeralOff() : *
      {
         if(this.bShowFeral && !this.bIsPip)
         {
            this.bShowFeral = false;
            this.FeralMeter_mc.gotoAndStop("off");
         }
      }
      
      public function SetOverheatMeterPercent(afPercent:Number) : *
      {
         this.OverheatMeter_mc.MeterBar_mc.Percent = afPercent;
      }
      
      public function SetPercentIndefiniteShow(param1:Number) : *
      {
         this.PercentIndefiniteShow = param1;
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}

