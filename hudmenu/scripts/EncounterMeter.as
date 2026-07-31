package
{
   import Shared.AS3.BSUIComponent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class EncounterMeter extends BSUIComponent
   {
      
      private static const ICON_OFFSET:* = 16;
      
      private static const TEXT_BUFFER:* = 32;
      
      public var MeterBar_mc:MeterBarWidget;
      
      public var MeterBarNonhostile_mc:MeterBarWidget;
      
      public var MeterFrame_mc:MovieClip;
      
      public var DisplayText_mc:MovieClip;
      
      public var DoTIconsManager_mc:DoTIconsManager;
      
      public var EncounterHolder_mc:EncounterHolder;
      
      public var HuntedTargetIcon_mc:MovieClip;
      
      private var m_EncounterIconType:uint = 0;
      
      private var m_EncounterIconLevel:uint = 0;
      
      private var m_DoTDamage:Boolean = false;
      
      private var m_Hostile:Boolean = true;
      
      private var m_ActiveMeter:MeterBarWidget;
      
      private var m_MaxNameWidth:uint = 0;
      
      public function EncounterMeter()
      {
         super();
         Extensions.enabled = true;
         this.DoTIconsManager_mc.alignment = DoTIconsManager.ALIGNMENT_RIGHT;
         visible = false;
         this.m_ActiveMeter = this.MeterBar_mc;
         this.m_MaxNameWidth = this.MeterFrame_mc.width - this.EncounterHolder_mc.width;
         if(this.DisplayText_mc)
         {
            this.DisplayText_mc.DisplayText_tf.width = this.m_MaxNameWidth;
         }
         if(this.EncounterHolder_mc)
         {
            this.EncounterHolder_mc.visible = false;
         }
      }
      
      public function SetMeterPercent(afPercent:Number) : *
      {
         if(afPercent >= 0)
         {
            this.m_ActiveMeter.Percent = afPercent;
            visible = true;
         }
         else
         {
            this.m_ActiveMeter.Percent = -1;
            visible = false;
         }
      }
      
      public function SetMeterName(asName:String) : *
      {
         var globalPos:Point = null;
         var halfTextWidth:Number = NaN;
         var nameUppercase:String = asName.toUpperCase();
         if(Boolean(this.DisplayText_mc) && this.DisplayText_mc.DisplayText_tf.text != nameUppercase)
         {
            this.DisplayText_mc.gotoAndStop("OneLine");
            this.DisplayText_mc.DisplayText_tf.width = this.m_MaxNameWidth;
            this.DisplayText_mc.DisplayText_tf.text = nameUppercase;
            TextFieldEx.setTextAutoSize(this.DisplayText_mc.DisplayText_tf,TextFieldEx.TEXTAUTOSZ_NONE);
            if(this.DisplayText_mc.DisplayText_tf.textWidth > this.m_MaxNameWidth)
            {
               halfTextWidth = Math.ceil(this.DisplayText_mc.DisplayText_tf.textWidth / 2) + TEXT_BUFFER;
               this.DisplayText_mc.gotoAndStop("MultiLine");
               if(halfTextWidth < this.m_MaxNameWidth)
               {
                  this.DisplayText_mc.DisplayText_tf.width = halfTextWidth;
               }
               else
               {
                  this.DisplayText_mc.DisplayText_tf.width = this.m_MaxNameWidth;
               }
               TextFieldEx.setTextAutoSize(this.DisplayText_mc.DisplayText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            }
            this.DisplayText_mc.DisplayText_tf.text = nameUppercase;
            globalPos = this.localToGlobal(new Point(this.MeterFrame_mc.x + this.MeterFrame_mc.width / 2,0));
            this.DisplayText_mc.DisplayText_tf.x = this.DisplayText_mc.globalToLocal(globalPos).x - this.DisplayText_mc.DisplayText_tf.width / 2;
         }
      }
      
      public function ResetDamageList() : void
      {
         if(this.m_DoTDamage)
         {
            if(Boolean(this.DoTIconsManager_mc) && this.DoTIconsManager_mc.isActive())
            {
               this.DoTIconsManager_mc.reset();
            }
         }
      }
      
      public function SetDamageList(aDamageList:Array) : void
      {
         if(this.DoTIconsManager_mc)
         {
            this.DoTIconsManager_mc.populateIcons(aDamageList);
         }
      }
      
      public function SetEncounter(aType:uint, aLevel:uint) : void
      {
         if(this.m_EncounterIconType != aType || this.m_EncounterIconLevel != aLevel)
         {
            this.m_EncounterIconType = aType;
            this.m_EncounterIconLevel = aLevel;
            if(this.EncounterHolder_mc)
            {
               if(this.m_EncounterIconLevel > 0 && this.m_EncounterIconType > EncounterHolder.ENCOUNTER_TYPE_NONE)
               {
                  this.EncounterHolder_mc.visible = true;
                  this.EncounterHolder_mc.SetIcon(this.m_EncounterIconType,this.m_EncounterIconLevel,false);
                  addEventListener(Event.ENTER_FRAME,this.onSetIconPosition);
               }
               else
               {
                  this.EncounterHolder_mc.visible = false;
               }
            }
         }
      }
      
      private function onSetIconPosition() : *
      {
         var textWidthDiff:Number = (this.DisplayText_mc.DisplayText_tf.width - this.DisplayText_mc.DisplayText_tf.textWidth) / 2;
         var globalPos:Point = this.DisplayText_mc.localToGlobal(new Point(this.DisplayText_mc.DisplayText_tf.x + textWidthDiff,0));
         this.EncounterHolder_mc.x = this.globalToLocal(globalPos).x - ICON_OFFSET - this.EncounterHolder_mc.width * 0.5;
         removeEventListener(Event.ENTER_FRAME,this.onSetIconPosition);
      }
      
      public function SetMeterHostile(abHostile:Boolean) : *
      {
         if(abHostile != this.m_Hostile)
         {
            this.m_Hostile = abHostile;
            gotoAndStop(abHostile ? "Hostile" : "Nonhostile");
            this.m_ActiveMeter = this.m_Hostile ? this.MeterBar_mc : this.MeterBarNonhostile_mc;
         }
      }
   }
}

