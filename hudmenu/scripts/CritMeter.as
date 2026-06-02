package
{
   import Shared.AS3.BSUIComponent;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1589")]
   public class CritMeter extends BSUIComponent
   {
      
      public var MeterBar_mc:MovieClip;
      
      public var DisplayText_mc:MovieClip;
      
      public var CritMeterStars_mc:MovieClip;
      
      public function CritMeter()
      {
         super();
         addFrameScript(0,this.frame1,15,this.frame16);
      }
      
      public function SetMeterPercent(afPercent:Number) : *
      {
         this.MeterBar_mc.Percent = afPercent / 100;
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame16() : *
      {
         gotoAndPlay("Flashing");
      }
   }
}

