package
{
   import Shared.EnumHelper;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1031")]
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
      
      public function SetIcon(param1:uint, param2:uint, param3:Boolean) : *
      {
         this.gotoAndStop(this.GetIconTypeFrameLabel(param1));
         this["Encounter_mc"].gotoAndStop(this.GetIconLevelFrameLabel(param2));
         this["Encounter_mc"].BossIcon_mc.visible = param3;
      }
      
      private function GetIconTypeFrameLabel(param1:uint) : String
      {
         switch(param1)
         {
            case 1:
               return "Skull";
            case 2:
               return "Target";
            default:
               return "";
         }
      }
      
      private function GetIconLevelFrameLabel(param1:uint) : String
      {
         switch(param1)
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

