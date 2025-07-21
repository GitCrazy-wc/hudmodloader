package
{
   import flash.display.Sprite;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.Dictionary;
   
   public class HUDKeyboard extends Sprite
   {
      
      public static const BACKSPACE:String = "BS";
      
      public static const CLEAR:String = "CLR";
      
      public static const CANCEL:String = "×";
      
      public static const CONFIRM:String = "OK";
      
      private var buttonsList:Dictionary;
      
      private var keyboardLanguage:String = "en";
      
      private var selected:int = 0;
      
      private const rows:int = 6;
      
      private const columns:int = 10;
      
      private const size:int = 30;
      
      public function HUDKeyboard(lang:String = "en")
      {
         super();
         this.keyboardLanguage = lang;
         buttonsList = new Dictionary();
         populateButtons();
      }
      
      public function setLanguage(lang:String) : *
      {
         var button:HUDButton = null;
         if(lang == "ru")
         {
            this.keyboardLanguage = "ru";
         }
         else
         {
            this.keyboardLanguage = "en";
         }
         for each(button in buttonsList)
         {
            removeChild(button);
         }
         buttonsList = new Dictionary();
         this.populateButtons();
      }
      
      public function setColors(textColor:String, bgColor:String, bgAlpha:Number, selectColor:String, selectBGColor:String) : *
      {
         var button:HUDButton = null;
         for each(button in buttonsList)
         {
            button.setColors(textColor,bgColor,bgAlpha,selectColor,selectBGColor);
         }
      }
      
      private function populateButtons() : *
      {
         var i:int = 0;
         var bIndex:int = 0;
         var charButtons:String = "0123456789!?.,:()-+=ABCDEFGHIJKLMNOPQRSTUVWXYZ&\'\"_";
         var endButtons:Array = new Array(CONFIRM,CANCEL,CLEAR,BACKSPACE);
         if(this.keyboardLanguage == "ru")
         {
            charButtons = "0123456789!?.,:()-+=АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ\'\"_";
            endButtons = new Array(CONFIRM,CANCEL,CLEAR,BACKSPACE);
         }
         while(i < charButtons.length)
         {
            var bKey:String = String(i);
            buttonsList[bKey] = new HUDButton(this.size,this.size);
            buttonsList[bKey].padding = 0;
            buttonsList[bKey].x = i % this.columns * this.size;
            buttonsList[bKey].y = int(i / this.columns) * this.size;
            buttonsList[bKey].text = charButtons.charAt(i);
            addChild(buttonsList[bKey]);
            i++;
         }
         i = 0;
         while(i < endButtons.length)
         {
            bIndex = this.rows * this.columns - (i + 1);
            bKey = String(bIndex);
            buttonsList[bKey] = new HUDButton(this.size,this.size);
            buttonsList[bKey].padding = 0;
            buttonsList[bKey].x = bIndex % this.columns * this.size;
            buttonsList[bKey].y = int(bIndex / this.columns) * this.size;
            buttonsList[bKey].text = endButtons[i];
            addChild(buttonsList[bKey]);
            i++;
         }
         buttonsList["0"].isSelected = true;
      }
      
      public function moveUp() : *
      {
         var previous:int = this.selected;
         do
         {
            if(this.selected < 0)
            {
               this.selected += this.rows * this.columns;
            }
            else
            {
               this.selected -= this.columns;
            }
         }
         while(!buttonsList.hasOwnProperty(String(this.selected)));
         
         buttonsList[String(previous)].isSelected = false;
         buttonsList[String(this.selected)].isSelected = true;
      }
      
      public function moveDown() : *
      {
         var previous:int = this.selected;
         do
         {
            if(this.selected >= this.rows * this.columns)
            {
               this.selected -= this.rows * this.columns;
            }
            else
            {
               this.selected += this.columns;
            }
         }
         while(!buttonsList.hasOwnProperty(String(this.selected)));
         
         buttonsList[String(previous)].isSelected = false;
         buttonsList[String(this.selected)].isSelected = true;
      }
      
      public function moveLeft() : *
      {
         var previous:int = this.selected;
         do
         {
            if(this.selected % this.columns == 0)
            {
               this.selected += this.columns - 1;
            }
            else
            {
               --this.selected;
            }
         }
         while(!buttonsList.hasOwnProperty(String(this.selected)));
         
         buttonsList[String(previous)].isSelected = false;
         buttonsList[String(this.selected)].isSelected = true;
      }
      
      public function moveRight() : *
      {
         var previous:int = this.selected;
         do
         {
            if(this.selected % this.columns == this.columns - 1)
            {
               this.selected -= this.columns - 1;
            }
            else
            {
               ++this.selected;
            }
         }
         while(!buttonsList.hasOwnProperty(String(this.selected)));
         
         buttonsList[String(previous)].isSelected = false;
         buttonsList[String(this.selected)].isSelected = true;
      }
      
      public function getSelection() : String
      {
         return buttonsList[String(this.selected)].text;
      }
      
      public function isPushed() : Boolean
      {
         return buttonsList[String(this.selected)].isPushed;
      }
      
      public function pushButton() : void
      {
         buttonsList[String(this.selected)].isPushed = true;
      }
      
      public function unpushButton() : void
      {
         buttonsList[String(this.selected)].isPushed = false;
      }
   }
}

