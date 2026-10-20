package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.HUDModes;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1986")]
   public class PetMarkersManager extends BSDisplayObject
   {
      
      public var PetNameplates:Vector.<PetNameplate> = new Vector.<PetNameplate>();
      
      public var UnusedPetNameplates:Vector.<PetNameplate> = new Vector.<PetNameplate>();
      
      private var m_HideMarkers:Boolean = false;
      
      private var m_ValidHudModes:Array;
      
      public function PetMarkersManager()
      {
         super();
      }
      
      public function set hideMarkers(aVal:Boolean) : void
      {
         this.m_HideMarkers = aVal;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.m_ValidHudModes = new Array(HUDModes.ALL,HUDModes.ACTIVATE_TYPE,HUDModes.SIT_WAIT_MODE,HUDModes.VERTIBIRD_MODE,HUDModes.POWER_ARMOR,HUDModes.IRON_SIGHTS,HUDModes.DEFAULT_SCOPE_MENU,HUDModes.INSIDE_MEMORY,HUDModes.CAMP_PLACEMENT,HUDModes.CROSSHAIR_AND_ACTIVATE_ONLY);
         BSUIDataManager.Subscribe("HUDModeData",this.onHudModeDataChange);
         BSUIDataManager.Subscribe("PetMarkers",this.onPetMarkersUpdate);
      }
      
      private function onHudModeDataChange(event:FromClientDataEvent) : *
      {
         this.visible = event.data.showFloatingMarkers == true && this.m_ValidHudModes.indexOf(event.data.hudMode) != -1;
      }
      
      private function UpdatePet(namePlate:PetNameplate, marker:Object) : void
      {
         namePlate.displayName = marker.displayName;
         namePlate.entityID = marker.entityID;
         namePlate.isWounded = marker.isWounded;
         namePlate.showPetNameplate = marker.showPetNameplate;
         if(marker.level != null)
         {
            namePlate.level = marker.level;
         }
      }
      
      private function onPetMarkersUpdate(event:FromClientDataEvent) : void
      {
         var petMarkerData:Array = null;
         var marker:Object = null;
         var numNameplates:int = 0;
         var iNameplate:int = 0;
         var item:PetNameplate = null;
         var newNamePlate:PetNameplate = null;
         var plate:PetNameplate = null;
         var found:Boolean = false;
         var markerIndex:int = 0;
         petMarkerData = event.data.Markers;
         var markerCount:int = int(petMarkerData.length);
         for(var iMarker:int = 0; iMarker < markerCount; iMarker++)
         {
            marker = petMarkerData[iMarker];
            numNameplates = int(this.PetNameplates.length);
            for(iNameplate = 0; iNameplate < numNameplates; )
            {
               item = this.PetNameplates[iNameplate];
               if(item.entityID == marker.entityID)
               {
                  if(marker.isMarkerDirty)
                  {
                     this.UpdatePet(item,marker);
                  }
                  break;
               }
               iNameplate++;
            }
            if(iNameplate == numNameplates)
            {
               if(this.UnusedPetNameplates.length == 0)
               {
                  newNamePlate = new PetNameplate();
                  addChild(newNamePlate);
               }
               else
               {
                  newNamePlate = this.UnusedPetNameplates.shift();
               }
               newNamePlate.visible = !this.m_HideMarkers;
               this.UpdatePet(newNamePlate,marker);
               this.PetNameplates.push(newNamePlate);
            }
         }
         var plateCount:int = int(this.PetNameplates.length);
         for(iNameplate = plateCount - 1; iNameplate >= 0; iNameplate--)
         {
            plate = this.PetNameplates[iNameplate];
            found = false;
            markerIndex = 0;
            while(!found && markerIndex < markerCount)
            {
               if(petMarkerData[markerIndex].entityID == plate.entityID)
               {
                  found = true;
                  plate.visible = !this.m_HideMarkers;
               }
               markerIndex++;
            }
            if(!found)
            {
               this.UnusedPetNameplates.push(this.PetNameplates.splice(iNameplate,1)[0]);
               this.UnusedPetNameplates[this.UnusedPetNameplates.length - 1].visible = false;
            }
         }
      }
   }
}

