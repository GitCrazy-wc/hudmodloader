package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class HUDQuestTrackerObjectiveTitle extends MovieClip
   {
      
      private static const ICON_SPACE:String = "      ";
      
      private static const DEFAULT_ICON_HEIGHT:Number = 33;
      
      public var TitleText_tf:TextField;
      
      public var Sizer_mc:MovieClip;
      
      private var m_ObjectiveIconsV:Vector.<HUDObjectiveIcon>;
      
      private var m_ParsedText:String = "";
      
      private var m_PrefixOffset:Number = 0;
      
      public function HUDQuestTrackerObjectiveTitle()
      {
         super();
         this.m_ObjectiveIconsV = new Vector.<HUDObjectiveIcon>();
         TextFieldEx.setTextAutoSize(this.TitleText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function ShowTitleText(aPrefix:String, aSuffix:String) : *
      {
         this.m_PrefixOffset = aPrefix.length;
         this.TitleText_tf.text = aPrefix + this.m_ParsedText + aSuffix;
         if(this.TitleText_tf.length > 0 && this.m_ObjectiveIconsV.length > 0)
         {
            addEventListener(Event.EXIT_FRAME,this.onExitFrame);
         }
         else
         {
            removeEventListener(Event.EXIT_FRAME,this.onExitFrame);
         }
      }
      
      private function parseTitleText(aText:String) : *
      {
         var iconTagString:String = null;
         var newIcon:HUDObjectiveIcon = null;
         var tagRegEx:RegExp = /{#[^{#}]+}/g;
         var localizedText:* = GlobalFunc.LocalizeFormattedString(aText);
         var iconsCount:int = 0;
         var resultObj:Object = tagRegEx.exec(localizedText);
         while(Boolean(resultObj) && resultObj.index != -1)
         {
            iconTagString = resultObj[0].replace("{#","").replace("}","").toUpperCase();
            iconsCount++;
            if(iconsCount > this.m_ObjectiveIconsV.length)
            {
               newIcon = new HUDObjectiveIcon();
               newIcon.setData(iconTagString,resultObj.index);
               newIcon.setColor(this.TitleText_tf.textColor);
               this.m_ObjectiveIconsV.push(newIcon);
               addChild(newIcon);
            }
            else
            {
               this.m_ObjectiveIconsV[iconsCount - 1].setData(iconTagString,resultObj.index);
               this.m_ObjectiveIconsV[iconsCount - 1].setColor(this.TitleText_tf.textColor);
            }
            localizedText = localizedText.replace(resultObj[0],ICON_SPACE);
            resultObj = tagRegEx.exec(localizedText);
         }
         if(iconsCount > 0 && localizedText.charAt(localizedText.length - 1) == " ")
         {
            localizedText += "​";
         }
         while(iconsCount < this.m_ObjectiveIconsV.length)
         {
            removeChild(this.m_ObjectiveIconsV.pop());
         }
         this.m_ParsedText = localizedText;
      }
      
      public function setTitleData(aText:String, abShowImmediately:Boolean = true) : void
      {
         this.parseTitleText(aText);
         if(abShowImmediately)
         {
            this.ShowTitleText("","");
         }
      }
      
      private function onExitFrame(aEvent:Event) : void
      {
         var icon:HUDObjectiveIcon = null;
         var charBounds:Rectangle = null;
         var iconScaling:Number = NaN;
         if(visible && this.TitleText_tf.length > 0 && this.m_ObjectiveIconsV.length > 0)
         {
            for each(icon in this.m_ObjectiveIconsV)
            {
               charBounds = this.TitleText_tf.getCharBoundaries(icon.charIndex + this.m_PrefixOffset);
               icon.x = charBounds.x + this.TitleText_tf.x;
               icon.y = charBounds.y;
               iconScaling = this.TitleText_tf.textHeight / this.TitleText_tf.numLines / DEFAULT_ICON_HEIGHT;
               icon.scaleX = iconScaling;
               icon.scaleY = iconScaling;
            }
         }
         removeEventListener(Event.EXIT_FRAME,this.onExitFrame);
      }
   }
}

