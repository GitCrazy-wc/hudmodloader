package HUDMenu_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1018")]
   public dynamic class stealthTextStates_mc_290 extends MovieClip
   {
      
      public var stealthTextAnimStates:MovieClip;
      
      public function stealthTextStates_mc_290()
      {
         super();
         addFrameScript(5,this.frame6,11,this.frame12,72,this.frame73,103,this.frame104);
      }
      
      internal function frame6() : *
      {
         stop();
      }
      
      internal function frame12() : *
      {
         stop();
      }
      
      internal function frame73() : *
      {
         gotoAndPlay("caution");
      }
      
      internal function frame104() : *
      {
         gotoAndPlay("danger");
      }
   }
}

