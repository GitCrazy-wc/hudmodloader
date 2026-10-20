package HUDMenu_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1538")]
   public dynamic class dot2activate_240 extends MovieClip
   {
      
      public function dot2activate_240()
      {
         super();
         addFrameScript(0,this.frame1,7,this.frame8);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame8() : *
      {
         dispatchEvent(new Event("animationComplete"));
      }
   }
}

