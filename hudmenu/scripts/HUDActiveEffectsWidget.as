package
{
   import Shared.AS3.BSUIComponent;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1712")]
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
      
      public function set bInPowerArmorMode(value:Boolean) : void
      {
         if(this._bInPowerArmorMode != value)
         {
            this._bInPowerArmorMode = value;
            SetIsDirty();
         }
      }
      
      private function instantiateClips() : void
      {
         var newClip:HUDActiveEffectClip = null;
         this.ClipHolderInternal_mc = new MovieClip();
         addChild(this.ClipHolderInternal_mc);
         var position:Number = 0;
         for(var i:* = 0; i < MAX_NUM_CLIPS; i++)
         {
            position -= CLIP_WIDTH;
            newClip = new HUDActiveEffectClip();
            newClip.x = position;
            newClip.visible = false;
            this.ClipHolderInternal_mc.addChild(newClip);
            this.m_EffectClipsA.push(newClip);
            position -= CLIP_SPACER;
         }
      }
      
      public function onDataUpdate(aData:Array) : void
      {
         var dataClip:Object = null;
         var curData:Object = null;
         var indexedEffect:HUDActiveEffectClip = null;
         var clip:HUDActiveEffectClip = null;
         var totalDuration:uint = 0;
         var elapsedDuration:uint = 0;
         var curElapsed:uint = 0;
         var dataIndex:* = 0;
         var clipIndex:* = 0;
         for(dataClip in aData)
         {
            curData = aData[dataClip];
            for(clipIndex = 0; clipIndex < this.m_EffectClipsA.length; clipIndex++)
            {
               indexedEffect = this.m_EffectClipsA[clipIndex];
               if(indexedEffect.iconID == curData.iconID && indexedEffect.EffectUID == curData.effectUID && indexedEffect.RefreshCount == curData.refreshCount && indexedEffect.Active)
               {
                  curData.elapsed = indexedEffect.CurrentTime;
                  break;
               }
            }
         }
         dataIndex = aData.length - 1;
         clipIndex = 0;
         while(clipIndex < this.m_EffectClipsA.length)
         {
            clip = this.m_EffectClipsA[clipIndex];
            curData = aData[dataIndex];
            if(clipIndex < aData.length)
            {
               clip.IconFrame = curData.iconID;
               clip.IconColor = curData.iconColor;
               clip.StackAmount = curData.stackAmount;
               clip.RefreshCount = curData.refreshCount;
               clip.EffectUID = curData.effectUID;
               totalDuration = 0;
               elapsedDuration = 0;
               if(Boolean(curData.hasOwnProperty("duration")) && curData.duration > 0)
               {
                  totalDuration = uint(curData.duration);
                  curElapsed = curData.hasOwnProperty("elapsed") ? uint(curData.elapsed) : 0;
                  elapsedDuration = totalDuration > curElapsed ? curElapsed : 0;
               }
               clip.setEffect(curData.iconID,elapsedDuration,totalDuration);
            }
            else
            {
               clip.IconFrame = "";
            }
            clipIndex++;
            dataIndex--;
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
         var position:Number = this.m_EffectClipsA[0].x - CLIP_SPACER;
         for(var i:* = 1; i < this.m_EffectClipsA.length; i++)
         {
            if(this.m_EffectClipsA[i].visible)
            {
               position -= this.m_EffectClipsA[i].StackAmount > 0 ? CLIP_WIDTH + this.m_EffectClipsA[i].Stack_mc.width - STACK_OVERLAP : CLIP_WIDTH;
               this.m_EffectClipsA[i].x = position;
               position -= CLIP_SPACER;
            }
         }
      }
   }
}

