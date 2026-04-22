package
{
   import Shared.AS3.BSUIComponent;
   import fl.transitions.Tween;
   import fl.transitions.TweenEvent;
   import fl.transitions.easing.*;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol489")]
   public class HUDActiveEffectClip extends BSUIComponent
   {
      
      private static const DEFAULT_STACK_WIDTH:Number = 19;
      
      private static const STACK_WITH_PADDING:Number = 12;
      
      private static const STACK_SHADOW_AMOUNT:Number = 1;
      
      public var Icon_mc:MovieClip;
      
      public var Stack_mc:MovieClip;
      
      public var FillInternal_mc:MovieClip;
      
      private const COLOR_GREEN:uint = 0;
      
      private const COLOR_RED:uint = 1;
      
      private var m_IconFrame:String;
      
      private var m_IconColor:uint = 0;
      
      private var m_IconID:String = "";
      
      private var m_EffectUID:uint = 0;
      
      private var m_StackAmount:uint = 0;
      
      private var m_RefreshCount:uint = 0;
      
      private const FILL_START_Y:Number = -14.5;
      
      private const FILL_END_Y:Number = 14.5;
      
      private var m_StartingDuration:uint = 0;
      
      private var m_ElapsedDuration:uint = 0;
      
      private var m_TotalDuration:uint = 0;
      
      private var m_StartingY:Number = 0;
      
      private var m_FillTween:Tween = null;
      
      public function HUDActiveEffectClip()
      {
         addFrameScript(0,this.frame1,1,this.frame2);
         super();
      }
      
      public function get Active() : Boolean
      {
         return visible && this.m_FillTween != null;
      }
      
      public function get iconID() : String
      {
         return this.m_IconID;
      }
      
      public function set iconID(param1:String) : void
      {
         this.m_IconID = param1;
      }
      
      public function set EffectUID(param1:uint) : void
      {
         this.m_EffectUID = param1;
      }
      
      public function get EffectUID() : uint
      {
         return this.m_EffectUID;
      }
      
      public function set IconFrame(param1:String) : void
      {
         if(this.m_IconFrame != param1)
         {
            this.m_IconFrame = param1;
            SetIsDirty();
         }
      }
      
      public function set IconColor(param1:uint) : *
      {
         var _loc2_:* = param1 == this.COLOR_GREEN ? this.COLOR_GREEN : this.COLOR_RED;
         if(this.m_IconColor != _loc2_)
         {
            this.m_IconColor = _loc2_;
            SetIsDirty();
         }
      }
      
      public function set RefreshCount(param1:uint) : void
      {
         if(this.m_RefreshCount != param1)
         {
            this.m_RefreshCount = param1;
            SetIsDirty();
         }
      }
      
      public function get RefreshCount() : uint
      {
         return this.m_RefreshCount;
      }
      
      public function set StackAmount(param1:uint) : void
      {
         if(this.m_StackAmount != param1)
         {
            this.m_StackAmount = param1;
            SetIsDirty();
         }
      }
      
      public function get CurrentTime() : uint
      {
         return this.m_ElapsedDuration;
      }
      
      public function get StackAmount() : uint
      {
         return this.m_StackAmount;
      }
      
      private function applyTween() : void
      {
         this.m_StartingY = this.FILL_START_Y + this.m_StartingDuration / this.m_TotalDuration * (this.FILL_END_Y - this.FILL_START_Y);
         this.FillInternal_mc.Fill_mc.y = this.m_StartingY;
         this.m_FillTween = new Tween(this.FillInternal_mc.Fill_mc,"y",None.easeNone,this.m_StartingY,this.FILL_END_Y,(this.m_TotalDuration - this.m_StartingDuration) / 1000,true);
         this.m_FillTween.addEventListener(TweenEvent.MOTION_CHANGE,this.onTweenChange);
         this.m_FillTween.addEventListener(TweenEvent.MOTION_FINISH,this.onTweenFinish);
         this.m_FillTween.start();
      }
      
      public function setEffect(param1:String, param2:uint, param3:uint) : void
      {
         this.m_ElapsedDuration = param2;
         this.m_StartingDuration = param2;
         this.m_TotalDuration = param3;
         this.iconID = param1;
         this.clearTween();
         if(Boolean(this.FillInternal_mc) && Boolean(this.FillInternal_mc.Fill_mc))
         {
            if(this.m_StartingDuration <= this.m_TotalDuration && this.m_TotalDuration > 0)
            {
               this.applyTween();
            }
            else
            {
               this.FillInternal_mc.Fill_mc.y = this.FILL_END_Y;
            }
         }
      }
      
      private function clearTween() : void
      {
         if(this.m_FillTween)
         {
            this.m_FillTween.removeEventListener(TweenEvent.MOTION_CHANGE,this.onTweenChange);
            this.m_FillTween.removeEventListener(TweenEvent.MOTION_FINISH,this.onTweenFinish);
            this.m_FillTween.stop();
            this.m_FillTween = null;
         }
      }
      
      private function onTweenChange(param1:TweenEvent) : void
      {
         this.m_ElapsedDuration = this.m_StartingDuration + param1.time * 1000;
      }
      
      private function onTweenFinish(param1:TweenEvent) : void
      {
         this.m_ElapsedDuration = 0;
         this.m_StartingDuration = 0;
      }
      
      override public function redrawUIComponent() : void
      {
         if(this.m_IconColor == this.COLOR_RED)
         {
            gotoAndStop("negative");
         }
         else
         {
            gotoAndStop("positive");
         }
         this.Icon_mc.gotoAndStop(this.m_IconFrame);
         if(this.m_StackAmount > 0)
         {
            this.Stack_mc.StackAmount_tf.text = this.m_StackAmount.toString();
            this.Stack_mc.BG_mc.width = DEFAULT_STACK_WIDTH + (this.Stack_mc.StackAmount_tf.text.length - 1) * STACK_WITH_PADDING;
            this.Stack_mc.StackAmount_tf.width = this.Stack_mc.BG_mc.width - STACK_SHADOW_AMOUNT * 2;
            this.Stack_mc.StackAmount_tf.x = this.Stack_mc.BG_mc.x + STACK_SHADOW_AMOUNT;
            this.Stack_mc.visible = true;
         }
         else
         {
            this.Stack_mc.visible = false;
         }
         visible = this.m_IconFrame != null && this.m_IconFrame.length > 0;
         if(this.m_FillTween)
         {
            this.clearTween();
            this.m_StartingDuration = this.m_ElapsedDuration;
            this.applyTween();
         }
         else
         {
            this.FillInternal_mc.Fill_mc.y = this.FILL_END_Y;
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

