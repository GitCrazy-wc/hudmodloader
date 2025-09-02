package
{
   import Shared.AS3.BSUIComponent;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1625")]
   public dynamic class HUDCompassWidget extends BSUIComponent
   {
      
      public var CompassBar_mc:MovieClip;
      
      public var QuestMask_mc:MovieClip;
      
      public var QuestMarkerHolder_mc:MovieClip;
      
      public var OtherMask_mc:MovieClip;
      
      public var OtherMarkerHolder_mc:MovieClip;
      
      public var CompassBGHolder_mc:MovieClip;
      
      public var AreaQuest_WithinClip_mc:MovieClip;
      
      public var AreaQuest_WithinClipPA_mc:MovieClip;
      
      public var WithinClipVisibility:Boolean = false;
      
      private var m_IsPowerArmor:Boolean = false;
      
      public function HUDCompassWidget()
      {
         super();
         this.AreaQuest_WithinClipPA_mc.visible = false;
         BSUIDataManager.Subscribe("CompassData",this.onDataChanged);
      }
      
      public function set isPowerArmor(param1:Boolean) : *
      {
         this.m_IsPowerArmor = param1;
         this.AreaQuest_WithinClip_mc.visible = !this.m_IsPowerArmor;
         this.AreaQuest_WithinClipPA_mc.visible = this.m_IsPowerArmor;
         if(this.m_IsPowerArmor)
         {
            this.QuestMarkerHolder_mc.scaleX = 1;
            this.OtherMarkerHolder_mc.scaleX = 1;
            this.QuestMarkerHolder_mc.x = -this.QuestMarkerHolder_mc.width * 1.5 + 100;
            this.OtherMarkerHolder_mc.x = -this.OtherMarkerHolder_mc.width * 1.5 + 100;
         }
      }
      
      private function onDataChanged(param1:FromClientDataEvent) : *
      {
         if(param1.fromClient.data.withinAreaMarker)
         {
            if(!this.WithinClipVisibility)
            {
               if(this.m_IsPowerArmor)
               {
                  this.AreaQuest_WithinClipPA_mc.gotoAndPlay("rollOn");
               }
               else
               {
                  this.AreaQuest_WithinClip_mc.gotoAndPlay("rollOn");
               }
            }
            this.WithinClipVisibility = true;
         }
         else
         {
            if(this.WithinClipVisibility)
            {
               if(this.m_IsPowerArmor)
               {
                  this.AreaQuest_WithinClipPA_mc.gotoAndPlay("rollOut");
               }
               else
               {
                  this.AreaQuest_WithinClip_mc.gotoAndPlay("rollOut");
               }
            }
            this.WithinClipVisibility = false;
         }
         BSUIDataManager.Subscribe("CompassData",this.onDataChanged);
      }
      
      public function IsValidCompassMarker(param1:String) : Boolean
      {
         var clipClass:Class = null;
         var aMarkerType:String = param1;
         try
         {
            clipClass = getDefinitionByName(aMarkerType) as Class;
         }
         catch(error:ReferenceError)
         {
            trace("Can\'t find compass marker type " + aMarkerType);
            return false;
         }
         return true;
      }
   }
}

