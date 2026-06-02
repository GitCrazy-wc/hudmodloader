package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol733")]
   public class PingMarkersContainer extends MovieClip
   {
      
      private static const MAX_PINGS:Number = 20;
      
      private static const PING_TIMER:Number = 3000;
      
      private static const PING_ANIM_FRAMES:Number = 95;
      
      public var PingContainer_mc:MovieClip;
      
      private var Pings:Vector.<PingMarker> = new Vector.<PingMarker>(MAX_PINGS);
      
      private var m_IsPingArrayEmpty:Boolean = true;
      
      private var m_FourthWidth:Number = 0;
      
      private var m_HalfHeight:Number = 0;
      
      public function PingMarkersContainer()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(aEvent:Event) : void
      {
         var iMarker:int = 0;
         BSUIDataManager.Subscribe("pingArray",this.onPingUpdate);
         this.visible = false;
         for(iMarker = 0; iMarker < this.Pings.length; iMarker++)
         {
            this.Pings[iMarker] = new PingMarker();
            this.Pings[iMarker].visible = false;
            addChild(this.Pings[iMarker]);
         }
         this.m_FourthWidth = this.Pings[0].width / 4;
         this.m_HalfHeight = this.Pings[0].height / 2;
      }
      
      private function onPingUpdate(arEvent:FromClientDataEvent) : void
      {
         var validData:Boolean = false;
         var reverseIndex:* = undefined;
         var pingObj:Object = null;
         var pingCount:int = int(arEvent.data.pingArray.length);
         if(this.m_IsPingArrayEmpty && pingCount == 0)
         {
            this.visible = false;
            return;
         }
         this.visible = true;
         var isCurrentArrayEmpty:Boolean = true;
         for(var i:int = 0; i < MAX_PINGS; i++)
         {
            validData = false;
            if(i < pingCount)
            {
               reverseIndex = pingCount - i - 1;
               pingObj = arEvent.data.pingArray[i];
               if(pingObj.age < PING_TIMER)
               {
                  this.Pings[reverseIndex].SetData(pingObj);
                  this.Pings[reverseIndex].x = pingObj.positionX - this.m_FourthWidth;
                  this.Pings[reverseIndex].y = pingObj.positionY - this.m_HalfHeight;
                  this.Pings[reverseIndex].Redraw();
                  if(!this.Pings[reverseIndex].visible)
                  {
                     this.Pings[reverseIndex].visible = true;
                  }
                  this.Pings[reverseIndex].GoToAnimationFrame(this.Map(pingObj.age,0,PING_TIMER,0,PING_ANIM_FRAMES));
                  isCurrentArrayEmpty = false;
                  if(pingObj.isPingStart)
                  {
                     GlobalFunc.PlayMenuSound("UIPingActivate");
                  }
                  validData = true;
               }
            }
            if(!validData)
            {
               this.Pings[i].x = 0;
               this.Pings[i].y = 0;
               this.Pings[i].ClearData();
               this.Pings[i].Redraw();
               this.Pings[i].visible = false;
            }
         }
         this.m_IsPingArrayEmpty = isCurrentArrayEmpty;
      }
      
      private function Map(inValue:int, minInRange:int, maxInRange:int, minOutRange:int, maxOutRange:*) : int
      {
         return int(minOutRange + (maxOutRange - minOutRange) / (maxInRange - minInRange) * (inValue - minInRange));
      }
   }
}

