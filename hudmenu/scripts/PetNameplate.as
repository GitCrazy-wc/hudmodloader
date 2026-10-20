package
{
   import Shared.AS3.BSUIComponent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol96")]
   public class PetNameplate extends BSUIComponent
   {
      
      private static const ICON_SPACING:Number = 5;
      
      private static const NAME_LEVEL_SPACING:Number = 10;
      
      private static const NEAR_FAR_TOGGLE_DISTANCE:Number = 30;
      
      private static const PT_NAMEPLATE_OFFSET:Number = 18;
      
      private static const PT_NAMEPLATE_WIDTH_OFFSET:Number = 100;
      
      private static const PT_NAMEPLATE_MIN_WIDTH:Number = 218;
      
      public var Name_tf:TextField;
      
      public var Level_tf:TextField;
      
      public var FarNameplate_mc:MovieClip;
      
      public var PetNamePlateNameGroup_mc:MovieClip;
      
      public var PTNameplate_mc:MovieClip;
      
      public var Wounded_mc:MovieClip;
      
      private var _EntityID:uint;
      
      private var _Name:String;
      
      private var _Distance:Number;
      
      private var _Level:uint = 0;
      
      private var _IsWounded:Boolean = false;
      
      private var _ShowPetNameplate:Boolean = true;
      
      public function PetNameplate()
      {
         super();
         addFrameScript(0,this.frame1);
         Extensions.enabled = true;
         this._EntityID = uint.MAX_VALUE;
         this._Name = "";
         this._Distance = 0;
         if(this.PetNamePlateNameGroup_mc)
         {
            this.Name_tf = this.PetNamePlateNameGroup_mc.Name_tf;
            this.Level_tf = this.PetNamePlateNameGroup_mc.Level_mc.Level_tf;
            this.PTNameplate_mc = this.PetNamePlateNameGroup_mc.PTNameplate_mc;
            this.Wounded_mc = this.PetNamePlateNameGroup_mc.Wounded_mc;
            this.PetNamePlateNameGroup_mc.Level_mc.gotoAndStop("yellow");
         }
         TextFieldEx.setTextAutoSize(this.Level_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function set entityID(aVal:uint) : void
      {
         this._EntityID = aVal;
      }
      
      public function get entityID() : uint
      {
         return this._EntityID;
      }
      
      public function set displayName(aVal:String) : void
      {
         this._Name = aVal;
         SetIsDirty();
      }
      
      public function set distance(aVal:Number) : void
      {
         if(aVal != this._Distance)
         {
            this._Distance = aVal;
            SetIsDirty();
         }
      }
      
      public function set level(aVal:uint) : void
      {
         if(aVal != this._Level)
         {
            this._Level = aVal;
            SetIsDirty();
         }
      }
      
      public function set isWounded(aVal:Boolean) : void
      {
         if(aVal != this._IsWounded)
         {
            this._IsWounded = aVal;
            SetIsDirty();
         }
      }
      
      public function set showPetNameplate(aVal:Boolean) : void
      {
         if(aVal != this._ShowPetNameplate)
         {
            this._ShowPetNameplate = aVal;
            SetIsDirty();
         }
      }
      
      override public function redrawUIComponent() : void
      {
         var nameColor:uint = GlobalFunc.COLOR_TEXT_HEADER;
         if(this._Distance <= NEAR_FAR_TOGGLE_DISTANCE && this._ShowPetNameplate)
         {
            this.PetNamePlateNameGroup_mc.visible = true;
            this.FarNameplate_mc.visible = false;
            this.Wounded_mc.visible = this._IsWounded;
         }
         else
         {
            this.PetNamePlateNameGroup_mc.visible = false;
            this.FarNameplate_mc.visible = this._ShowPetNameplate || this._IsWounded;
            this.FarNameplate_mc.gotoAndStop(this._IsWounded ? "wounded" : "healthy");
         }
         this.Level_tf.text = this._Level.toString();
         this.Name_tf.text = this._Name;
         if(this.Name_tf)
         {
            this.Name_tf.textColor = nameColor;
         }
         var nameParts:Array = [];
         if(this.PetNamePlateNameGroup_mc.visible)
         {
            nameParts.push(this.PetNamePlateNameGroup_mc.Level_mc);
            nameParts.push(this.PetNamePlateNameGroup_mc.PetIconSmall_mc);
            nameParts.push(this.PetNamePlateNameGroup_mc.Name_tf);
         }
         GlobalFunc.arrangeItems(nameParts,false,GlobalFunc.ALIGN_CENTER,NAME_LEVEL_SPACING);
         this.PTNameplate_mc.x = this.PetNamePlateNameGroup_mc.Level_mc.x - PT_NAMEPLATE_OFFSET;
         if(this.Name_tf.textWidth + PT_NAMEPLATE_WIDTH_OFFSET > PT_NAMEPLATE_MIN_WIDTH)
         {
            this.PTNameplate_mc.PTNameplateBG_mc.width = this.Name_tf.textWidth + PT_NAMEPLATE_WIDTH_OFFSET;
         }
         else
         {
            this.PTNameplate_mc.PTNameplateBG_mc.width = PT_NAMEPLATE_MIN_WIDTH;
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

