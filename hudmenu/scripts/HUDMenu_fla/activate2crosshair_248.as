package HUDMenu_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1360")]
   public dynamic class activate2crosshair_248 extends MovieClip
   {
      
      public var Down:MovieClip;
      
      public var Left:MovieClip;
      
      public var Right:MovieClip;
      
      public var Up:MovieClip;
      
      public function activate2crosshair_248()
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

