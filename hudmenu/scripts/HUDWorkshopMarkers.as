package
{
   import Shared.AS3.BSUIComponent;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import scaleform.gfx.Extensions;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol738")]
   public class HUDWorkshopMarkers extends BSUIComponent
   {
      
      private static const DATA_PROVIDER_KEY:String = "WorkshopMarkers";
      
      private var MarkerMCs:Vector.<WorkshopMarker>;
      
      private var MarkersData:Array;
      
      public function HUDWorkshopMarkers()
      {
         super();
         Extensions.enabled = true;
         this.MarkerMCs = new Vector.<WorkshopMarker>();
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe(DATA_PROVIDER_KEY,this.onMarkersUpdated);
      }
      
      public function onMarkersUpdated(arEvent:FromClientDataEvent) : void
      {
         this.MarkersData = arEvent.data.markersA;
         SetIsDirty();
      }
      
      override public function redrawUIComponent() : void
      {
         var markerMC:WorkshopMarker = null;
         var markerData:Object = null;
         if(this.MarkersData == null)
         {
            return;
         }
         for(var idx:int = 0; idx < this.MarkersData.length; idx++)
         {
            if(idx < this.MarkerMCs.length)
            {
               markerMC = this.MarkerMCs[idx];
            }
            else
            {
               markerMC = new WorkshopMarker();
               addChild(markerMC);
               this.MarkerMCs.push(markerMC);
            }
            markerData = this.MarkersData[idx];
            markerMC.x = markerData.fScreenX;
            markerMC.y = markerData.fScreenY;
            markerMC.Update(markerData.strDisplayName,markerData.strStateName,markerData.fCapturePct,markerData.bIsOffScreen,markerData.bPlayerInContestRadius);
         }
         for(var iMC:int = idx; iMC < this.MarkerMCs.length; iMC++)
         {
            removeChild(this.MarkerMCs[iMC]);
         }
         this.MarkerMCs.length = idx;
      }
   }
}

