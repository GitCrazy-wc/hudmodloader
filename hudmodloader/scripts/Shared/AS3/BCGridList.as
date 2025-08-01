package Shared.AS3
{
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.PlatformChangeEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.getDefinitionByName;
   
   public class BCGridList extends MovieClip
   {
      
      public static const TEXT_OPTION_NONE:String = "None";
      
      public static const TEXT_OPTION_SHRINK_TO_FIT:String = "Shrink To Fit";
      
      public static const TEXT_OPTION_MULTILINE:String = "Multi-Line";
      
      public static const SELECTION_CHANGE:String = "BCGridList::selectionChange";
      
      public static const ITEM_PRESS:String = "BCGridList::itemPress";
      
      public static const LIST_PRESS:String = "BCGridList::listPress";
      
      public static const MOUSE_OVER_ITEM:String = "BCGridList::mouseOverItem";
      
      public static const LIST_UPDATED:String = "BCGridList::listUpdated";
      
      public static const SELECTION_EDGE_BOUNCE:String = "BCGridList::selectionEdgeBounce";
      
      public static const ITEM_CLICKED:String = "BCGridList::itemClicked";
      
      public var Body_mc:MovieClip;
      
      public var ScrollUp_mc:MovieClip;
      
      public var ScrollDown_mc:MovieClip;
      
      public var ScrollLeft_mc:MovieClip;
      
      public var ScrollRight_mc:MovieClip;
      
      public var ScrollVert_mc:BSSlider;
      
      public var ScrollHoriz_mc:BSSlider;
      
      private var EntryHolder_mc:MovieClip;
      
      private var m_ListItemClassName:String = "BSScrollingListEntry";
      
      private var m_ListItemClass:Class;
      
      private var m_MaxRows:uint = 7;
      
      private var m_MaxCols:uint = 1;
      
      private var m_TextBehavior:String;
      
      private var m_ScrollVertical:Boolean = true;
      
      private var m_DisableSelection:Boolean = false;
      
      private var m_DisableInput:Boolean = false;
      
      private var m_DisableMouseWheel:Boolean = false;
      
      private var m_WheelSelectionScroll:Boolean = false;
      
      private var m_SelectionScrollLock:Boolean = false;
      
      private var m_SelectionScrollLockOffset:int = 0;
      
      private var m_IdName:String = "";
      
      private var m_EntriesLayeredInOrder:Boolean = false;
      
      private var m_SetSelectedIndexOnFirstEntryDataInit:Boolean = false;
      
      private var m_SelectedIndex:int = -1;
      
      private var m_SelectedClip:BSScrollingListEntry;
      
      private var m_SelectedDisplayIndex:int = -1;
      
      protected var m_DisplayedItemCount:uint = 0;
      
      private var m_MaxDisplayedItems:uint = 0;
      
      protected var m_ListStartIndex:uint = 0;
      
      private var m_ShowSelectedItem:Boolean = true;
      
      private var m_PrevSelectedIndex:int = -1;
      
      private var m_IsDirty:Boolean = false;
      
      private var m_NeedRecalculateScrollMax:Boolean = true;
      
      private var m_NeedRecreateClips:Boolean = false;
      
      protected var m_NeedRedraw:Boolean = true;
      
      private var m_NeedSliderUpdate:Boolean = true;
      
      private var m_QueueSelectUnderMouse:Boolean = false;
      
      private var m_RowScrollPos:uint = 0;
      
      private var m_RowScrollPosMax:int = 0;
      
      private var m_ColScrollPos:uint = 0;
      
      private var m_ColScrollPosMax:int = 0;
      
      private var m_DisplayWidth:Number = 0;
      
      private var m_DisplayHeight:Number = 0;
      
      private var m_LastNavDirection:int = -1;
      
      private var m_SelectedEntryId:* = null;
      
      private var m_SelectionChangeCount:int = 0;
      
      private var m_UseVariableWidth:Boolean = false;
      
      private var m_IgnoreMouse:Boolean = false;
      
      private var m_uiController:* = 0;
      
      protected var m_Entries:Array;
      
      protected var m_ClipVector:Vector.<BSScrollingListEntry>;
      
      public function BCGridList()
      {
         super();
         this.m_Entries = [];
         this.m_ClipVector = new Vector.<BSScrollingListEntry>();
         if(this.Body_mc == null)
         {
            throw new Error("BCGridList : Required instance Body_mc null or invalid.");
         }
         this.EntryHolder_mc = new MovieClip();
         this.EntryHolder_mc.name = "EntryHolder_mc";
         this.Body_mc.addChildAt(this.EntryHolder_mc,this.EntryHolder_mc.numChildren);
         if(this.ScrollUp_mc != null)
         {
            this.ScrollUp_mc.visible = false;
         }
         if(this.ScrollDown_mc != null)
         {
            this.ScrollDown_mc.visible = false;
         }
         if(this.ScrollLeft_mc != null)
         {
            this.ScrollLeft_mc.visible = false;
         }
         if(this.ScrollRight_mc != null)
         {
            this.ScrollRight_mc.visible = false;
         }
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         if(this.ScrollHoriz_mc != null)
         {
            this.ScrollHoriz_mc.visible = false;
            this.ScrollHoriz_mc.handleSizeViaContents = true;
         }
         if(this.ScrollVert_mc != null)
         {
            this.ScrollVert_mc.bVertical = true;
            this.ScrollVert_mc.visible = false;
            this.ScrollVert_mc.handleSizeViaContents = true;
         }
      }
      
      public function get entryClips() : Vector.<BSScrollingListEntry>
      {
         return this.m_ClipVector;
      }
      
      public function set showSelectedItem(param1:Boolean) : void
      {
         this.m_ShowSelectedItem = param1;
         this.m_NeedRedraw = true;
         this.setIsDirty();
      }
      
      public function get showSelectedItem() : Boolean
      {
         return this.m_ShowSelectedItem;
      }
      
      public function set maxRows(param1:uint) : void
      {
         this.m_MaxRows = param1;
         this.m_NeedRecreateClips = true;
      }
      
      public function set maxCols(param1:uint) : void
      {
         this.m_MaxCols = param1;
         this.m_NeedRecreateClips = true;
      }
      
      public function set scrollVertical(param1:Boolean) : void
      {
         this.m_ScrollVertical = param1;
         this.m_NeedRecalculateScrollMax = true;
         this.m_NeedRedraw = true;
         this.setIsDirty();
      }
      
      public function get scrollVertical() : Boolean
      {
         return this.m_ScrollVertical;
      }
      
      public function get selectedEntry() : Object
      {
         return this.m_Entries[this.m_SelectedIndex];
      }
      
      public function get rowScrollPos() : int
      {
         return this.m_RowScrollPos;
      }
      
      public function get colScrollPos() : int
      {
         return this.m_ColScrollPos;
      }
      
      public function get displayWidth() : Number
      {
         return this.m_DisplayWidth;
      }
      
      public function get displayHeight() : Number
      {
         return this.m_DisplayHeight;
      }
      
      public function set useVariableWidth(param1:Boolean) : void
      {
         this.m_UseVariableWidth = param1;
      }
      
      public function get useVariableWidth() : Boolean
      {
         return this.m_UseVariableWidth;
      }
      
      public function set rowScrollPos(param1:int) : void
      {
         param1 = GlobalFunc.Clamp(param1,0,this.m_RowScrollPosMax);
         if(param1 != this.m_RowScrollPos)
         {
            this.m_RowScrollPos = param1;
            this.m_NeedRedraw = true;
            this.m_NeedSliderUpdate = true;
            this.setIsDirty();
         }
      }
      
      public function set colScrollPos(param1:int) : void
      {
         param1 = GlobalFunc.Clamp(param1,0,this.m_ColScrollPosMax);
         if(param1 != this.m_ColScrollPos)
         {
            this.m_ColScrollPos = param1;
            this.m_NeedRedraw = true;
            this.m_NeedSliderUpdate = true;
            this.setIsDirty();
         }
      }
      
      public function get disableInput() : Boolean
      {
         return this.m_DisableInput;
      }
      
      public function set disableInput(param1:Boolean) : void
      {
         this.m_DisableInput = param1;
      }
      
      public function get disableMouseWheel() : Boolean
      {
         return this.m_DisableMouseWheel;
      }
      
      public function set disableMouseWheel(param1:Boolean) : void
      {
         this.m_DisableMouseWheel = param1;
      }
      
      public function get disableSelection() : Boolean
      {
         return this.m_DisableSelection;
      }
      
      public function set disableSelection(param1:Boolean) : void
      {
         this.m_DisableSelection = param1;
      }
      
      public function get ignoreMouse() : Boolean
      {
         return this.m_IgnoreMouse;
      }
      
      public function get selectedCol() : uint
      {
         return this.getColFromIndex(this.m_SelectedIndex);
      }
      
      public function get selectedRow() : uint
      {
         return this.getRowFromIndex(this.m_SelectedIndex);
      }
      
      public function get displayedItemCount() : uint
      {
         return this.m_DisplayedItemCount;
      }
      
      public function get maxDisplayedItems() : uint
      {
         return this.m_MaxDisplayedItems;
      }
      
      public function get entryCount() : uint
      {
         return this.m_Entries.length;
      }
      
      public function get idName() : String
      {
         return this.m_IdName;
      }
      
      public function set idName(param1:String) : void
      {
         this.m_IdName = param1;
      }
      
      public function get selectedEntryId() : *
      {
         return this.m_SelectedEntryId;
      }
      
      public function get selectedIndex() : int
      {
         return this.m_SelectedIndex;
      }
      
      public function set selectedIndex(param1:int) : *
      {
         var _loc2_:int = GlobalFunc.Clamp(param1,-1,this.m_Entries.length - 1);
         if(_loc2_ != this.m_SelectedIndex)
         {
            this.m_PrevSelectedIndex = this.m_SelectedIndex;
            this.m_SelectedIndex = _loc2_;
            if(this.idName != "" && this.entryData && this.m_SelectedIndex < this.entryData.length && this.m_SelectedIndex > -1)
            {
               this.m_SelectedEntryId = this.entryData[this.m_SelectedIndex][this.idName];
            }
            ++this.m_SelectionChangeCount;
            dispatchEvent(new Event(SELECTION_CHANGE,true,true));
            this.constrainScrollToSelection();
            this.m_NeedRedraw = true;
            this.setIsDirty();
         }
      }
      
      public function get selectedClip() : BSScrollingListEntry
      {
         return this.m_SelectedClip;
      }
      
      public function set listItemClassName(param1:String) : void
      {
         this.m_ListItemClass = getDefinitionByName(param1) as Class;
         this.m_ListItemClassName = param1;
         this.m_NeedRedraw = true;
      }
      
      public function get entryData() : Array
      {
         return this.m_Entries;
      }
      
      public function set entryData(param1:Array) : void
      {
         var _loc2_:uint = 0;
         this.m_Entries = param1;
         this.m_NeedRecalculateScrollMax = true;
         this.m_NeedRedraw = true;
         if(this.setSelectedIndexOnFirstEntryDataInit && param1 && param1.length > 0 && this.selectedIndex <= -1)
         {
            this.selectedIndex = 0;
         }
         else if(this.idName != "" && this.selectedEntryId != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.entryData.length)
            {
               if(this.entryData[_loc2_][this.idName] === this.selectedEntryId)
               {
                  this.selectedIndex = _loc2_;
                  break;
               }
               _loc2_++;
            }
         }
         this.setIsDirty();
      }
      
      public function set needRedraw(param1:*) : void
      {
         this.m_NeedRedraw = param1;
      }
      
      public function set wheelSelectionScroll(param1:Boolean) : void
      {
         this.m_WheelSelectionScroll = param1;
      }
      
      public function get wheelSelectionScroll() : Boolean
      {
         return this.m_WheelSelectionScroll;
      }
      
      public function set selectionScrollLockOffset(param1:int) : void
      {
         this.m_SelectionScrollLockOffset = param1;
      }
      
      public function get selectionScrollLockOffset() : int
      {
         return this.m_SelectionScrollLockOffset;
      }
      
      public function set selectionScrollLock(param1:Boolean) : void
      {
         this.m_SelectionScrollLock = param1;
      }
      
      public function get selectionScrollLock() : Boolean
      {
         return this.m_SelectionScrollLock;
      }
      
      public function get lastNavDirection() : int
      {
         return this.m_LastNavDirection;
      }
      
      public function set entriesLayeredInOrder(param1:Boolean) : void
      {
         this.m_EntriesLayeredInOrder = param1;
      }
      
      public function get entriesLayeredInOrder() : Boolean
      {
         return this.m_EntriesLayeredInOrder;
      }
      
      public function set setSelectedIndexOnFirstEntryDataInit(param1:Boolean) : void
      {
         this.m_SetSelectedIndexOnFirstEntryDataInit = param1;
      }
      
      public function get setSelectedIndexOnFirstEntryDataInit() : Boolean
      {
         return this.m_SetSelectedIndexOnFirstEntryDataInit;
      }
      
      public function get prevSelectedIndex() : int
      {
         return this.m_PrevSelectedIndex;
      }
      
      public function get selectionChangeCount() : int
      {
         return this.m_SelectionChangeCount;
      }
      
      public function get isInitialSelection() : Boolean
      {
         return this.m_SelectionChangeCount == 1;
      }
      
      private function getRowFromIndex(param1:int) : uint
      {
         if(param1 > 0)
         {
            return Math.floor(param1 / (this.m_MaxCols + this.m_ColScrollPosMax));
         }
         return 0;
      }
      
      private function getColFromIndex(param1:int) : uint
      {
         if(param1 > 0)
         {
            return param1 % (this.m_MaxCols + this.m_ColScrollPosMax);
         }
         return 0;
      }
      
      public function setIsDirty() : void
      {
         if(!this.m_IsDirty)
         {
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.m_IsDirty = true;
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this.selectedIndex = this.selectedIndex;
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.m_IsDirty = false;
         if(this.m_NeedRecalculateScrollMax)
         {
            this.calculateListScrollMax();
         }
         if(this.m_NeedRecreateClips)
         {
            this.createEntryClips();
         }
         if(this.m_NeedRedraw || this.m_QueueSelectUnderMouse)
         {
            this.m_ListStartIndex = this.m_ScrollVertical ? this.m_MaxCols * this.m_RowScrollPos : this.m_MaxRows * this.m_ColScrollPos;
         }
         if(this.m_QueueSelectUnderMouse)
         {
            this.selectItemUnderMouse();
         }
         if(this.m_NeedRedraw)
         {
            this.redrawList();
         }
      }
      
      public function getIndexFromGridPos(param1:uint, param2:uint) : int
      {
         return param1 * this.m_MaxCols + param2;
      }
      
      private function constrainScrollToSelection() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(this.m_NeedRecalculateScrollMax)
         {
            this.calculateListScrollMax();
         }
         if(this.selectedIndex > 0)
         {
            _loc1_ = this.selectedRow;
            _loc2_ = this.selectedCol;
            if(this.m_SelectionScrollLock)
            {
               if(this.m_ScrollVertical)
               {
                  this.rowScrollPos = _loc1_ + this.m_SelectionScrollLockOffset;
               }
               else
               {
                  this.colScrollPos = _loc2_ + this.m_SelectionScrollLockOffset;
               }
            }
            else if(this.m_ScrollVertical)
            {
               _loc3_ = this.m_RowScrollPos;
               _loc4_ = uint(this.m_RowScrollPos + this.m_MaxRows - 1);
               if(_loc1_ < _loc3_)
               {
                  this.rowScrollPos = _loc1_;
               }
               else if(_loc1_ > _loc4_)
               {
                  this.rowScrollPos = _loc1_ - (this.m_MaxRows - 1);
               }
            }
            else
            {
               _loc5_ = this.m_ColScrollPos;
               _loc6_ = uint(this.m_ColScrollPos + this.m_MaxCols - 1);
               if(_loc2_ < _loc5_)
               {
                  this.colScrollPos = _loc2_;
               }
               else if(_loc2_ > _loc6_)
               {
                  this.colScrollPos = _loc2_ - (this.m_MaxCols - 1);
               }
            }
         }
         else
         {
            this.rowScrollPos = 0;
            this.colScrollPos = 0;
         }
      }
      
      public function onKeyDown(param1:KeyboardEvent) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         if(!this.m_DisableInput)
         {
            _loc2_ = this.selectedRow;
            _loc3_ = this.selectedCol;
            _loc4_ = false;
            _loc5_ = false;
            switch(param1.keyCode)
            {
               case Keyboard.UP:
                  _loc5_ = true;
                  if(_loc2_ > 0)
                  {
                     _loc4_ = true;
                     _loc2_--;
                  }
                  param1.stopPropagation();
                  break;
               case Keyboard.DOWN:
                  _loc5_ = true;
                  if(_loc2_ < this.getRowFromIndex(this.m_Entries.length - 1))
                  {
                     _loc4_ = true;
                     _loc2_++;
                  }
                  param1.stopPropagation();
                  break;
               case Keyboard.LEFT:
                  _loc5_ = true;
                  if(_loc3_ > 0)
                  {
                     _loc4_ = true;
                     _loc3_--;
                  }
                  param1.stopPropagation();
                  break;
               case Keyboard.RIGHT:
                  _loc5_ = true;
                  if(_loc3_ < this.m_MaxCols - 1 + this.m_ColScrollPosMax && this.selectedIndex < this.entryCount - 1)
                  {
                     _loc4_ = true;
                     _loc3_++;
                  }
                  param1.stopPropagation();
            }
            this.m_LastNavDirection = param1.keyCode;
            this.m_IgnoreMouse = this.m_IgnoreMouse || _loc4_ || _loc5_;
            if(_loc4_)
            {
               this.selectedIndex = this.getIndexFromGridPos(_loc2_,_loc3_);
            }
            else if(_loc5_)
            {
               dispatchEvent(new Event(SELECTION_EDGE_BOUNCE,true,true));
            }
         }
      }
      
      public function onKeyUp(param1:KeyboardEvent) : *
      {
         if(!this.m_DisableInput && !this.m_DisableSelection && param1.keyCode == Keyboard.ENTER)
         {
            this.onItemPress(param1);
            param1.stopPropagation();
         }
      }
      
      private function onItemClick(param1:Event) : void
      {
         this.m_IgnoreMouse = false;
         if(this.m_WheelSelectionScroll && this.m_uiController == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
         {
            if((param1.target as BSScrollingListEntry).itemIndex != this.m_SelectedIndex)
            {
               this.selectedIndex = (param1.target as BSScrollingListEntry).itemIndex;
            }
            else
            {
               if(!this.m_DisableInput && !this.m_DisableSelection && this.m_SelectedIndex != -1)
               {
                  dispatchEvent(new Event(ITEM_CLICKED,true,true));
               }
               this.onItemPress(param1);
            }
         }
         else
         {
            if(!this.m_DisableInput && !this.m_DisableSelection && this.m_SelectedIndex != -1)
            {
               dispatchEvent(new Event(ITEM_CLICKED,true,true));
            }
            this.onItemPress(param1);
         }
      }
      
      public function onItemPress(param1:Event) : void
      {
         if(!this.m_DisableInput && !this.m_DisableSelection && this.m_SelectedIndex != -1)
         {
            dispatchEvent(new Event(ITEM_PRESS,true,true));
         }
         else
         {
            dispatchEvent(new Event(LIST_PRESS,true,true));
         }
      }
      
      private function onItemMouseOver(param1:MouseEvent) : void
      {
         if(!this.m_DisableInput && !this.m_DisableSelection && !this.m_WheelSelectionScroll && !this.m_IgnoreMouse && this.m_uiController == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
         {
            this.selectedIndex = (param1.currentTarget as BSScrollingListEntry).itemIndex;
            dispatchEvent(new Event(MOUSE_OVER_ITEM,true,true));
         }
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         this.m_IgnoreMouse = false;
      }
      
      private function onMouseWheel(param1:MouseEvent) : void
      {
         var _loc2_:* = false;
         this.m_IgnoreMouse = false;
         if(!this.m_DisableInput && !this.m_DisableMouseWheel && this.m_uiController == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
         {
            _loc2_ = param1.delta < 0;
            if(this.m_WheelSelectionScroll)
            {
               if(_loc2_)
               {
                  this.m_LastNavDirection = this.m_ScrollVertical ? int(Keyboard.UP) : int(Keyboard.RIGHT);
                  ++this.selectedIndex;
               }
               else if(this.selectedIndex > 0)
               {
                  this.m_LastNavDirection = this.m_ScrollVertical ? int(Keyboard.DOWN) : int(Keyboard.LEFT);
                  --this.selectedIndex;
               }
            }
            else
            {
               this.m_QueueSelectUnderMouse = true;
               if(this.m_ScrollVertical)
               {
                  this.scrollRow(_loc2_);
               }
               else
               {
                  this.scrollCol(_loc2_);
               }
            }
            param1.stopPropagation();
         }
      }
      
      public function scrollRow(param1:Boolean, param2:* = false) : void
      {
         var _loc3_:int = param1 ? this.m_RowScrollPos + 1 : int(this.m_RowScrollPos - 1);
         if(param2)
         {
            if(_loc3_ < 0)
            {
               _loc3_ = this.m_RowScrollPosMax - 1;
            }
            else if(_loc3_ >= this.m_RowScrollPosMax)
            {
               _loc3_ = 0;
            }
         }
         else
         {
            _loc3_ = Math.max(0,_loc3_);
         }
         this.rowScrollPos = _loc3_;
      }
      
      public function scrollCol(param1:Boolean, param2:* = false) : void
      {
         var _loc3_:int = param1 ? this.m_ColScrollPos + 1 : int(this.m_ColScrollPos - 1);
         if(param2)
         {
            if(_loc3_ < 0)
            {
               _loc3_ = this.m_ColScrollPosMax - 1;
            }
            else if(_loc3_ >= this.m_ColScrollPosMax)
            {
               _loc3_ = 0;
            }
         }
         else
         {
            _loc3_ = Math.max(0,_loc3_);
         }
         this.colScrollPos = _loc3_;
      }
      
      private function onSliderValueChange(param1:CustomEvent) : void
      {
         if(this.m_ScrollVertical && this.ScrollVert_mc != null && param1.target == this.ScrollVert_mc)
         {
            this.rowScrollPos = param1.params as uint;
         }
         if(!this.m_ScrollVertical && this.ScrollHoriz_mc != null && param1.target == this.ScrollHoriz_mc)
         {
            this.colScrollPos = param1.params as uint;
         }
      }
      
      private function onPlatformChange(param1:PlatformChangeEvent) : void
      {
         this.m_uiController = param1.uiController;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         var e:Event = param1;
         if(this.ScrollUp_mc != null)
         {
            this.ScrollUp_mc.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):*
            {
               scrollRow(false);
            });
         }
         if(this.ScrollDown_mc != null)
         {
            this.ScrollDown_mc.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):*
            {
               scrollRow(true);
            });
         }
         if(this.ScrollLeft_mc != null)
         {
            this.ScrollLeft_mc.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):*
            {
               scrollCol(false);
            });
         }
         if(this.ScrollRight_mc != null)
         {
            this.ScrollRight_mc.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):*
            {
               scrollCol(true);
            });
         }
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         addEventListener(BSSlider.VALUE_CHANGED,this.onSliderValueChange);
         stage.addEventListener(PlatformChangeEvent.PLATFORM_CHANGE,this.onPlatformChange);
         stage.focus = this;
      }
      
      protected function populateEntryClip(param1:BSScrollingListEntry, param2:Object) : *
      {
         var aEntryClip:BSScrollingListEntry = param1;
         var aEntryData:Object = param2;
         if(aEntryClip != null)
         {
            aEntryClip.selected = aEntryData == this.selectedEntry && this.m_ShowSelectedItem;
            if(aEntryClip.selected)
            {
               this.m_SelectedClip = aEntryClip;
            }
            try
            {
               aEntryClip.SetEntryText(aEntryData,this.m_TextBehavior);
            }
            catch(e:Error)
            {
               trace("BCGridList::populateEntryClip -- SetEntryText error: " + e.getStackTrace());
            }
         }
      }
      
      private function calculateListScrollMax() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(this.m_ScrollVertical)
         {
            this.m_ColScrollPosMax = 0;
            _loc1_ = Math.ceil(this.m_Entries.length / this.m_MaxCols);
            this.m_RowScrollPosMax = _loc1_ - this.m_MaxRows;
            if(this.ScrollVert_mc != null)
            {
               this.ScrollVert_mc.dispatchOnValueChange = false;
               this.ScrollVert_mc.minValue = 0;
               this.ScrollVert_mc.maxValue = this.m_RowScrollPosMax;
               this.ScrollVert_mc.dispatchOnValueChange = true;
            }
         }
         else
         {
            this.m_RowScrollPosMax = 0;
            _loc2_ = Math.ceil(this.m_Entries.length / this.m_MaxRows);
            this.m_ColScrollPosMax = _loc2_ - this.m_MaxCols;
            if(this.ScrollHoriz_mc != null)
            {
               this.ScrollHoriz_mc.dispatchOnValueChange = false;
               this.ScrollHoriz_mc.minValue = 0;
               this.ScrollHoriz_mc.maxValue = this.m_ColScrollPosMax;
               this.ScrollHoriz_mc.dispatchOnValueChange = true;
            }
         }
         this.m_NeedRecalculateScrollMax = false;
         this.m_NeedRedraw = true;
      }
      
      public function clearList() : void
      {
         this.m_Entries.splice(0,this.m_Entries.length);
      }
      
      private function getNewEntryClip() : BSScrollingListEntry
      {
         return new this.m_ListItemClass() as BSScrollingListEntry;
      }
      
      private function createEntryClip(param1:uint, param2:uint, param3:uint) : Boolean
      {
         var _loc4_:BSScrollingListEntry = this.getNewEntryClip();
         if(_loc4_ != null)
         {
            _loc4_.parentClip = this.parent as MovieClip;
            _loc4_.clipIndex = param1;
            _loc4_.clipRow = param2;
            _loc4_.clipCol = param3;
            _loc4_.addEventListener(MouseEvent.MOUSE_OVER,this.onItemMouseOver);
            _loc4_.addEventListener(MouseEvent.CLICK,this.onItemClick);
            if(this.m_EntriesLayeredInOrder)
            {
               this.EntryHolder_mc.addChildAt(_loc4_,0);
            }
            else
            {
               this.EntryHolder_mc.addChild(_loc4_);
            }
            this.m_ClipVector.push(_loc4_);
            return true;
         }
         trace("BCGridList::createEntryClip -- m_ListItemClass is invalid or does not derive from BSScrollingListEntry.");
         return false;
      }
      
      private function createEntryClips() : void
      {
         var _loc4_:BSScrollingListEntry = null;
         while(this.EntryHolder_mc.numChildren > 0)
         {
            _loc4_ = this.getClipByIndex(0);
            _loc4_.Dtor();
            this.EntryHolder_mc.removeChildAt(0);
         }
         this.m_ClipVector = new Vector.<BSScrollingListEntry>();
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this.m_ScrollVertical)
         {
            _loc2_ = 0;
            while(_loc2_ < this.m_MaxRows)
            {
               _loc3_ = 0;
               while(_loc3_ < this.m_MaxCols)
               {
                  if(this.createEntryClip(_loc1_,_loc2_,_loc3_))
                  {
                     _loc1_++;
                  }
                  _loc3_++;
               }
               _loc2_++;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < this.m_MaxCols)
            {
               _loc2_ = 0;
               while(_loc2_ < this.m_MaxRows)
               {
                  if(this.createEntryClip(_loc1_,_loc2_,_loc3_))
                  {
                     _loc1_++;
                  }
                  _loc2_++;
               }
               _loc3_++;
            }
         }
         this.m_MaxDisplayedItems = _loc1_;
         this.m_NeedRecreateClips = false;
      }
      
      public function getClipByIndex(param1:uint) : BSScrollingListEntry
      {
         return param1 < this.EntryHolder_mc.numChildren ? this.m_ClipVector[param1] as BSScrollingListEntry : null;
      }
      
      private function updateScrollIndicators() : void
      {
         if(this.ScrollUp_mc != null)
         {
            this.ScrollUp_mc.visible = this.m_ScrollVertical && this.m_RowScrollPos > 0;
         }
         if(this.ScrollDown_mc != null)
         {
            this.ScrollDown_mc.visible = this.m_ScrollVertical && this.m_RowScrollPos < this.m_RowScrollPosMax;
         }
         if(this.ScrollLeft_mc != null)
         {
            this.ScrollLeft_mc.visible = !this.m_ScrollVertical && this.m_ColScrollPos > 0;
         }
         if(this.ScrollRight_mc != null)
         {
            this.ScrollRight_mc.visible = !this.m_ScrollVertical && this.m_ColScrollPos < this.m_ColScrollPosMax;
         }
         if(this.ScrollVert_mc != null)
         {
            if(this.m_ScrollVertical && this.m_RowScrollPosMax > 0)
            {
               if(this.m_NeedSliderUpdate)
               {
                  this.ScrollVert_mc.doSetValue(this.m_RowScrollPos,false);
               }
               this.ScrollVert_mc.visible = true;
            }
            else
            {
               this.ScrollVert_mc.visible = false;
            }
         }
         if(this.ScrollHoriz_mc != null)
         {
            if(!this.m_ScrollVertical && this.m_ColScrollPosMax > 0)
            {
               if(this.m_NeedSliderUpdate)
               {
                  this.ScrollHoriz_mc.doSetValue(this.m_ColScrollPos,false);
               }
               this.ScrollHoriz_mc.visible = true;
            }
            else
            {
               this.ScrollHoriz_mc.visible = false;
            }
         }
         this.m_NeedSliderUpdate = false;
      }
      
      private function selectItemUnderMouse() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:BSScrollingListEntry = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Point = null;
         if(!this.m_DisableSelection && !this.m_DisableInput && this.m_uiController == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
         {
            this.m_QueueSelectUnderMouse = false;
            _loc1_ = 0;
            while(_loc1_ < this.m_MaxDisplayedItems)
            {
               _loc2_ = this.m_ClipVector[_loc1_];
               _loc3_ = _loc2_ as MovieClip;
               if(_loc2_.HitTarget_mc != null)
               {
                  _loc3_ = _loc2_.HitTarget_mc;
               }
               else if(_loc2_.Sizer_mc != null)
               {
                  _loc3_ = _loc2_.Sizer_mc;
               }
               _loc4_ = localToGlobal(new Point(mouseX,mouseY));
               if(_loc3_.hitTestPoint(_loc4_.x,_loc4_.y,false))
               {
                  this.selectedIndex = this.m_ListStartIndex + _loc1_;
               }
               _loc1_++;
            }
         }
      }
      
      protected function redrawList() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:uint = 0;
         var _loc12_:BSScrollingListEntry = null;
         this.m_DisplayWidth = 0;
         this.m_DisplayHeight = 0;
         this.m_DisplayedItemCount = 0;
         this.m_SelectedClip = null;
         if(this.m_MaxDisplayedItems > 0)
         {
            _loc1_ = this.m_ListStartIndex;
            _loc2_ = this.m_Entries.length;
            _loc3_ = 0;
            _loc6_ = 0;
            _loc7_ = 0;
            _loc8_ = 0;
            _loc9_ = 0;
            _loc10_ = 0;
            _loc11_ = 0;
            while(_loc11_ < this.m_MaxDisplayedItems)
            {
               _loc12_ = this.m_ClipVector[_loc11_];
               if(_loc12_ != null)
               {
                  if(_loc11_ + _loc1_ < _loc2_)
                  {
                     _loc12_.itemIndex = _loc11_ + _loc1_;
                     this.populateEntryClip(_loc12_,this.m_Entries[_loc11_ + _loc1_]);
                     ++this.m_DisplayedItemCount;
                     if(_loc12_.Sizer_mc != null)
                     {
                        _loc4_ = _loc12_.Sizer_mc.width;
                        _loc5_ = _loc12_.Sizer_mc.height;
                     }
                     else
                     {
                        _loc4_ = _loc12_.width;
                        _loc5_ = _loc12_.height;
                     }
                     _loc12_.visible = true;
                     if(this.useVariableWidth)
                     {
                        _loc12_.x = _loc12_.clipCol != 0 ? _loc10_ : 0;
                     }
                     else
                     {
                        _loc12_.x = _loc4_ * _loc12_.clipCol;
                     }
                     _loc12_.y = _loc5_ * _loc12_.clipRow;
                     _loc8_ = Math.max(_loc8_,_loc12_.x + _loc4_);
                     _loc9_ = Math.max(_loc9_,_loc12_.y + _loc5_);
                  }
                  else
                  {
                     _loc12_.visible = false;
                     _loc12_.itemIndex = int.MAX_VALUE;
                  }
                  _loc10_ = _loc12_.x + _loc4_;
               }
               _loc11_++;
            }
            this.m_DisplayWidth = _loc8_;
            this.m_DisplayHeight = _loc9_;
            this.updateScrollIndicators();
         }
         else
         {
            trace("BCGridList::redrawList -- List configuration resulted in m_MaxDisplayedItems < 1 (unable to display any items) - " + this.name);
         }
         dispatchEvent(new Event(LIST_UPDATED,true,true));
         this.m_NeedRedraw = false;
      }
   }
}

