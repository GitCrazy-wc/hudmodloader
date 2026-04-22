package
{
   import Shared.AS3.BSUIComponent;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1705")]
   public dynamic class HUDActiveEffectsWidget extends BSUIComponent
   {
      
      private static const MAX_NUM_CLIPS:uint = 8;
      
      private static const CLIP_WIDTH:Number = 35;
      
      private static const CLIP_SPACER:Number = 4;
      
      private static const STACK_OVERLAP:Number = 2;
      
      public var ActiveEffectStatusLabel_mc:MovieClip;
      
      private var ClipHolderInternal_mc:MovieClip;
      
      private var m_EffectClipsA:Array = new Array();
      
      private var _bInPowerArmorMode:Boolean = false;
      
      public function HUDActiveEffectsWidget()
      {
         super();
         this.instantiateClips();
      }
      
      public function get bInPowerArmorMode() : Boolean
      {
         return this._bInPowerArmorMode;
      }
      
      public function set bInPowerArmorMode(param1:Boolean) : void
      {
         if(this._bInPowerArmorMode != param1)
         {
            this._bInPowerArmorMode = param1;
            SetIsDirty();
         }
      }
      
      private function instantiateClips() : void
      {
         var _loc3_:HUDActiveEffectClip = null;
         this.ClipHolderInternal_mc = new MovieClip();
         addChild(this.ClipHolderInternal_mc);
         var _loc1_:Number = 0;
         var _loc2_:* = 0;
         while(_loc2_ < MAX_NUM_CLIPS)
         {
            _loc1_ -= CLIP_WIDTH;
            _loc3_ = new HUDActiveEffectClip();
            _loc3_.x = _loc1_;
            _loc3_.visible = false;
            this.ClipHolderInternal_mc.addChild(_loc3_);
            this.m_EffectClipsA.push(_loc3_);
            _loc1_ -= CLIP_SPACER;
            _loc2_++;
         }
      }
      
      public function onDataUpdate(param1:Array) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:HUDActiveEffectClip = null;
         var _loc7_:HUDActiveEffectClip = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         for(_loc4_ in param1)
         {
            _loc5_ = param1[_loc4_];
            _loc3_ = 0;
            while(_loc3_ < this.m_EffectClipsA.length)
            {
               _loc6_ = this.m_EffectClipsA[_loc3_];
               if(_loc6_.iconID == _loc5_.iconID && _loc6_.EffectUID == _loc5_.effectUID && _loc6_.RefreshCount == _loc5_.refreshCount && _loc6_.Active)
               {
                  _loc5_.elapsed = _loc6_.CurrentTime;
                  break;
               }
               _loc3_++;
            }
         }
         _loc2_ = param1.length - 1;
         _loc3_ = 0;
         while(_loc3_ < this.m_EffectClipsA.length)
         {
            _loc7_ = this.m_EffectClipsA[_loc3_];
            _loc5_ = param1[_loc2_];
            if(_loc3_ < param1.length)
            {
               _loc7_.IconFrame = _loc5_.iconID;
               _loc7_.IconColor = _loc5_.iconColor;
               _loc7_.StackAmount = _loc5_.stackAmount;
               _loc7_.RefreshCount = _loc5_.refreshCount;
               _loc7_.EffectUID = _loc5_.effectUID;
               _loc8_ = 0;
               _loc9_ = 0;
               if(Boolean(_loc5_.hasOwnProperty("duration")) && _loc5_.duration > 0)
               {
                  _loc8_ = uint(_loc5_.duration);
                  _loc10_ = _loc5_.hasOwnProperty("elapsed") ? uint(_loc5_.elapsed) : 0;
                  _loc9_ = _loc8_ > _loc10_ ? _loc10_ : 0;
               }
               _loc7_.setEffect(_loc5_.iconID,_loc9_,_loc8_);
            }
            else
            {
               _loc7_.IconFrame = "";
            }
            _loc3_++;
            _loc2_--;
         }
         SetIsDirty();
      }
      
      override public function redrawUIComponent() : void
      {
         if(this.bInPowerArmorMode)
         {
            this.ClipHolderInternal_mc.x = 50;
            this.ClipHolderInternal_mc.y = 15;
         }
         else
         {
            this.ClipHolderInternal_mc.x = 0;
            this.ClipHolderInternal_mc.y = 0;
         }
         var _loc1_:Number = this.m_EffectClipsA[0].x - CLIP_SPACER;
         var _loc2_:* = 1;
         while(_loc2_ < this.m_EffectClipsA.length)
         {
            if(this.m_EffectClipsA[_loc2_].visible)
            {
               _loc1_ -= this.m_EffectClipsA[_loc2_].StackAmount > 0 ? CLIP_WIDTH + this.m_EffectClipsA[_loc2_].Stack_mc.width - STACK_OVERLAP : CLIP_WIDTH;
               this.m_EffectClipsA[_loc2_].x = _loc1_;
               _loc1_ -= CLIP_SPACER;
            }
            _loc2_++;
         }
      }
   }
}

