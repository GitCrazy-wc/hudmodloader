package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.HUDModes;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol739")]
   public class HUDFloatingTargetManager extends MovieClip
   {
      
      private static const AimInnerDistanceThreshold:Number = 20;
      
      private var m_Targets:Array;
      
      private var m_ValidHudModes:Array;
      
      private var m_AimOuterDistanceThreshold:Number = 100;
      
      public function HUDFloatingTargetManager()
      {
         super();
         this.m_Targets = new Array();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(e:Event) : *
      {
         this.m_ValidHudModes = new Array(HUDModes.ALL,HUDModes.ACTIVATE_TYPE,HUDModes.SIT_WAIT_MODE,HUDModes.VERTIBIRD_MODE,HUDModes.POWER_ARMOR,HUDModes.IRON_SIGHTS,HUDModes.DEFAULT_SCOPE_MENU,HUDModes.INSIDE_MEMORY,HUDModes.CAMP_PLACEMENT,HUDModes.CROSSHAIR_AND_ACTIVATE_ONLY);
         BSUIDataManager.Subscribe("MapMenuDataChanges",this.onFloatingTargetChange);
         BSUIDataManager.Subscribe("HotMapMarkerData",this.onHotMapMenuData);
         BSUIDataManager.Subscribe("HotReconMarkerData",this.onReconMarkerHotData);
         BSUIDataManager.Subscribe("HUDModeData",this.onHudModeDataChange);
         BSUIDataManager.Subscribe("ReconMarkerData",this.onReconMarkerData);
      }
      
      private function onHudModeDataChange(event:FromClientDataEvent) : *
      {
         this.visible = event.data.showFloatingMarkers == true && this.m_ValidHudModes.indexOf(event.data.hudMode) != -1;
      }
      
      private function onHotMapMenuData(arEvent:FromClientDataEvent) : *
      {
         var matchIdx:uint = 0;
         var markerDataArray:Array = BSUIDataManager.GetDataFromClient("MapMenuData").data.MarkerData;
         var markerChanges:Array = arEvent.data.updates;
         for(var i:uint = 0; i < markerChanges.length; i++)
         {
            matchIdx = this.getTargetByID(this.m_Targets,markerChanges[i].markerID);
            if(matchIdx != uint.MAX_VALUE)
            {
               this.updateTargetHot(this.m_Targets[matchIdx],markerChanges[i]);
            }
         }
      }
      
      private function onFloatingTargetChange(arEvent:FromClientDataEvent) : *
      {
         var changeIndex:* = undefined;
         var changeType:* = undefined;
         var changeMarkerID:* = undefined;
         var removeIdx:uint = 0;
         var targetData:* = undefined;
         var targetID:* = undefined;
         var matchIdx:uint = 0;
         var markerDataArray:Array = BSUIDataManager.GetDataFromClient("MapMenuData").data.MarkerData;
         var markerChanges:Array = arEvent.data.MarkerChanges;
         for(var i:uint = 0; i < markerChanges.length; i++)
         {
            changeIndex = markerChanges[i].index;
            changeType = markerChanges[i].type;
            changeMarkerID = markerChanges[i].markerID;
            if(changeType == "RemoveMarker")
            {
               removeIdx = this.getTargetByID(this.m_Targets,changeMarkerID);
               if(removeIdx != uint.MAX_VALUE)
               {
                  removeChild(this.m_Targets[removeIdx]);
                  this.m_Targets.splice(removeIdx,1);
               }
               continue;
            }
            if(changeIndex >= markerDataArray.length)
            {
               continue;
            }
            targetData = markerDataArray[changeIndex];
            if(targetData.markerType != "ActiveQuest" && targetData.markerType != "InactiveQuest" && targetData.markerType != "SharedQuest" && targetData.markerType != "MainActiveQuest")
            {
               continue;
            }
            targetID = targetData.markerID;
            matchIdx = this.getTargetByID(this.m_Targets,targetID);
            switch(changeType)
            {
               case "AddMarker":
                  if(matchIdx != uint.MAX_VALUE)
                  {
                     this.updateTarget(this.m_Targets[matchIdx],targetData);
                  }
                  else
                  {
                     this.addTarget(targetData);
                  }
                  break;
               case "UpdateMarker":
               case "UpdateScreenCoords":
                  if(matchIdx != uint.MAX_VALUE)
                  {
                     this.updateTarget(this.m_Targets[matchIdx],targetData);
                  }
                  else
                  {
                     this.addTarget(targetData);
                  }
                  break;
            }
         }
      }
      
      private function IsReconMarker(aTarget:HUDFloatingTarget) : Boolean
      {
         return aTarget.markerType == "Recon" || aTarget.markerType == "EnemyTargeted";
      }
      
      private function onReconMarkerData(arEvent:FromClientDataEvent) : *
      {
         var removed:Boolean = false;
         var reconIdx:uint = 0;
         var matchIdx:uint = 0;
         var reconArray:Array = arEvent.data.reconMarkers;
         var removeMarkers:Array = new Array();
         var i:uint = 0;
         while(i < this.m_Targets.length)
         {
            removed = false;
            if(this.IsReconMarker(this.m_Targets[i]))
            {
               reconIdx = this.getTargetByID(reconArray,this.m_Targets[i].markerID);
               if(reconIdx == uint.MAX_VALUE)
               {
                  removeChild(this.m_Targets[i]);
                  this.m_Targets.splice(i,1);
                  removed = true;
               }
            }
            if(!removed)
            {
               i++;
            }
         }
         for(i = 0; i < reconArray.length; i++)
         {
            matchIdx = this.getTargetByID(this.m_Targets,reconArray[i].markerID);
            if(matchIdx != uint.MAX_VALUE)
            {
               if(this.IsReconMarker(this.m_Targets[matchIdx]))
               {
                  this.updateTarget(this.m_Targets[matchIdx],reconArray[i]);
               }
            }
            else
            {
               this.addTarget(reconArray[i]);
            }
         }
      }
      
      private function onReconMarkerHotData(arEvent:FromClientDataEvent) : *
      {
         var reconIdx:uint = 0;
         var hotDataFound:* = false;
         var reconHotArray:Array = arEvent.data.updates;
         for(var i:* = 0; i < this.m_Targets.length; i++)
         {
            if(this.IsReconMarker(this.m_Targets[i]))
            {
               reconIdx = this.getTargetByID(reconHotArray,this.m_Targets[i].markerID);
               hotDataFound = reconIdx != uint.MAX_VALUE;
               this.m_Targets[i].visible = hotDataFound;
               this.m_Targets[i].isOnScreen = hotDataFound;
               if(hotDataFound)
               {
                  this.updateTargetHot(this.m_Targets[i],reconHotArray[reconIdx]);
               }
            }
         }
      }
      
      private function getTargetByID(aData:Array, aMarkerID:uint) : uint
      {
         var foundMember:Boolean = false;
         var returnIdx:uint = uint.MAX_VALUE;
         var i:uint = 0;
         while(!foundMember && i < aData.length)
         {
            if(aData[i].markerID == aMarkerID)
            {
               returnIdx = i;
               foundMember = true;
            }
            i++;
         }
         return returnIdx;
      }
      
      private function updateTargetHot(aTarget:HUDFloatingTarget, aTargetData:Object) : *
      {
         aTarget.distanceFromPlayer = aTargetData.distanceFromPlayer;
         aTarget.visible = true;
         aTarget.markerID = aTargetData.markerID;
         aTarget.x = aTargetData.screenX;
         aTarget.y = aTargetData.screenY;
         aTarget.showLabel = aTargetData.showLabel;
         aTarget.midDistance = aTargetData.midDistance;
         aTarget.forceShow = aTargetData.midDistance;
      }
      
      private function updateTarget(aTarget:HUDFloatingTarget, aTargetData:Object) : *
      {
         aTarget.distanceFromPlayer = aTargetData.distanceFromPlayer;
         aTarget.isOnScreen = false;
         aTarget.visible = false;
         aTarget.markerID = aTargetData.markerID;
         aTarget.markerType = aTargetData.markerType;
         aTarget.isAI = aTargetData.isAI;
         aTarget.label = aTargetData.text;
         aTarget.showMeter = aTargetData.showMeter;
         aTarget.meterValue = aTargetData.meterValue;
         aTarget.alertState = aTargetData.announceState;
         aTarget.alertMessage = aTargetData.announce;
         aTarget.questDisplayType = aTargetData.questDisplayType;
      }
      
      private function addTarget(aTargetData:Object) : HUDFloatingTarget
      {
         var newTarget:HUDFloatingTarget = new HUDFloatingTarget();
         addChild(newTarget);
         this.m_Targets.push(newTarget);
         this.updateTarget(newTarget,aTargetData);
         return newTarget;
      }
   }
}

