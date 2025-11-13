package HUDMenu_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3")]
   public dynamic class tick_805 extends MovieClip
   {
      
      public function tick_805()
      {
         super();
         addFrameScript(0,this.frame1,41,this.frame42);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame42() : *
      {
         gotoAndPlay("TickPulse");
      }
   }
}

