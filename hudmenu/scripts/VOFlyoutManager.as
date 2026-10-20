package
{
   import Shared.AS3.BSAsync;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1502")]
   public class VOFlyoutManager extends MovieClip
   {
      
      private static const HIDE_BUFFER_TIME:uint = 800;
      
      private static const UNLOAD_BUFFER_TIME:uint = 2000;
      
      private static const FRAME_LABEL_MAPPING:Object = {
         "BS01_NPCM_DailyOps_Dodge":"dailyOps",
         "BS02_NPCM_Pappas":"dailyOps",
         "XPD_NPCF_Hex":"expeditions",
         "E07B_Invaders_NPCM_Homer":"appalachia",
         "XPD_NPCM_Danilo":"expeditions",
         "XPD_AC_NPCM_Buttercup":"expeditions",
         "XPD_AC_NPCM_Sal":"expeditions",
         "XPD_AC_NPCM_BillyBeltbuckles":"expeditions",
         "XPD_AC_NPCM_Veracio":"expeditions",
         "XPD_AC_NPCM_Juchi":"expeditions",
         "XPD_AC_NPCF_MotherCharlotte":"expeditions",
         "XPD_AC_NPCF_Jullian":"expeditions",
         "XPD_AC_NPCM_MayorTim":"expeditions",
         "SDOW_NPCM_Debunker":"slasher"
      };
      
      private static const PORTRAIT_PATH:String = "VOCharacterAnim.swf";
      
      private static const PORTRAIT_X:Number = 1686;
      
      private static const PORTRAIT_Y:Number = 617;
      
      public var AppalachiaVOFlyoutGraphic_mc:MovieClip;
      
      public var XPDVOFlyoutGraphic_mc:MovieClip;
      
      public var DOVOFlyoutGraphic_mc:MovieClip;
      
      public var DOVOWaveForm_mc:MovieClip;
      
      public var SlasherVOFlyoutGraphic_mc:MovieClip;
      
      private var PortraitLoader:Loader;
      
      private var m_ActiveFlyoutClip:MovieClip;
      
      private var m_Portraits:MovieClip;
      
      private var m_PortraitsLoaded:Boolean = false;
      
      private var m_HideTimer:Timer;
      
      private var m_UnloadTimer:Timer;
      
      private var m_SpeakerName:String = "";
      
      private var m_SpeakerEditorID:String = "";
      
      public function VOFlyoutManager()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,3,this.frame4);
         BSUIDataManager.Subscribe("HUDVOFlyoutData",this.onHUDVOFlyoutData);
         this.m_HideTimer = new Timer(HIDE_BUFFER_TIME,1);
         this.m_HideTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onHideTimerEvent);
         this.m_UnloadTimer = new Timer(UNLOAD_BUFFER_TIME,1);
         this.m_UnloadTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onUnloadTimerEvent);
         this.m_ActiveFlyoutClip = this.DOVOFlyoutGraphic_mc;
      }
      
      public function set speakerName(aName:String) : void
      {
         this.m_HideTimer.stop();
         this.m_UnloadTimer.stop();
         if(!aName)
         {
            aName = "";
         }
         if(aName != this.m_SpeakerName)
         {
            this.m_SpeakerName = aName;
            if(this.m_SpeakerName == "")
            {
               this.hideVOFlyout();
            }
            else if(this.m_PortraitsLoaded)
            {
               this.showVOFlyout();
            }
            else
            {
               this.loadPortraits();
            }
         }
      }
      
      private function loadPortraits() : *
      {
         var portraitLoadRequest:URLRequest = null;
         if(this.PortraitLoader == null)
         {
            this.PortraitLoader = new Loader();
            portraitLoadRequest = new URLRequest(PORTRAIT_PATH);
            this.PortraitLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onPortraitLoadComplete);
            this.PortraitLoader.load(portraitLoadRequest);
         }
      }
      
      public function removePortraits() : *
      {
         if(this.PortraitLoader)
         {
            this.PortraitLoader.removeChildren();
            if(this.PortraitLoader.parent)
            {
               this.PortraitLoader.parent.removeChild(this.PortraitLoader);
            }
            this.PortraitLoader.unloadAndStop();
            this.PortraitLoader = null;
         }
         this.m_Portraits = null;
         this.m_PortraitsLoaded = false;
      }
      
      private function onPortraitLoadComplete(loadCompleteEvent:Event) : *
      {
         if(this.PortraitLoader != null)
         {
            this.m_Portraits = loadCompleteEvent.currentTarget.content;
            this.m_Portraits.x = PORTRAIT_X;
            this.m_Portraits.y = PORTRAIT_Y;
            this.PortraitLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onPortraitLoadComplete);
            this.m_PortraitsLoaded = true;
         }
         this.showVOFlyout();
      }
      
      private function showVOFlyout() : void
      {
         var frameLabel:String = FRAME_LABEL_MAPPING[this.m_SpeakerEditorID];
         if(!frameLabel || frameLabel.length == 0)
         {
            frameLabel = "dailyOps";
         }
         if(currentLabel != frameLabel || !this.m_ActiveFlyoutClip)
         {
            if(Boolean(this.m_ActiveFlyoutClip) && this.m_ActiveFlyoutClip.currentLabel != "off")
            {
               this.m_ActiveFlyoutClip.gotoAndStop("off");
            }
            gotoAndStop(frameLabel);
            switch(frameLabel)
            {
               case "expeditions":
                  this.m_ActiveFlyoutClip = this.XPDVOFlyoutGraphic_mc;
                  break;
               case "appalachia":
                  this.m_ActiveFlyoutClip = this.AppalachiaVOFlyoutGraphic_mc;
                  break;
               case "slasher":
                  this.m_ActiveFlyoutClip = this.SlasherVOFlyoutGraphic_mc;
                  break;
               case "dailyOps":
               default:
                  this.m_ActiveFlyoutClip = this.DOVOFlyoutGraphic_mc;
            }
         }
         BSAsync.Await(this,BSAsync.AWAIT_FRAME_LABEL,this.setFlyoutClip,frameLabel);
      }
      
      private function setFlyoutClip() : void
      {
         if(this.m_ActiveFlyoutClip)
         {
            try
            {
               if(Boolean(this.m_Portraits) && Boolean(this.m_Portraits.VOCharacterAnim_mc))
               {
                  this.m_Portraits.VOCharacterAnim_mc.gotoAndStop(this.m_SpeakerEditorID);
               }
            }
            catch(aArgumentError:ArgumentError)
            {
               if(Boolean(m_Portraits) && Boolean(m_Portraits.VOCharacterAnim_mc))
               {
                  m_Portraits.VOCharacterAnim_mc.gotoAndStop(1);
               }
            }
            if(this.m_ActiveFlyoutClip && this.m_ActiveFlyoutClip.VOCharacter_mc && Boolean(this.m_Portraits))
            {
               this.m_ActiveFlyoutClip.VOCharacter_mc.addChild(this.m_Portraits);
            }
            this.m_ActiveFlyoutClip.VOCharName_mc.textField_tf.text = this.m_SpeakerName;
            if(this.m_ActiveFlyoutClip.currentLabel == "off" || this.m_ActiveFlyoutClip.currentLabel == "rollOff")
            {
               this.m_ActiveFlyoutClip.gotoAndPlay("rollOn");
            }
         }
      }
      
      private function hideVOFlyout() : void
      {
         this.m_HideTimer.reset();
         this.m_HideTimer.start();
         this.m_UnloadTimer.reset();
         this.m_UnloadTimer.start();
      }
      
      private function onHUDVOFlyoutData(aEvent:FromClientDataEvent) : void
      {
         if(Boolean(aEvent) && Boolean(aEvent.data))
         {
            this.m_SpeakerEditorID = aEvent.data.speakerEditorID;
            this.speakerName = aEvent.data.speakerName;
         }
      }
      
      private function onHideTimerEvent(aEvent:Event) : void
      {
         if(this.m_SpeakerName == "" && Boolean(this.m_ActiveFlyoutClip))
         {
            this.m_ActiveFlyoutClip.gotoAndPlay("rollOff");
         }
         this.m_HideTimer.reset();
      }
      
      private function onUnloadTimerEvent(aEvent:Event) : void
      {
         this.m_UnloadTimer.reset();
         this.removePortraits();
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
      
      internal function frame3() : *
      {
         stop();
      }
      
      internal function frame4() : *
      {
         stop();
      }
   }
}

