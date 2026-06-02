package
{
   import Shared.EnumHelper;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1038")]
   public class EncounterHolder extends MovieClip
   {
      
      public static const ENCOUNTER_TYPE_NONE:uint = EnumHelper.GetEnum(0);
      
      public static const ENCOUNTER_TYPE_SKULL:uint = EnumHelper.GetEnum();
      
      public static const ENCOUNTER_TYPE_TARGET:uint = EnumHelper.GetEnum();
      
      public var Encounter_mc:MovieClip;
      
      public function EncounterHolder()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      public function SetIcon(aType:uint, aLevel:uint, aIsBoss:Boolean) : *
      {
         this.gotoAndStop(this.GetIconTypeFrameLabel(aType));
         this["Encounter_mc"].gotoAndStop(this.GetIconLevelFrameLabel(aLevel));
         this["Encounter_mc"].BossIcon_mc.visible = aIsBoss;
      }
      
      public function GetIconLevelFramePadding(aLevel:uint) : uint
      {
         switch(aLevel)
         {
            case 1:
               return 0;
            case 2:
               return 4;
            case 3:
               return 8;
            default:
               return 0;
         }
      }
      
      private function GetIconTypeFrameLabel(aType:uint) : String
      {
         switch(aType)
         {
            case 1:
               return "Skull";
            case 2:
               return "Target";
            default:
               return "";
         }
      }
      
      private function GetIconLevelFrameLabel(aLevel:uint) : String
      {
         switch(aLevel)
         {
            case 1:
               return "Easy";
            case 2:
               return "Medium";
            case 3:
               return "Difficult";
            default:
               return "";
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}

