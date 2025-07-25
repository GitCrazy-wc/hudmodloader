package
{
   import flash.events.Event;
   
   public class HUDModUserEvent extends Event
   {
      
      public static const EVENT:String = "HUDMod::UserEvent";
      
      private var eventName:String;
      
      private var isKeyDown:Boolean;
      
      public function HUDModUserEvent(_eventName:String, _isKeyDown:Boolean, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(HUDModUserEvent.EVENT,bubbles,cancelable);
         eventName = _eventName;
         isKeyDown = _isKeyDown;
      }
      
      public function get EventName() : String
      {
         return eventName;
      }
      
      public function get IsKeyDown() : Boolean
      {
         return isKeyDown;
      }
   }
}

