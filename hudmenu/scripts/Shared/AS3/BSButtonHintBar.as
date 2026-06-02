package Shared.AS3
{
   import Shared.AS3.COMPANIONAPP.CompanionAppMode;
   import Shared.AS3.COMPANIONAPP.MobileButtonHint;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public dynamic class BSButtonHintBar extends BSUIComponent
   {
      
      public static var BACKGROUND_COLOR:uint = 0;
      
      public static var BACKGROUND_ALPHA:Number = 0.4;
      
      public static var BACKGROUND_PAD:Number = 8;
      
      public static var BUTTON_SPACING:Number = 20;
      
      public static var BAR_Y_OFFSET:Number = 5;
      
      private static var ALIGN_CENTER:* = 0;
      
      private static var ALIGN_LEFT:* = 1;
      
      private static var ALIGN_RIGHT:* = 2;
      
      public var Sizer_mc:MovieClip;
      
      private var Alignment:int = 0;
      
      private var StartingXPos:int = 0;
      
      private var m_UseBackground:Boolean = true;
      
      private var m_PaddingRect:Rectangle;
      
      private var ButtonHintBarInternal_mc:MovieClip;
      
      private var _buttonHintDataV:Vector.<BSButtonHintData>;
      
      private var ButtonPoolV:Vector.<BSButtonHint>;
      
      private var m_UseVaultTecColor:Boolean = true;
      
      private var _holdButtonsV:Vector.<BSButtonHintData>;
      
      private var _bRedirectToButtonBarMenu:Boolean = true;
      
      public var SetButtonHintData:Function;
      
      public function BSButtonHintBar()
      {
         this.SetButtonHintData = this.SetButtonHintData_Impl;
         super();
         visible = false;
         this.ButtonHintBarInternal_mc = new MovieClip();
         this.ButtonHintBarInternal_mc.y = BAR_Y_OFFSET;
         addChild(this.ButtonHintBarInternal_mc);
         this._buttonHintDataV = new Vector.<BSButtonHintData>();
         this.ButtonPoolV = new Vector.<BSButtonHint>();
         this._holdButtonsV = new Vector.<BSButtonHintData>();
         this.m_PaddingRect = new Rectangle();
         this.StartingXPos = this.x;
      }
      
      public function set paddingRect(aRect:Rectangle) : void
      {
         this.m_PaddingRect = aRect;
         SetIsDirty();
      }
      
      public function get paddingRect() : Rectangle
      {
         return this.m_PaddingRect;
      }
      
      public function set useBackground(aUse:Boolean) : void
      {
         this.m_UseBackground = aUse;
         SetIsDirty();
      }
      
      public function get useBackground() : Boolean
      {
         return this.m_UseBackground;
      }
      
      public function get bRedirectToButtonBarMenu_Inspectable() : Boolean
      {
         return this._bRedirectToButtonBarMenu;
      }
      
      public function set bRedirectToButtonBarMenu_Inspectable(abRedirectToButtonBarMenu:Boolean) : *
      {
         if(this._bRedirectToButtonBarMenu != abRedirectToButtonBarMenu)
         {
            this._bRedirectToButtonBarMenu = abRedirectToButtonBarMenu;
            SetIsDirty();
         }
      }
      
      public function get useVaultTecColor() : Boolean
      {
         return this.m_UseVaultTecColor;
      }
      
      public function set useVaultTecColor(aUseColor:Boolean) : void
      {
         if(this.m_UseVaultTecColor != aUseColor)
         {
            this.m_UseVaultTecColor = aUseColor;
            SetIsDirty();
         }
      }
      
      public function set align(alignment:uint) : *
      {
         this.Alignment = alignment;
         SetIsDirty();
      }
      
      private function CanBeVisible() : Boolean
      {
         return !this.bRedirectToButtonBarMenu_Inspectable || !bAcquiredByNativeCode;
      }
      
      override public function onAcquiredByNativeCode() : *
      {
         var emptyButtonHintDataV:Vector.<BSButtonHintData> = null;
         super.onAcquiredByNativeCode();
         if(this.bRedirectToButtonBarMenu_Inspectable)
         {
            this.SetButtonHintData(this._buttonHintDataV);
            emptyButtonHintDataV = new Vector.<BSButtonHintData>();
            this.SetButtonHintData_Impl(emptyButtonHintDataV);
            SetIsDirty();
         }
      }
      
      private function SetButtonHintData_Impl(abuttonHintDataV:Vector.<BSButtonHintData>) : void
      {
         this._buttonHintDataV.forEach(function(item:BSButtonHintData, index:int, vector:Vector.<BSButtonHintData>):*
         {
            if(item)
            {
               item.removeEventListener(BSButtonHintData.BUTTON_HINT_DATA_CHANGE,this.onButtonHintDataDirtyEvent);
            }
         },this);
         this._holdButtonsV.length = 0;
         this._buttonHintDataV = abuttonHintDataV;
         this._buttonHintDataV.forEach(function(item:BSButtonHintData, index:int, vector:Vector.<BSButtonHintData>):*
         {
            if(item)
            {
               item.addEventListener(BSButtonHintData.BUTTON_HINT_DATA_CHANGE,this.onButtonHintDataDirtyEvent);
               if(item.canHold)
               {
                  _holdButtonsV.push(item);
               }
            }
         },this);
         this.CreateButtonHints();
      }
      
      public function FindDispatchEventForUserEvent(aUserEvent:String) : String
      {
         var event:String = "";
         for(var i:* = 0; i < this._buttonHintDataV.length; i++)
         {
            if(this._buttonHintDataV[i].UserEvent == aUserEvent)
            {
               event = this._buttonHintDataV[i].DispatchEvent;
               break;
            }
         }
         return event;
      }
      
      public function FindButtonHintDataForUserEvent(aUserEvent:String, abExcludeHoldButtons:Boolean) : BSButtonHintData
      {
         var i:* = undefined;
         var j:* = undefined;
         var buttonData:BSButtonHintData = null;
         if(!abExcludeHoldButtons)
         {
            for(i = 0; i < this._holdButtonsV.length; i++)
            {
               if(this._holdButtonsV[i].UserEvent == aUserEvent)
               {
                  buttonData = this._holdButtonsV[i];
                  break;
               }
            }
         }
         if(buttonData == null)
         {
            for(j = 0; j < this._buttonHintDataV.length; j++)
            {
               if(this._buttonHintDataV[j].UserEvent == aUserEvent && !this._buttonHintDataV[j].canHold)
               {
                  buttonData = this._buttonHintDataV[j];
                  break;
               }
            }
         }
         return buttonData;
      }
      
      public function onButtonHintDataDirtyEvent(arEvent:Event) : void
      {
         SetIsDirty();
      }
      
      public function HideAllButtons() : void
      {
         var button:BSButtonHintData = null;
         for each(button in this._buttonHintDataV)
         {
            button.ButtonVisible = false;
         }
      }
      
      public function HideAllButtonsExcept(... aButtonHintArgs) : void
      {
         var button:BSButtonHintData = null;
         var bshouldHide:* = false;
         var i:int = 0;
         for each(button in this._buttonHintDataV)
         {
            bshouldHide = true;
            for(i = 0; i < aButtonHintArgs.length; i++)
            {
               bshouldHide = button != aButtonHintArgs[i];
               if(!bshouldHide)
               {
                  break;
               }
            }
            if(bshouldHide)
            {
               button.ButtonVisible = false;
            }
         }
      }
      
      private function CreateButtonHints() : *
      {
         visible = false;
         while(this.ButtonPoolV.length < this._buttonHintDataV.length)
         {
            if(CompanionAppMode.isOn)
            {
               this.ButtonPoolV.push(new MobileButtonHint());
            }
            else
            {
               this.ButtonPoolV.push(new BSButtonHint());
            }
         }
         for(var i:int = 0; i < this.ButtonPoolV.length; i++)
         {
            this.ButtonPoolV[i].ButtonHintData = i < this._buttonHintDataV.length ? this._buttonHintDataV[i] : null;
         }
         SetIsDirty();
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
      }
      
      override public function redrawUIComponent() : void
      {
         var curButtonHelp:BSButtonHint = null;
         super.redrawUIComponent();
         var bHasVisibleButtons:* = false;
         var nextX:Number = 0;
         var nextRightAlignedX:Number = 0;
         if(CompanionAppMode.isOn)
         {
            nextRightAlignedX = stage.stageWidth - 75;
         }
         var lastEntry:int = -1;
         for(var i:Number = 0; i < this.ButtonPoolV.length; i++)
         {
            curButtonHelp = this.ButtonPoolV[i];
            if(curButtonHelp.ButtonVisible && this.CanBeVisible())
            {
               bHasVisibleButtons = true;
               curButtonHelp.useVaultTecColor = this.useVaultTecColor;
               lastEntry = i;
               if(!this.ButtonHintBarInternal_mc.contains(curButtonHelp))
               {
                  this.ButtonHintBarInternal_mc.addChild(curButtonHelp);
               }
               if(curButtonHelp.bIsDirty)
               {
                  curButtonHelp.redrawUIComponent();
               }
               if(CompanionAppMode.isOn && curButtonHelp.Justification == BSButtonHint.JUSTIFY_RIGHT)
               {
                  nextRightAlignedX -= curButtonHelp.Sizer_mc.width;
                  curButtonHelp.x = nextRightAlignedX;
               }
               else
               {
                  curButtonHelp.x = nextX;
                  nextX += curButtonHelp.Sizer_mc.width + BUTTON_SPACING;
               }
            }
            else if(this.ButtonHintBarInternal_mc.contains(curButtonHelp))
            {
               this.ButtonHintBarInternal_mc.removeChild(curButtonHelp);
            }
         }
         if(this.ButtonPoolV.length > this._buttonHintDataV.length)
         {
            this.ButtonPoolV.splice(this._buttonHintDataV.length,this.ButtonPoolV.length - this._buttonHintDataV.length);
         }
         var ourBounds:Rectangle = new Rectangle(0,0,0,0);
         if(lastEntry >= 0)
         {
            ourBounds.width = this.ButtonPoolV[lastEntry].x + this.ButtonPoolV[lastEntry].Sizer_mc.width;
            ourBounds.height = this.ButtonPoolV[lastEntry].y + this.ButtonPoolV[lastEntry].Sizer_mc.height;
         }
         if(Boolean(this.Sizer_mc) && this.ButtonHintBarInternal_mc.contains(this.Sizer_mc))
         {
            this.ButtonHintBarInternal_mc.removeChild(this.Sizer_mc);
         }
         this.Sizer_mc = new MovieClip();
         var bgGraphics:Graphics = this.Sizer_mc.graphics;
         this.ButtonHintBarInternal_mc.addChildAt(this.Sizer_mc,0);
         bgGraphics.clear();
         bgGraphics.beginFill(BACKGROUND_COLOR,this.m_UseBackground ? BACKGROUND_ALPHA : 0);
         bgGraphics.drawRect(0 + this.m_PaddingRect.x,0 + this.m_PaddingRect.y,ourBounds.width + this.m_PaddingRect.width + BACKGROUND_PAD,ourBounds.height + this.m_PaddingRect.height);
         bgGraphics.endFill();
         this.Sizer_mc.x = BACKGROUND_PAD * -0.5;
         if(!CompanionAppMode.isOn)
         {
            this.ButtonHintBarInternal_mc.x = -ourBounds.width / 2;
         }
         visible = bHasVisibleButtons;
         if(this.Alignment == ALIGN_LEFT)
         {
            this.x = this.StartingXPos + ourBounds.width / 2;
         }
         else if(this.Alignment != ALIGN_CENTER)
         {
            if(this.Alignment == ALIGN_RIGHT)
            {
               this.x = this.StartingXPos - ourBounds.width / 2;
            }
         }
      }
   }
}

