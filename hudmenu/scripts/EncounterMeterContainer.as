package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.HUDModes;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class EncounterMeterContainer extends MovieClip
   {
      
      public var EncounterHealthMeter1_mc:EncounterMeter;
      
      public var EncounterHealthMeter2_mc:EncounterMeter;
      
      public var EncounterHealthMeter3_mc:EncounterMeter;
      
      private var m_EncounterMeters:Vector.<EncounterMeter>;
      
      private var m_ValidHudModes:Array;
      
      public function EncounterMeterContainer()
      {
         super();
         this.m_EncounterMeters = new <EncounterMeter>[this.EncounterHealthMeter1_mc,this.EncounterHealthMeter2_mc,this.EncounterHealthMeter3_mc];
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.m_ValidHudModes = new Array(HUDModes.ALL,HUDModes.ACTIVATE_TYPE,HUDModes.IRON_SIGHTS,HUDModes.POWER_ARMOR,HUDModes.DEFAULT_SCOPE_MENU,HUDModes.CAMERA_SCOPE_MENU,HUDModes.VERTIBIRD_MODE,HUDModes.SIT_WAIT_MODE,HUDModes.VATS_MODE);
         BSUIDataManager.Subscribe("HUDModeData",this.onHudModeDataChange);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         BSUIDataManager.Subscribe("EncounterHealthMeterArray",this.onEncounterHealthMeterUpdate);
      }
      
      private function onEncounterHealthMeterUpdate(param1:FromClientDataEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_EncounterMeters.length)
         {
            _loc3_ = param1.data.EncounterHealthMeterArray[_loc2_];
            if(_loc3_.DamageList)
            {
               this.m_EncounterMeters[_loc2_].SetDamageList(_loc3_.DamageList);
            }
            else
            {
               this.m_EncounterMeters[_loc2_].ResetDamageList();
            }
            this.m_EncounterMeters[_loc2_].SetMeterHostile(_loc3_.IsHostile);
            this.m_EncounterMeters[_loc2_].SetMeterPercent(_loc3_.Percent);
            this.m_EncounterMeters[_loc2_].SetMeterName(_loc3_.Name);
            this.m_EncounterMeters[_loc2_].SetEncounter(_loc3_.EncounterIconType,_loc3_.EncounterIconLevel);
            _loc2_++;
         }
      }
      
      private function onHudModeDataChange(param1:FromClientDataEvent) : *
      {
         this.visible = this.m_ValidHudModes.indexOf(param1.data.hudMode) != -1;
      }
   }
}

