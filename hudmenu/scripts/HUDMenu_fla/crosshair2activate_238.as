package HUDMenu_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1350")]
   public dynamic class crosshair2activate_238 extends MovieClip
   {
      
      public var Down:MovieClip;
      
      public var Left:MovieClip;
      
      public var Right:MovieClip;
      
      public var Up:MovieClip;
      
      public function crosshair2activate_238()
      {
         super();
         addFrameScript(0,this.frame1,11,this.frame12);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame12() : *
      {
         dispatchEvent(new Event("animationComplete"));
      }
   }
}

