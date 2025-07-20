package
{
   import flash.events.Event;
   
   public class HUDModError extends Event
   {
      
      public static const EVENT:String = "HUDMod::Error";
      
      private var savedText:String;
      
      public function HUDModError(text:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(HUDModError.EVENT,bubbles,cancelable);
         savedText = text;
      }
      
      override public function toString() : String
      {
         return savedText;
      }
   }
}

