package HUDMenu_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2063")]
   public dynamic class LevelUpAnimation_443 extends MovieClip
   {
      
      public var LevelUpText:MovieClip;
      
      public function LevelUpAnimation_443()
      {
         super();
         addFrameScript(0,this.frame1,19,this.frame20);
      }
      
      internal function frame1() : *
      {
         dispatchEvent(new Event("HUD::LevelUpHidden",true));
         stop();
      }
      
      internal function frame20() : *
      {
         dispatchEvent(new Event("HUD::LevelUpVisible",true));
      }
   }
}

