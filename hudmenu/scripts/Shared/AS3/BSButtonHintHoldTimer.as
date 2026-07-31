package Shared.AS3
{
   public class BSButtonHintHoldTimer
   {
      
      private static const DEFAULT_HOLD_TIME:Number = 250;
      
      private var m_StartTime:Number;
      
      private var m_HoldTime:Number;
      
      public function BSButtonHintHoldTimer(aHoldTime:Number = 250, aStartTime:Number = -1)
      {
         super();
         if(aStartTime < 0)
         {
            aStartTime = Number(new Date().getTime());
         }
         this.startTime = aStartTime;
         this.holdTime = aHoldTime;
      }
      
      public function get startTime() : Number
      {
         return this.m_StartTime;
      }
      
      public function set startTime(aStartTime:Number) : void
      {
         this.m_StartTime = aStartTime;
      }
      
      public function get holdTime() : Number
      {
         return this.m_HoldTime;
      }
      
      public function set holdTime(aHoldTime:Number) : void
      {
         this.m_HoldTime = aHoldTime;
      }
      
      public function get percentComplete() : Number
      {
         var currTime:Number = Number(new Date().getTime());
         var percentComplete:* = (currTime - this.startTime) / this.holdTime;
         return percentComplete > 1 ? 1 : percentComplete;
      }
      
      public function get timeElapsed() : Number
      {
         var currTime:Number = Number(new Date().getTime());
         return currTime - this.startTime;
      }
      
      public function resetTimer() : *
      {
         this.startTime = new Date().getTime();
      }
   }
}

