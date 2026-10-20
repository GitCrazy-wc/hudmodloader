package
{
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   
   public class HUDObjectiveIcon extends MovieClip
   {
      
      public static const DEFAULT_ICON_COLOR:uint = 16777163;
      
      public var Icon_mc:MovieClip;
      
      private var m_CharIndex:int = 0;
      
      private var m_ColorTransform:ColorTransform;
      
      public function HUDObjectiveIcon()
      {
         super();
         this.m_ColorTransform = new ColorTransform();
         this.m_ColorTransform.color = DEFAULT_ICON_COLOR;
         this.Icon_mc.transform.colorTransform = this.m_ColorTransform;
      }
      
      public function get charIndex() : int
      {
         return this.m_CharIndex;
      }
      
      public function setData(aIconString:String, aIndex:int) : void
      {
         this.Icon_mc.gotoAndStop(aIconString);
         this.m_CharIndex = aIndex;
      }
      
      public function setColor(aColor:uint) : void
      {
         if(this.m_ColorTransform.color != aColor)
         {
            this.m_ColorTransform.color = aColor;
            this.Icon_mc.transform.colorTransform = this.m_ColorTransform;
         }
      }
   }
}

