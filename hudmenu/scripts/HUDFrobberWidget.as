package
{
   import Shared.AS3.BSButtonHintBar;
   import Shared.AS3.BSButtonHintData;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class HUDFrobberWidget extends MovieClip
   {
      
      public static const TEST_MODE:Boolean = false;
      
      private static const ICON_SPACING:Number = 2;
      
      public static const BUTTON_TYPE_INVALID:int = -1;
      
      public static const BUTTON_TYPE_A:int = 0;
      
      public static const BUTTON_TYPE_X:int = 1;
      
      public static const BUTTON_TYPE_Y:int = 2;
      
      public static const BUTTON_TYPE_B:int = 3;
      
      public static const BUTTON_TYPE_COUNT:int = 4;
      
      public static const EVENT_BUTTON:String = "Frobber::ButtonEvent";
      
      public var Internal_mc:MovieClip;
      
      public var ButtonHintBar_mc:BSButtonHintBar;
      
      public var Header_mc:MovieClip;
      
      public var Syncing_mc:MovieClip;
      
      private var m_Show:Boolean = false;
      
      private var m_ShowInventory:Boolean = false;
      
      private var m_ButtonHintData:Vector.<BSButtonHintData>;
      
      private var m_IsHolding:Boolean = false;
      
      private var m_IsSyncing:Boolean = false;
      
      private var m_HeaderTextFormat:TextFormat;
      
      private var m_ButtonInfoTap:Array;
      
      private var m_ButtonData:Array;
      
      public function HUDFrobberWidget()
      {
         super();
         Extensions.enabled = true;
         this.ButtonHintBar_mc = this.Internal_mc.ButtonHintBar_mc;
         this.Header_mc = this.Internal_mc.Header_mc;
         this.m_HeaderTextFormat = this.Header_mc.Header_tf.getTextFormat();
         TextFieldEx.setTextAutoSize(this.Header_mc.Header_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.ButtonHintBar_mc.useVaultTecColor = true;
         this.ButtonHintBar_mc.useBackground = false;
         BSUIDataManager.Subscribe("FrobberData",this.onDataUpdate,TEST_MODE);
         if(TEST_MODE)
         {
            addEventListener(KeyboardEvent.KEY_DOWN,this.onTestKeyDown);
            addEventListener(KeyboardEvent.KEY_UP,this.onTestKeyUp);
            addEventListener(MouseEvent.MOUSE_DOWN,this.onTestMouseDown);
            addEventListener(MouseEvent.MOUSE_UP,this.onTestMouseUp);
         }
      }
      
      private function onTestMouseDown(param1:MouseEvent) : void
      {
         this.ProcessUserEvent("Activate",true);
      }
      
      private function onTestMouseUp(param1:MouseEvent) : void
      {
         this.ProcessUserEvent("Activate",false);
      }
      
      private function onTestKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.F6)
         {
            this.ProcessUserEvent("Activate",true);
         }
      }
      
      private function onTestKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.F6)
         {
            this.ProcessUserEvent("Activate",false);
         }
      }
      
      public function set isHolding(param1:Boolean) : void
      {
         if(param1 != this.m_IsHolding)
         {
            if(param1)
            {
               addEventListener(Event.ENTER_FRAME,this.updateHeldButtons);
            }
            else
            {
               removeEventListener(Event.ENTER_FRAME,this.updateHeldButtons);
            }
            this.updateHeldButtons();
         }
         this.m_IsHolding = param1;
      }
      
      public function get isHolding() : Boolean
      {
         return this.m_IsHolding;
      }
      
      public function set show(param1:Boolean) : void
      {
         if(param1 != this.m_Show)
         {
            if(param1)
            {
               gotoAndPlay("rollOn");
            }
            else
            {
               gotoAndPlay("rollOff");
            }
         }
         this.m_Show = param1;
      }
      
      public function get show() : Boolean
      {
         return this.m_Show;
      }
      
      public function set showInventory(param1:Boolean) : void
      {
         if(param1 != this.m_ShowInventory)
         {
            if(param1)
            {
               this.m_HeaderTextFormat.align = TextFormatAlign.LEFT;
               this.Internal_mc.gotoAndStop("Inventory");
            }
            else
            {
               this.m_HeaderTextFormat.align = TextFormatAlign.CENTER;
               this.Internal_mc.gotoAndStop("Basic");
            }
            this.Header_mc.Header_tf.setTextFormat(this.m_HeaderTextFormat);
         }
         this.m_ShowInventory = param1;
      }
      
      public function get showInventory() : Boolean
      {
         return this.m_ShowInventory;
      }
      
      public function set isSyncing(param1:Boolean) : void
      {
         this.m_IsSyncing = param1;
      }
      
      public function get isSyncing() : Boolean
      {
         return this.m_IsSyncing;
      }
      
      private function getDataForButtonHint(param1:Object) : BSButtonHintData
      {
         var _loc2_:BSButtonHintData = new BSButtonHintData(param1.text,param1.buttonHint.szTextPC,param1.buttonHint.szTextPS4,param1.buttonHint.szTextXB1,1,null);
         _loc2_.canHold = param1.pressAndHold;
         _loc2_.ButtonEnabled = param1.enabled;
         _loc2_.IsWarning = param1.isWarning;
         return _loc2_;
      }
      
      private function buildButtonInfo(param1:Array) : void
      {
         var _loc2_:HUDFrobberButtonData = null;
         var _loc3_:BSButtonHintData = null;
         this.m_ButtonHintData = new Vector.<BSButtonHintData>();
         this.m_ButtonData = new Array();
         var _loc4_:uint = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_ = this.getDataForButtonHint(param1[_loc4_]);
            this.m_ButtonHintData.push(_loc3_);
            if(param1[_loc4_].type > BUTTON_TYPE_INVALID)
            {
               _loc2_ = this.m_ButtonData[param1[_loc4_].type];
               if(_loc2_ == null)
               {
                  _loc2_ = new HUDFrobberButtonData();
                  this.m_ButtonData[param1[_loc4_].type] = _loc2_;
               }
               _loc2_.setInfo(param1[_loc4_].pressAndHold,param1[_loc4_],_loc3_);
            }
            _loc4_++;
         }
         this.ButtonHintBar_mc.SetButtonHintData(this.m_ButtonHintData);
      }
      
      private function onDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:TextLineMetrics = null;
         this.buildButtonInfo(param1.data.buttons);
         this.show = param1.data.show;
         this.showInventory = false;
         this.isSyncing = param1.data.syncing;
         this.Header_mc.Header_tf.text = param1.data.headerText.toUpperCase();
         if(this.Header_mc.TaggedForSearch_mc)
         {
            this.Header_mc.TaggedForSearch_mc.visible = param1.data.taggedForSearch;
            if(this.Header_mc.TaggedForSearch_mc.visible)
            {
               _loc2_ = this.Header_mc.Header_tf.getLineMetrics(0);
               this.Header_mc.TaggedForSearch_mc.x = this.Header_mc.Header_tf.x + _loc2_.x - this.Header_mc.TaggedForSearch_mc.width - ICON_SPACING;
            }
         }
         this.decideHeaderTextColor();
      }
      
      private function getButtonTypeFromEvent(param1:String) : int
      {
         var _loc2_:Array = new Array("QCAButton","QCXButton","QCYButton","QCBButton");
         return _loc2_.indexOf(param1);
      }
      
      private function updateHeldButtons(param1:Event = null) : void
      {
         var _loc2_:HUDFrobberButtonData = null;
         var _loc3_:uint = 0;
         while(_loc3_ < BUTTON_TYPE_COUNT)
         {
            _loc2_ = this.m_ButtonData[_loc3_];
            if(_loc2_ != null && _loc2_.ButtonEnabled)
            {
               _loc2_.updateHoldPercent();
            }
            _loc3_++;
         }
      }
      
      private function updateButtonHold(param1:int, param2:Boolean) : void
      {
         var _loc4_:HUDFrobberButtonData = null;
         var _loc3_:Boolean = false;
         var _loc5_:uint = 0;
         while(_loc5_ < BUTTON_TYPE_COUNT)
         {
            _loc4_ = this.m_ButtonData[_loc5_];
            if(_loc4_ != null)
            {
               if(_loc4_.canHold)
               {
                  if(param1 == _loc5_)
                  {
                     _loc4_.isHolding = param2;
                  }
                  if(_loc4_.isHolding)
                  {
                     _loc3_ = true;
                  }
               }
            }
            _loc5_++;
         }
         this.isHolding = _loc3_;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc5_:HUDFrobberButtonData = null;
         var _loc6_:uint = 0;
         var _loc3_:* = false;
         var _loc4_:int = this.getButtonTypeFromEvent(param1);
         if(_loc4_ >= 0)
         {
            _loc3_ = this.m_ButtonData[_loc4_] != null;
            if(param2)
            {
               this.updateButtonHold(_loc4_,true);
            }
            else
            {
               _loc6_ = 0;
               while(_loc6_ < BUTTON_TYPE_COUNT)
               {
                  _loc5_ = this.m_ButtonData[_loc6_];
                  if(_loc4_ == _loc6_ && _loc5_ != null)
                  {
                     if(_loc5_.canHold && _loc5_.holdTimeMet)
                     {
                        BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_BUTTON,{
                           "eButtonType":_loc4_,
                           "bPressAndHold":true
                        }));
                     }
                     else if(_loc5_.canTap)
                     {
                        BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_BUTTON,{
                           "eButtonType":_loc4_,
                           "bPressAndHold":false
                        }));
                     }
                  }
                  _loc6_++;
               }
               this.updateButtonHold(_loc4_,false);
            }
         }
         return _loc3_;
      }
      
      private function decideHeaderTextColor() : void
      {
         var _loc1_:* = undefined;
         this.Header_mc.Header_tf.textColor = GlobalFunc.COLOR_TEXT_HEADER;
         for each(_loc1_ in this.m_ButtonHintData)
         {
            if(_loc1_.IsWarning)
            {
               this.Header_mc.Header_tf.textColor = GlobalFunc.COLOR_WARNING_ACCENT;
               break;
            }
         }
      }
   }
}

