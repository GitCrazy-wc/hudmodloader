package
{
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   
   public class HUDToolsMenu extends Sprite
   {
      
      private static const HUDTOOLS:String = "HUDTools";
      
      private var buttonList:Array;
      
      private var menuList:Array;
      
      private var submenuList:Dictionary;
      
      private var _direction:String = "up";
      
      private var _menuId:String;
      
      private var _selected:int = -1;
      
      private var _inSubmenu:Boolean = false;
      
      private var _startPos:int = 0;
      
      private var _startOffset:int = 0;
      
      public function HUDToolsMenu(dir:String = "", id:String = "", start:int = 0)
      {
         if(id.length == 0)
         {
            id = HUDTOOLS;
         }
         if(dir.length > 0)
         {
            if(dir == "up" || dir == "down")
            {
               this._direction = dir;
            }
         }
         super();
         this._menuId = id;
         this._startPos = start;
         this.y = this._startPos * 30 * (this._direction == "up" ? -1 : 1);
         this.buttonList = new Array();
         this.menuList = new Array();
         this.submenuList = new Dictionary();
         if(this._menuId == HUDTOOLS)
         {
            addButton(HUDTOOLS,false);
         }
         addButton("Loading...");
      }
      
      public function getSelectedModName() : *
      {
         if(this._selected >= 0 && this._selected < this.menuList.length)
         {
            return this.menuList[this._selected];
         }
      }
      
      public function updatePos(start:int) : *
      {
         this._startPos = start;
         this.y = this._startPos * 30 * (this._direction == "up" ? -1 : 1);
      }
      
      public function displayMenu() : *
      {
      }
      
      private function addButton(text:String, flag:Boolean = true) : HUDButton
      {
         var butY:Number = 0;
         var adjust:int = 0;
         var button:HUDButton = new HUDButton();
         button.text = text;
         if(flag)
         {
            adjust = 1;
         }
         if(_direction == "up")
         {
            butY = (buttonList.length + adjust) * -30;
         }
         else
         {
            butY = (buttonList.length + adjust) * 30;
         }
         if(flag)
         {
            buttonList.push(button);
         }
         button.x = 0;
         button.y = butY;
         addChild(button);
         return button;
      }
      
      private function removeButton(index:int) : *
      {
         if(buttonList.length > index)
         {
            var button:HUDButton = buttonList[index];
            removeChild(button);
            buttonList.splice(index,1);
         }
      }
      
      public function addItems(modName:String, parentMenu:String, buttonsToParse:String) : *
      {
         var menu:HUDToolsMenu;
         var menuName:String;
         var button:HUDButton;
         var buttonString:String;
         var buttonArray:Array;
         var buttonConfig:Array;
         var buttonId:String;
         var buttonName:String;
         var buttonEnabled:Boolean;
         var buttonSubmenu:Boolean;
         var buttonTimeout:Number;
         var buttonIndex:int;
         var calcWindowIntOffset:int;
         var calcWindowNumOffset:Number;
         var index:int;
         var newMenuFlag:Boolean = false;
         try
         {
            menu = null;
            button = null;
            buttonString = "";
            if(this._menuId == HUDTOOLS)
            {
               if(this.menuList.length == 0 && this.buttonList.length > 0)
               {
                  removeButton(0);
               }
               if(this.menuList.indexOf(modName) < 0)
               {
                  this.menuList.push(modName);
                  button = addButton(modName);
                  menu = new HUDToolsMenu(this._direction,modName,this.menuList.length - 1);
                  menu.x = button.x + button.width;
                  submenuList[modName] = menu;
                  menu.visible = false;
                  addChild(menu);
               }
               else
               {
                  menu = submenuList[modName];
               }
               menu.addItems(modName,parentMenu,buttonsToParse);
            }
            else if(parentMenu != this._menuId)
            {
               if(this.menuList.indexOf(parentMenu) >= 0)
               {
                  submenuList[parentMenu].addItems(modName,parentMenu,buttonsToParse);
               }
            }
            else
            {
               if(this.menuList.length == 0)
               {
                  newMenuFlag = true;
                  if(this.buttonList.length > 0)
                  {
                     removeButton(0);
                  }
               }
               for each(button in this.buttonList)
               {
                  button.isDisabled = true;
               }
               buttonArray = buttonsToParse.split(";");
               for each(buttonString in buttonArray)
               {
                  if(buttonString.length > 0)
                  {
                     buttonConfig = buttonString.split(",");
                     if(buttonConfig.length >= 5)
                     {
                        buttonId = buttonConfig[0];
                        buttonName = buttonConfig[1];
                        buttonEnabled = buttonConfig[2] == "Y";
                        buttonSubmenu = buttonConfig[3] == "Y";
                        buttonTimeout = Number(buttonConfig[4]);
                        if(buttonId.length > 0 && buttonName.length > 0)
                        {
                           buttonIndex = int(this.menuList.indexOf(buttonId));
                           if(buttonIndex < 0)
                           {
                              this.menuList.push(buttonId);
                              button = addButton(buttonName);
                              button.setInfo(buttonId,buttonEnabled,buttonSubmenu,buttonTimeout);
                              if(buttonSubmenu)
                              {
                                 menu = new HUDToolsMenu(this._direction,buttonId,this.menuList.length + this._startPos - this.startOffset);
                                 menu.x = button.x + button.width;
                                 this.submenuList[buttonId] = menu;
                                 menu.visible = false;
                                 addChild(menu);
                              }
                           }
                           else
                           {
                              button = this.buttonList[buttonIndex];
                              button.isDisabled = !buttonEnabled;
                           }
                        }
                     }
                  }
               }
               if(newMenuFlag)
               {
                  this._startOffset = int(this.menuList.length / 2);
                  if(this._startOffset > this._startPos)
                  {
                     this._startOffset = this._startPos;
                  }
                  calcWindowIntOffset = this._startPos - int(this.menuList.length / 2);
                  if(calcWindowIntOffset < 0)
                  {
                     calcWindowIntOffset = 0;
                  }
                  calcWindowNumOffset = calcWindowIntOffset * 30 * (this._direction == "up" ? -1 : 1);
                  this.y = calcWindowNumOffset;
               }
               index = 0;
               while(index < this.menuList.length)
               {
                  menuName = this.menuList[index];
                  if(this.submenuList.hasOwnProperty(menuName))
                  {
                     this.submenuList[menuName].updatePos(index + this._startPos - this._startOffset);
                  }
                  index++;
               }
               if(this._selected >= this.buttonList.length)
               {
                  this._selected = -1;
               }
               if(this.menuList.length == 0)
               {
                  addButton("No Options");
               }
            }
         }
         catch(e:Error)
         {
            this.displayError("HUDToolsMenu.addItems error: " + e.message);
         }
      }
      
      public function moveStart() : String
      {
         var result:String = "";
         var menuName:String = "";
         if(this.menuList.length == 0)
         {
            return null;
         }
         if(this._selected < 0)
         {
            this._selected = this._startOffset;
         }
         else if(this._selected > this.buttonList.length)
         {
            this._selected = this._startOffset;
         }
         if(this._selected > this.buttonList.length)
         {
            this._selected = 0;
         }
         buttonList[this._selected].isSelected = true;
         menuName = this.menuList[this._selected];
         if(this.submenuList.hasOwnProperty(menuName))
         {
            this.submenuList[menuName].visible = true;
            result = menuName;
         }
         return result;
      }
      
      public function moveUp() : String
      {
         var result:String = "";
         var menuName:String = "";
         var previous:int = this._selected;
         if(this.menuList.length == 0)
         {
            return null;
         }
         if(this._inSubmenu)
         {
            if(this._selected >= 0 && this._selected < this.menuList.length)
            {
               menuName = this.menuList[this._selected];
               if(this.submenuList.hasOwnProperty(menuName))
               {
                  return this.submenuList[menuName].moveUp();
               }
            }
         }
         else
         {
            if(this._selected < 0)
            {
               this._selected = 0;
            }
            else
            {
               ++this._selected;
               if(this._selected >= this.buttonList.length)
               {
                  this._selected = 0;
               }
            }
            if(previous >= 0 && previous < this.buttonList.length)
            {
               this.buttonList[previous].isSelected = false;
               menuName = this.menuList[previous];
               if(this.submenuList.hasOwnProperty(menuName))
               {
                  this.submenuList[menuName].visible = false;
               }
            }
            if(this._selected >= 0 && this._selected < this.buttonList.length)
            {
               this.buttonList[this._selected].isSelected = true;
               menuName = this.menuList[this._selected];
               if(this.submenuList.hasOwnProperty(menuName))
               {
                  this.submenuList[menuName].visible = true;
                  result = menuName;
               }
            }
         }
         return result;
      }
      
      public function moveDown() : String
      {
         var result:String = "";
         var menuName:String = "";
         var previous:int = this._selected;
         if(this.menuList.length == 0)
         {
            return null;
         }
         if(this._inSubmenu)
         {
            if(this._selected >= 0 && this._selected < this.menuList.length)
            {
               menuName = this.menuList[this._selected];
               if(this.submenuList.hasOwnProperty(menuName))
               {
                  return this.submenuList[menuName].moveDown();
               }
            }
         }
         else
         {
            if(this._selected < 0)
            {
               this._selected = this.buttonList.length - 1;
            }
            else
            {
               --this._selected;
               if(this._selected < 0)
               {
                  this._selected = this.buttonList.length - 1;
               }
            }
            if(previous >= 0 && previous < this.buttonList.length)
            {
               this.buttonList[previous].isSelected = false;
               menuName = this.menuList[previous];
               if(this.submenuList.hasOwnProperty(menuName))
               {
                  this.submenuList[menuName].visible = false;
               }
            }
            if(this._selected >= 0 && this._selected < this.buttonList.length)
            {
               this.buttonList[this._selected].isSelected = true;
               menuName = this.menuList[this._selected];
               if(this.submenuList.hasOwnProperty(menuName))
               {
                  this.submenuList[menuName].visible = true;
                  result = menuName;
               }
            }
         }
         return result;
      }
      
      public function moveRight() : String
      {
         var result:String = "";
         var menuName:String = "";
         var previous:int = this._selected;
         if(this.menuList.length == 0)
         {
            return null;
         }
         if(this._inSubmenu)
         {
            if(this._selected >= 0 && this._selected < this.menuList.length)
            {
               menuName = this.menuList[this._selected];
               if(this.submenuList.hasOwnProperty(menuName))
               {
                  return this.submenuList[menuName].moveRight();
               }
            }
         }
         else if(this._selected >= 0 && this._selected < this.buttonList.length)
         {
            menuName = this.menuList[this._selected];
            if(this.submenuList.hasOwnProperty(menuName))
            {
               result = this.submenuList[menuName].moveStart();
               if(result != null)
               {
                  this._inSubmenu = true;
                  if(previous >= 0 && previous < this.buttonList.length)
                  {
                     this.buttonList[previous].isSelected = false;
                     this.buttonList[previous].isPushed = true;
                  }
               }
            }
         }
         return result;
      }
      
      public function moveLeft() : String
      {
         var result:String = "";
         var menuName:String = "";
         var previous:int = this._selected;
         if(this.menuList.length == 0)
         {
            return null;
         }
         if(this._inSubmenu)
         {
            if(this._selected >= 0 && this._selected < this.menuList.length)
            {
               menuName = this.menuList[this._selected];
               if(this.submenuList.hasOwnProperty(menuName))
               {
                  result = this.submenuList[menuName].moveLeft();
                  if(result != null && result == menuName)
                  {
                     this._inSubmenu = false;
                     this.buttonList[this._selected].isSelected = true;
                     this.buttonList[this._selected].isPushed = false;
                  }
               }
            }
         }
         else if(this._menuId != HUDTOOLS)
         {
            if(previous >= 0 && previous < this.buttonList.length)
            {
               this.buttonList[previous].isSelected = false;
               menuName = this.menuList[previous];
               if(this.submenuList.hasOwnProperty(menuName))
               {
                  this.submenuList[menuName].visible = false;
               }
               result = this._menuId;
            }
         }
         return result;
      }
      
      public function select() : String
      {
         var result:String = "";
         var menuName:String = "";
         if(this.menuList.length == 0)
         {
            return null;
         }
         if(this._inSubmenu)
         {
            if(this._selected >= 0 && this._selected < this.menuList.length)
            {
               menuName = this.menuList[this._selected];
               if(this.submenuList.hasOwnProperty(menuName))
               {
                  result = this.submenuList[menuName].select();
               }
            }
         }
         else if(this._menuId != HUDTOOLS)
         {
            if(this._selected >= 0 && this._selected < this.buttonList.length)
            {
               if(this.buttonList[this._selected].click())
               {
                  result = this.menuList[this._selected];
               }
            }
         }
         return result;
      }
      
      private function displayError(errorString:String) : void
      {
         dispatchEvent(new HUDModError(errorString));
      }
   }
}

