package Shared.AS3
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.setTimeout;
   
   public class BSAsync extends EventDispatcher
   {
      
      public static const AWAIT_NEXT_FRAME:int = 0;
      
      public static const AWAIT_FRAME_LABEL:int = 1;
      
      public static const AWAIT_MILLISECONDS:int = 2;
      
      public function BSAsync()
      {
         super();
      }
      
      public static function Await(aFuture:MovieClip, aType:int, aClosure:Function, ... rest) : void
      {
         var nextFrameClosure:Function = null;
         var frameLabelClosure:Function = null;
         switch(aType)
         {
            case AWAIT_NEXT_FRAME:
               nextFrameClosure = function():*
               {
                  aFuture.removeEventListener(Event.ENTER_FRAME,nextFrameClosure);
                  aClosure();
               };
               aFuture.addEventListener(Event.ENTER_FRAME,nextFrameClosure);
               break;
            case AWAIT_FRAME_LABEL:
               frameLabelClosure = function():*
               {
                  if(aFuture.currentFrameLabel == rest[0])
                  {
                     aFuture.removeEventListener(Event.FRAME_CONSTRUCTED,frameLabelClosure);
                     aClosure();
                  }
               };
               aFuture.addEventListener(Event.FRAME_CONSTRUCTED,frameLabelClosure);
               break;
            case AWAIT_MILLISECONDS:
               setTimeout(aClosure,rest[0]);
               break;
            default:
               aClosure();
         }
      }
   }
}

