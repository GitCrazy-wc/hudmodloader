package
{
   import Shared.AS3.BSUIComponent;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public dynamic class HUDFadingListItem extends BSUIComponent
   {
      
      public static const EVENT_FADE_OUT_COMPLETE:String = "HUDFadingListItem::FadeOutComplete";
      
      public static const EVENT_FADE_IN_COMPLETE:String = "HUDFadingListItem::FadeInComplete";
      
      private static const FADE_STATE_OUT:int = 0;
      
      private static const FADE_STATE_IN:int = 1;
      
      protected var _fadeInStarted:Boolean = false;
      
      protected var _fullyFadedIn:Boolean = false;
      
      protected var _fadeOutStarted:Boolean = false;
      
      protected var _fastFadeOutStarted:Boolean = false;
      
      protected var _fullyFadedOut:Boolean = false;
      
      private var m_FadeTimer:Timer;
      
      private const MILLISECOND_CONVERSION:Number = 1000;
      
      private var _requestedFadeState:int = 0;
      
      private var m_EndAnimFrame:int = 1;
      
      public function HUDFadingListItem()
      {
         var i:int = 0;
         super();
         this._fadeInStarted = false;
         this._fullyFadedIn = false;
         this._fastFadeOutStarted = false;
         this._fadeOutStarted = false;
         this._fullyFadedOut = false;
         for(this.m_EndAnimFrame = this.totalFrames; i < this.currentLabels.length; )
         {
            if(this.currentLabels[i].name == "endAnim")
            {
               this.m_EndAnimFrame = this.currentLabels[i].frame;
               break;
            }
            i++;
         }
         addEventListener(HUDFadingListItem.EVENT_FADE_IN_COMPLETE,this.OnFadeInComplete);
         addEventListener(HUDFadingListItem.EVENT_FADE_OUT_COMPLETE,this.OnFadeOutComplete);
      }
      
      public function get endAnimFrame() : int
      {
         return this.m_EndAnimFrame;
      }
      
      public function FadeOutCustomLength(aFadeLengthInSeconds:uint) : *
      {
         if(!this.m_FadeTimer)
         {
            this._fadeOutStarted = true;
            this.m_FadeTimer = new Timer(this.MILLISECOND_CONVERSION * aFadeLengthInSeconds,0);
            this.m_FadeTimer.addEventListener(TimerEvent.TIMER,this.onFadeTick);
            this.m_FadeTimer.start();
         }
      }
      
      private function onFadeTick(aEvent:Event) : void
      {
         if(this.m_FadeTimer)
         {
            this.m_FadeTimer.removeEventListener(TimerEvent.TIMER,this.onFadeTick);
            this.m_FadeTimer.stop();
            this.m_FadeTimer = null;
            this.FastFadeOut();
         }
      }
      
      public function FadeIn() : *
      {
         if(!this._fadeInStarted)
         {
            visible = true;
            this._fadeInStarted = true;
            gotoAndPlay("FadeIn");
         }
      }
      
      public function FastFadeOut() : *
      {
         this._fadeOutStarted = true;
         this._fastFadeOutStarted = true;
         gotoAndPlay("FastFadeOut");
      }
      
      public function FadeOut() : *
      {
         this._fadeOutStarted = true;
         gotoAndPlay("FadeOut");
      }
      
      public function OnPause() : *
      {
      }
      
      public function OnResume() : *
      {
      }
      
      public function get fadeInStarted() : Boolean
      {
         return this._fadeInStarted;
      }
      
      public function get fadeOutStarted() : Boolean
      {
         return this._fadeOutStarted;
      }
      
      public function get fullyFadedIn() : Boolean
      {
         return this._fullyFadedIn;
      }
      
      public function get fullyFadedOut() : Boolean
      {
         return this._fullyFadedOut;
      }
      
      public function ResetFadeState() : *
      {
         gotoAndPlay("Reset");
         visible = false;
         this._fadeInStarted = false;
         this._fullyFadedIn = false;
         this._fastFadeOutStarted = false;
         this._fadeOutStarted = false;
         this._fullyFadedOut = false;
      }
      
      public function CanFadeIn() : Boolean
      {
         return !this.fadeInStarted && !bIsDirty;
      }
      
      public function CanFastFadeOut() : Boolean
      {
         return this._fullyFadedIn && !this._fastFadeOutStarted && !bIsDirty;
      }
      
      public function CanFadeOut() : Boolean
      {
         return this._fullyFadedIn && !this._fadeOutStarted && !bIsDirty;
      }
      
      protected function OnFastFadeOutStarted(aEvent:Event = null) : *
      {
         this._fastFadeOutStarted = true;
      }
      
      protected function OnFadeInComplete(aEvent:Event = null) : *
      {
         this._fullyFadedIn = true;
      }
      
      protected function OnFadeOutComplete(aEvent:Event = null) : *
      {
         visible = false;
         this._fullyFadedOut = true;
      }
   }
}

