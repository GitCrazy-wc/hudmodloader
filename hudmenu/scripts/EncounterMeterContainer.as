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
      
      private function onAddedToStage(aEvent:Event) : void
      {
         BSUIDataManager.Subscribe("EncounterHealthMeterArray",this.onEncounterHealthMeterUpdate);
      }
      
      private function onEncounterHealthMeterUpdate(arEvent:FromClientDataEvent) : void
      {
         var aData:Object = null;
         for(var i:int = 0; i < this.m_EncounterMeters.length; i++)
         {
            aData = arEvent.data.EncounterHealthMeterArray[i];
            if(aData.DamageList)
            {
               this.m_EncounterMeters[i].SetDamageList(aData.DamageList);
            }
            else
            {
               this.m_EncounterMeters[i].ResetDamageList();
            }
            this.m_EncounterMeters[i].SetMeterHostile(aData.IsHostile);
            this.m_EncounterMeters[i].SetMeterPercent(aData.Percent);
            this.m_EncounterMeters[i].SetMeterName(aData.Name);
            this.m_EncounterMeters[i].SetEncounter(aData.EncounterIconType,aData.EncounterIconLevel);
         }
      }
      
      private function onHudModeDataChange(event:FromClientDataEvent) : *
      {
         this.visible = this.m_ValidHudModes.indexOf(event.data.hudMode) != -1;
      }
   }
}

