package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Data.UIDataFromClient;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.PlatformChangeEvent;
   import Shared.GlobalFunc;
   import Shared.HUDModes;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.*;
   import flash.filters.DropShadowFilter;
   import flash.net.*;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import scaleform.gfx.TextFieldEx;
   
   public class HUDTools extends MovieClip
   {
      
      private static const ON_STARTEDITTEXT:String = "ControlMap::StartEditText";
      
      private static const ON_ENDEDITTEXT:String = "ControlMap::EndEditText";
      
      private var topLevel:* = null;
      
      private var msgPayload:UIDataFromClient = null;
      
      private var entry_tf:TextField;
      
      private var controller_tf:TextField;
      
      private var entryFormats:Dictionary = new Dictionary();
      
      private var entryOSKFormats:Dictionary = new Dictionary();
      
      private var entryLanguage:Dictionary = new Dictionary();
      
      private var entryMode:Boolean = false;
      
      private var entryLang:String = "en";
      
      private var entry_bg:Shape;
      
      private var entry_mod:String;
      
      private var entry_keyboard:HUDKeyboard;
      
      private var debug_tf:TextField;
      
      private var debugLevel:int = 0;
      
      private var registeredMods:Array = new Array();
      
      private var registeredModsHUDModes:Array = new Array();
      
      private var queuedMods:Array = new Array();
      
      private var queuedModsMessages:Dictionary = new Dictionary();
      
      private var currentHUDMode:String = "";
      
      private var menuFormats:Dictionary = new Dictionary();
      
      private var menuMode:Boolean = false;
      
      private var menu_mod:String;
      
      private var menu_obj:HUDToolsMenu;
      
      private var sharedTools:SharedHUDTools;
      
      private var ctrlDown:Boolean = false;
      
      private var uiController:* = 0;
      
      private var menuTimer:Timer;
      
      private var menuTimerDelay:Number = 2000;
      
      public function HUDTools()
      {
         super();
         this.sharedTools = new SharedHUDTools(SharedHUDTools.HUDTOOLS);
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
      }
      
      private function addedToStageHandler(param1:Event) : *
      {
         this.topLevel = stage.getChildAt(0);
         if(this.topLevel != null && getQualifiedClassName(this.topLevel) == "HUDMenu")
         {
            this.initialize();
         }
         else
         {
            trace("ERROR: Not injected into HUDMenu.");
         }
      }
      
      private function initialize() : void
      {
         var newMsgString:String;
         this.debug_tf = new TextField();
         this.entry_tf = new TextField();
         this.controller_tf = new TextField();
         this.entry_bg = new Shape();
         GlobalFunc.SetText(this.debug_tf,"",false);
         this.formatDebugField(this.debug_tf);
         this.entry_tf.addEventListener(KeyboardEvent.KEY_DOWN,this.textEditKeyDown);
         this.entry_tf.addEventListener(KeyboardEvent.KEY_UP,this.textEditKeyUp);
         this.controller_tf.addEventListener(KeyboardEvent.KEY_DOWN,this.textControllerKeyDown);
         this.controller_tf.addEventListener(KeyboardEvent.KEY_UP,this.textControllerKeyUp);
         if(this.debugLevel > 0)
         {
            this.displayError("HUDTools debug");
         }
         try
         {
            this.menuTimer = new Timer(menuTimerDelay,1);
            this.menuTimer.addEventListener(TimerEvent.TIMER_COMPLETE,menuTimerCompleteHandler);
            stage.addEventListener(HUDModError.EVENT,this.onHUDModError);
            stage.addEventListener(HUDModUserEvent.EVENT,this.onHUDModUserEvent);
            stage.addEventListener(PlatformChangeEvent.PLATFORM_CHANGE,this.onPlatformChange);
            this.msgPayload = BSUIDataManager.GetDataFromClient("HUDMessageProvider");
            this.SubscribeListener("MessageEvents",this.onMessageEvent);
            this.SubscribeListener("HUDModeData",this.hudModeUpdate);
            newMsgString = this.sharedTools.formatMsg(SharedHUDTools.BROADCAST,SharedHUDTools.READY,[]);
            this.sharedTools.dispatchMessage(newMsgString);
            this.menuFormats[SharedHUDTools.HUDTOOLS] = "50,-100";
         }
         catch(e:Error)
         {
            this.displayError("HUDTools.initialize error: " + e.message);
         }
      }
      
      private function onPlatformChange(aEvent:PlatformChangeEvent) : void
      {
         if(aEvent != null && aEvent.hasOwnProperty("uiController"))
         {
            this.uiController = aEvent.uiController;
         }
         if(this.entryMode)
         {
            this.endTextEdit(false);
         }
         if(this.menuMode)
         {
            this.endMenu();
         }
      }
      
      private function isInputKeyboard() : Boolean
      {
         if(this.uiController == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
         {
            return true;
         }
         return false;
      }
      
      public function onMessageEvent(msgEvent:FromClientDataEvent) : void
      {
         var eventData:*;
         var msgIndex:int;
         var msgData:*;
         var msgCounter:int;
         var sendMod:String;
         var recMod:String;
         var msgType:String;
         var newMsgString:String;
         var eventIndex:int = 0;
         var modIndex:int = 0;
         while(eventIndex < msgEvent.data.events.length)
         {
            try
            {
               eventData = msgEvent.data.events[eventIndex];
               switch(eventData.eventType)
               {
                  case "new":
                     msgIndex = int(eventData.eventIndex);
                     msgData = this.msgPayload.data.messages[msgIndex];
                     if(msgData == null)
                     {
                        break;
                     }
                     if(msgData.messageText.substring(0,2) == SharedHUDTools.PREFIX)
                     {
                        if(debugLevel >= 2)
                        {
                           this.displayError("DEBUG MSG: " + msgData.messageText);
                        }
                        msgArray = msgData.messageText.substring(2).split("|");
                        if(msgArray.length >= 4)
                        {
                           sendMod = msgArray[0];
                           msgCounter = int(msgArray[1]);
                           recMod = msgArray[2];
                           msgType = msgArray[3];
                           if(recMod == SharedHUDTools.HUDTOOLS)
                           {
                              this.sharedTools.startQueue();
                              if(msgType == SharedHUDTools.REGISTER && msgArray.length >= 5)
                              {
                                 if(this.queuedMods.indexOf(sendMod) >= 0)
                                 {
                                    modIndex = int(this.queuedMods.indexOf(sendMod));
                                    this.queuedMods.splice(modIndex,1);
                                    this.sendQueue(this.queuedModsMessages[sendMod]);
                                    delete this.queuedModsMessages[sendMod];
                                 }
                                 if(registeredMods.indexOf(sendMod) < 0)
                                 {
                                    this.registeredMods.push(sendMod);
                                    this.registeredModsHUDModes.push(msgArray[4]);
                                 }
                              }
                              else if(msgType == SharedHUDTools.UNLOAD)
                              {
                                 if(msgArray.length >= 5)
                                 {
                                    this.switchToQueue(msgArray[4]);
                                 }
                              }
                              else if(msgType == SharedHUDTools.FORMATTEXTEDIT && msgArray.length >= 5)
                              {
                                 entryFormats[sendMod] = msgArray[4];
                              }
                              else if(msgType == SharedHUDTools.FORMATONSCREENKEYBOARD && msgArray.length >= 5)
                              {
                                 entryOSKFormats[sendMod] = msgArray[4];
                              }
                              else if(msgType == SharedHUDTools.LANGUAGEONSCREENKEYBOARD && msgArray.length >= 5)
                              {
                                 entryLanguage[sendMod] = msgArray[4];
                              }
                              else if(msgType == SharedHUDTools.TEXTEDIT && msgArray.length >= 5)
                              {
                                 if(!this.entryMode && !this.menuMode && entryFormats.hasOwnProperty(sendMod) && entryOSKFormats.hasOwnProperty(sendMod))
                                 {
                                    this.entry_mod = sendMod;
                                    if(this.startTextEdit(msgArray[4]))
                                    {
                                       this.entryMode = true;
                                    }
                                    else
                                    {
                                       newMsgString = this.sharedTools.formatMsg(sendMod,SharedHUDTools.ERROR,[SharedHUDTools.TEXTEDIT]);
                                       this.sharedTools.dispatchMessage(newMsgString);
                                    }
                                 }
                                 else
                                 {
                                    newMsgString = this.sharedTools.formatMsg(sendMod,SharedHUDTools.ERROR,[SharedHUDTools.TEXTEDIT]);
                                    this.sharedTools.dispatchMessage(newMsgString);
                                 }
                              }
                              else if(msgType == SharedHUDTools.STOPTEXTEDIT)
                              {
                                 if(this.entryMode)
                                 {
                                    this.endTextEdit(false);
                                 }
                              }
                              else if(msgType == SharedHUDTools.FORMATMENU && msgArray.length >= 5)
                              {
                                 menuFormats[sendMod] = msgArray[4];
                              }
                              else if(msgType == SharedHUDTools.MENU)
                              {
                                 if(!this.entryMode && !this.menuMode && menuFormats.hasOwnProperty(sendMod))
                                 {
                                    this.menu_mod = sendMod;
                                    if(this.startMenu())
                                    {
                                       this.menuMode = true;
                                    }
                                    else
                                    {
                                       newMsgString = this.sharedTools.formatMsg(sendMod,SharedHUDTools.ERROR,[SharedHUDTools.MENU]);
                                       this.sharedTools.dispatchMessage(newMsgString);
                                    }
                                 }
                                 else
                                 {
                                    newMsgString = this.sharedTools.formatMsg(sendMod,SharedHUDTools.ERROR,[SharedHUDTools.MENU]);
                                    this.sharedTools.dispatchMessage(newMsgString);
                                 }
                              }
                              else if(msgType == SharedHUDTools.STOPMENU)
                              {
                                 if(this.menuMode)
                                 {
                                    this.endMenu();
                                 }
                              }
                              else if(msgType == SharedHUDTools.BUILDMENU && msgArray.length >= 6)
                              {
                                 if(menu_obj != null)
                                 {
                                    menu_obj.addItems(sendMod,msgArray[4],msgArray[5]);
                                 }
                              }
                              else if(msgType == SharedHUDTools.ERRORMESSAGE && msgArray.length >= 5)
                              {
                                 this.displayError(msgArray[4]);
                              }
                           }
                           else if(msgType == SharedHUDTools.MESSAGE)
                           {
                              if(registeredMods.indexOf(recMod) < 0)
                              {
                                 if(msgArray.length >= 6)
                                 {
                                    if(msgArray[5] == "true")
                                    {
                                       if(this.queuedMods.indexOf(recMod) < 0)
                                       {
                                          this.queuedMods.push(recMod);
                                          this.queuedModsMessages[recMod] = new Array();
                                       }
                                       this.queuedModsMessages[recMod].push(msgData.messageText);
                                    }
                                 }
                              }
                           }
                        }
                        eventData.eventType = "remove";
                     }
                     break;
               }
            }
            catch(e:Error)
            {
               this.displayError("HUDTools.onMessageEvent error: " + e.message);
            }
            eventIndex++;
         }
      }
      
      private function switchToQueue(modName:String) : void
      {
         var modIndex:int = int(this.registeredMods.indexOf(modName));
         if(modIndex >= 0)
         {
            if(this.queuedMods.indexOf(modName) < 0)
            {
               this.queuedMods.push(modName);
               this.queuedModsMessages[modName] = new Array();
            }
            this.registeredMods.splice(modIndex,1);
            this.registeredModsHUDModes.splice(modIndex,1);
         }
      }
      
      private function sendQueue(queue:Array) : void
      {
         var msg:String = "";
         for each(msg in queue)
         {
            this.sharedTools.dispatchMessage(msg);
         }
      }
      
      private function startMenu() : Boolean
      {
         var formatOptions:Array;
         var menuX:Number;
         var menuY:Number;
         var newMsgString:String;
         var menuDir:String = "";
         try
         {
            formatOptions = menuFormats[this.menu_mod].split(",");
            menuX = Number(formatOptions[0]);
            menuY = Number(formatOptions[1]);
            if(menuY < 0)
            {
               menuY = this.stage.stageHeight + menuY;
            }
            if(formatOptions.length >= 3)
            {
               menuDir = String(formatOptions[2]);
            }
            menu_obj = new HUDToolsMenu(menuDir);
            menu_obj.x = menuX;
            menu_obj.y = menuY;
            this.topLevel.addChild(this.menu_obj);
            initMenuTextfield();
            this.topLevel.addChild(this.controller_tf);
            this.topLevel.stage.focus = this.controller_tf;
            BSUIDataManager.dispatchEvent(new CustomEvent(ON_STARTEDITTEXT,{"tag":"Chat"}));
            newMsgString = this.sharedTools.formatMsg(SharedHUDTools.BROADCAST,SharedHUDTools.BUILDMENU,[]);
            this.sharedTools.dispatchMessage(newMsgString);
            return true;
         }
         catch(e:Error)
         {
            this.displayError("HUDTools.startMenu error: " + e.message);
            return false;
         }
      }
      
      private function endMenu() : void
      {
         var newMsgString:String;
         this.menuMode = false;
         try
         {
            this.controller_tf.text = "";
            this.topLevel.stage.focus = this.topLevel.stage;
            this.topLevel.removeChild(this.controller_tf);
            this.topLevel.removeChild(this.menu_obj);
            BSUIDataManager.dispatchEvent(new CustomEvent(ON_ENDEDITTEXT,{"tag":"Chat"}));
            if(this.menu_mod != SharedHUDTools.HUDTOOLS)
            {
               newMsgString = this.sharedTools.formatMsg(this.menu_mod,SharedHUDTools.MENU,[]);
               this.sharedTools.dispatchMessage(newMsgString);
            }
            else
            {
               newMsgString = this.sharedTools.formatMsg(SharedHUDTools.BROADCAST,SharedHUDTools.STOPMENU,[]);
               this.sharedTools.dispatchMessage(newMsgString);
            }
         }
         catch(e:Error)
         {
            this.displayError("HUDTools.endMenu error: " + e.message);
         }
      }
      
      internal function startTextEdit(textString:String) : Boolean
      {
         var formatOptions:Array;
         var formatOSKOptions:Array;
         var newMsgString:String;
         var textX:Number;
         var textY:Number;
         var textWidth:Number;
         var textHeight:Number;
         var oskX:Number;
         var oskY:Number;
         var textFont:String = "$MAIN_Font_Light";
         var textSize:Number = 20;
         var textColor:uint = SharedUtils.calcColor(255,255,255);
         var bgColor:uint = SharedUtils.calcColor(61,61,61);
         var bgAlpha:Number = 0.75;
         var oskColor:String = "";
         var oskBGColor:String = "";
         var oskBGAlpha:Number = -1;
         var oskSelect:String = "";
         var oskBGSelect:String = "";
         try
         {
            formatOptions = entryFormats[this.entry_mod].split(",");
            formatOSKOptions = entryOSKFormats[this.entry_mod].split(",");
            if(formatOptions.length >= 4 && formatOSKOptions.length >= 2)
            {
               textX = Number(formatOptions[0]);
               textY = Number(formatOptions[1]);
               textWidth = Number(formatOptions[2]);
               textHeight = Number(formatOptions[3]);
               if(formatOptions.length >= 5)
               {
                  textFont = String(formatOptions[4]);
               }
               if(formatOptions.length >= 6)
               {
                  textSize = Number(formatOptions[5]);
               }
               if(formatOptions.length >= 7)
               {
                  textColor = uint("0x" + formatOptions[6]);
               }
               if(formatOptions.length >= 8)
               {
                  bgColor = uint("0x" + formatOptions[7]);
               }
               if(formatOptions.length >= 9)
               {
                  bgAlpha = Number(formatOptions[8]);
               }
               this.initEntryTextfield(textX,textY,textWidth,textHeight,textFont,textSize,textColor);
               oskX = Number(formatOSKOptions[0]);
               oskY = Number(formatOSKOptions[1]);
               if(formatOSKOptions.length >= 3)
               {
                  oskColor = formatOSKOptions[2];
               }
               if(formatOSKOptions.length >= 4)
               {
                  oskBGColor = formatOSKOptions[3];
               }
               if(formatOSKOptions.length >= 5)
               {
                  oskBGAlpha = Number(formatOSKOptions[4]);
               }
               if(formatOSKOptions.length >= 6)
               {
                  oskSelect = formatOSKOptions[5];
               }
               if(formatOSKOptions.length >= 7)
               {
                  oskBGSelect = formatOSKOptions[6];
               }
               if(!this.isInputKeyboard())
               {
                  this.entry_keyboard = new HUDKeyboard();
                  if(this.entryLanguage.hasOwnProperty(this.entry_mod))
                  {
                     this.entry_keyboard.setLanguage(this.entryLanguage[this.entry_mod]);
                  }
                  this.entry_keyboard.x = oskX;
                  this.entry_keyboard.y = oskY;
                  this.entry_keyboard.setColors(oskColor,oskBGColor,oskBGAlpha,oskSelect,oskBGSelect);
                  this.topLevel.addChild(this.entry_keyboard);
               }
               this.entry_tf.border = false;
               this.entry_tf.text = textString;
               this.entry_tf.setSelection(textString.length,textString.length);
               this.entry_bg.alpha = bgAlpha;
               this.entry_bg.graphics.clear();
               this.entry_bg.graphics.beginFill(bgColor);
               this.entry_bg.graphics.drawRect(textX,textY,textWidth,textHeight);
               this.entry_bg.graphics.endFill();
               this.topLevel.addChild(this.entry_bg);
               this.topLevel.addChild(this.entry_tf);
               this.topLevel.addChild(this.controller_tf);
               if(this.isInputKeyboard())
               {
                  this.topLevel.stage.focus = this.entry_tf;
               }
               else
               {
                  this.topLevel.stage.focus = this.controller_tf;
               }
               BSUIDataManager.dispatchEvent(new CustomEvent(ON_STARTEDITTEXT,{"tag":"Chat"}));
               return true;
            }
            return false;
         }
         catch(e:Error)
         {
            this.displayError("HUDTools.startTextEdit error: " + e.message);
            return false;
         }
      }
      
      internal function endTextEdit(confirmFlag:Boolean) : *
      {
         var entryText:String;
         this.entryMode = false;
         try
         {
            entryText = this.entry_tf.text;
            this.entry_tf.border = false;
            this.entry_tf.text = "";
            this.controller_tf.text = "";
            this.topLevel.stage.focus = this.topLevel.stage;
            this.topLevel.removeChild(this.entry_tf);
            this.topLevel.removeChild(this.entry_bg);
            this.topLevel.removeChild(this.controller_tf);
            if(this.entry_keyboard != null)
            {
               this.topLevel.removeChild(this.entry_keyboard);
               this.entry_keyboard = null;
            }
            BSUIDataManager.dispatchEvent(new CustomEvent(ON_ENDEDITTEXT,{"tag":"Chat"}));
            if(confirmFlag)
            {
               newMsgString = sharedTools.formatMsg(this.entry_mod,SharedHUDTools.TEXTEDIT,[entryText]);
               this.sharedTools.dispatchMessage(newMsgString);
            }
            else
            {
               newMsgString = sharedTools.formatMsg(this.entry_mod,SharedHUDTools.TEXTEDIT,[]);
               this.sharedTools.dispatchMessage(newMsgString);
            }
         }
         catch(e:Error)
         {
            this.displayError("HUDTools.endTextEdit error: " + e.message);
         }
      }
      
      public function textEditKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.CONTROL || param1.keyCode == Keyboard.COMMAND)
         {
            this.ctrlDown = true;
         }
      }
      
      public function textEditKeyUp(param1:KeyboardEvent) : void
      {
         try
         {
            if(param1.keyCode == Keyboard.CONTROL || param1.keyCode == Keyboard.COMMAND)
            {
               this.ctrlDown = false;
            }
            else if(param1.keyCode == Keyboard.BACKSPACE && this.ctrlDown)
            {
               this.entry_tf.text = "";
            }
            else if(param1.keyCode == Keyboard.ESCAPE || param1.keyCode == Keyboard.TAB)
            {
               this.endTextEdit();
            }
            else if(param1.keyCode == Keyboard.ENTER)
            {
               this.endTextEdit(true);
            }
         }
         catch(e:Error)
         {
            this.displayError("HUDTools.textEditKeyUp error: " + e.message);
         }
      }
      
      public function textControllerKeyDown(param1:KeyboardEvent) : void
      {
      }
      
      public function textControllerKeyUp(param1:KeyboardEvent) : void
      {
         var result:String;
         var newMsgString:String;
         var modName:String;
         var text:String = "";
         var msgType:String = "";
         try
         {
            if(this.entryMode)
            {
               if(param1.keyCode == Keyboard.ESCAPE || param1.keyCode == Keyboard.TAB)
               {
                  this.endTextEdit();
               }
               else if(this.entry_keyboard != null)
               {
                  if(!this.entry_keyboard.isPushed())
                  {
                     if(param1.keyCode == Keyboard.LEFT)
                     {
                        this.entry_keyboard.moveLeft();
                     }
                     else if(param1.keyCode == Keyboard.RIGHT)
                     {
                        this.entry_keyboard.moveRight();
                     }
                     else if(param1.keyCode == Keyboard.UP)
                     {
                        this.entry_keyboard.moveUp();
                     }
                     else if(param1.keyCode == Keyboard.DOWN)
                     {
                        this.entry_keyboard.moveDown();
                     }
                     else if(param1.keyCode == Keyboard.ENTER)
                     {
                        text = this.entry_keyboard.getSelection();
                        if(text == HUDKeyboard.BACKSPACE)
                        {
                           if(this.entry_tf.text.length > 0)
                           {
                              this.entry_tf.text = this.entry_tf.text.substr(0,this.entry_tf.text.length - 1);
                           }
                        }
                        else if(text == HUDKeyboard.CLEAR)
                        {
                           this.entry_tf.text = "";
                        }
                        else if(text == HUDKeyboard.CANCEL)
                        {
                           this.endTextEdit();
                        }
                        else if(text == HUDKeyboard.CONFIRM)
                        {
                           this.endTextEdit(true);
                        }
                        else if(text == "_")
                        {
                           this.entry_tf.text += " ";
                        }
                        else
                        {
                           this.entry_tf.text += text;
                        }
                     }
                  }
               }
            }
            else if(this.menuMode)
            {
               if(param1.keyCode == Keyboard.ESCAPE || param1.keyCode == Keyboard.TAB)
               {
                  this.endMenu();
               }
               else if(this.menu_obj != null)
               {
                  if(param1.keyCode == Keyboard.W || param1.keyCode == Keyboard.UP)
                  {
                     result = this.menu_obj.moveUp();
                     msgType = SharedHUDTools.BUILDMENU;
                  }
                  else if(param1.keyCode == Keyboard.A || param1.keyCode == Keyboard.LEFT)
                  {
                     result = this.menu_obj.moveLeft();
                     msgType = SharedHUDTools.BUILDMENU;
                  }
                  else if(param1.keyCode == Keyboard.S || param1.keyCode == Keyboard.DOWN)
                  {
                     result = this.menu_obj.moveDown();
                     msgType = SharedHUDTools.BUILDMENU;
                  }
                  else if(param1.keyCode == Keyboard.D || param1.keyCode == Keyboard.RIGHT)
                  {
                     result = this.menu_obj.moveRight();
                     msgType = SharedHUDTools.BUILDMENU;
                  }
                  else if(param1.keyCode == Keyboard.E || param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.SPACE)
                  {
                     result = this.menu_obj.select();
                     msgType = SharedHUDTools.MENU;
                  }
                  if(result != null && result.length > 0)
                  {
                     modName = this.menu_obj.getSelectedModName();
                     if(modName != null && modName.length > 0)
                     {
                        if(msgType == SharedHUDTools.BUILDMENU && result == modName)
                        {
                           newMsgString = sharedTools.formatMsg(modName,msgType,[]);
                        }
                        else
                        {
                           newMsgString = sharedTools.formatMsg(modName,msgType,[result]);
                        }
                        this.sharedTools.dispatchMessage(newMsgString);
                     }
                  }
               }
            }
            this.controller_tf.text = "";
         }
         catch(e:Error)
         {
            this.displayError("HUDTools.textControllerKeyUp error: " + e.message);
         }
      }
      
      public function onHUDModError(param1:HUDModError) : *
      {
         this.displayError(param1.toString(),true);
      }
      
      public function onHUDModUserEvent(param1:HUDModUserEvent) : *
      {
         if(this.menuMode || this.entryMode)
         {
            return;
         }
         if(param1.EventName == "DiagnosticSnapshot" && !param1.IsKeyDown)
         {
            this.menu_mod = SharedHUDTools.HUDTOOLS;
            if(this.startMenu())
            {
               var newMsgString:String = this.sharedTools.formatMsg(SharedHUDTools.BROADCAST,SharedHUDTools.STARTMENU,[]);
               this.sharedTools.dispatchMessage(newMsgString);
               this.menuMode = true;
            }
         }
         if(this.currentHUDMode != HUDModes.PIPBOY)
         {
            return;
         }
         if(!isInputKeyboard() && param1.EventName == "L3")
         {
            if(param1.IsKeyDown && !this.menuTimer.running)
            {
               this.menuTimer.reset();
               this.menuTimer.start();
            }
            else if(!param1.IsKeyDown && this.menuTimer.running)
            {
               this.menuTimer.reset();
            }
         }
      }
      
      private function menuTimerCompleteHandler(e:TimerEvent) : void
      {
         if(this.menuMode || this.entryMode || isInputKeyboard() || this.currentHUDMode != HUDModes.PIPBOY)
         {
            return;
         }
         this.menu_mod = SharedHUDTools.HUDTOOLS;
         if(this.startMenu())
         {
            var newMsgString:String = this.sharedTools.formatMsg(SharedHUDTools.BROADCAST,SharedHUDTools.STARTMENU,[]);
            this.sharedTools.dispatchMessage(newMsgString);
            this.menuMode = true;
         }
      }
      
      private function displayError(errorString:String, showFlag:Boolean = false) : void
      {
         if(this.debugLevel > 0 || showFlag)
         {
            if(this.topLevel != null && this.topLevel.hasOwnProperty("displayError"))
            {
               topLevel.displayError(errorString);
            }
            else
            {
               GlobalFunc.SetText(this.debug_tf,this.debug_tf.text + "\n" + errorString);
               addChild(this.debug_tf);
               this.debug_tf.visible = true;
            }
         }
      }
      
      private function formatDebugField(tf:TextField) : void
      {
         var colorInt:uint = SharedUtils.calcColor(255,255,255);
         var font:TextFormat = new TextFormat("Arial",15,colorInt);
         font.align = "left";
         tf.width = 1600;
         tf.height = 1000;
         tf.defaultTextFormat = font;
         tf.setTextFormat(font);
         tf.autoSize = TextFieldAutoSize.RIGHT;
         tf.wordWrap = true;
         tf.multiline = true;
         TextFieldEx.setTextAutoSize(tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      private function hudModeUpdate(hudInfo:FromClientDataEvent) : void
      {
         var i:int;
         try
         {
            if(hudInfo != null && hudInfo.data != null)
            {
               this.currentHUDMode = hudInfo.data.hudMode;
               i = this.registeredModsHUDModes.length - 1;
               while(i >= 0)
               {
                  if(this.registeredModsHUDModes[i] != HUDModes.ALL && this.registeredModsHUDModes[i] != this.currentHUDMode)
                  {
                     this.switchToQueue(this.registeredMods[i]);
                  }
                  i--;
               }
            }
         }
         catch(e:Error)
         {
            this.displayError("HUDTools.hudModeUpdate error: " + e.message);
         }
      }
      
      private function formatBackground(hCount:int) : void
      {
         if(this.backgroundAlpha > 0)
         {
            var startField:TextField = this.CurrentWeapon_tf;
            var endField:TextField = this.TotalDamage_tf;
            if(!this.showWeapon)
            {
               startField = this.CurrentDPS_tf;
            }
            if(hCount > 0)
            {
               endField = this.EnemyList_tfa[hCount - 1];
            }
            var colorInt:uint = uint(SharedUtils.calcColor(this.backgroundRed,this.backgroundGreen,this.backgroundBlue));
            this.Background_shape.alpha = this.backgroundAlpha;
            this.Background_shape.graphics.clear();
            this.Background_shape.graphics.beginFill(colorInt);
            this.Background_shape.graphics.drawRect(this.locX,this.locY,this.maxWidth() + 16,endField.y - this.locY + endField.textHeight + 8);
            this.Background_shape.graphics.endFill();
            this.Background_shape.visible = true;
         }
         else
         {
            this.Background_shape.visible = false;
         }
      }
      
      private function formatTextField(tf:TextField, fontSize:Number, x:Number = 0, y:Number = 0, width:Number = 100, height:Number = 20, underline:Boolean = false) : void
      {
         var colorInt:uint = 0;
         var font:TextFormat = null;
         if(fontSize == 0)
         {
            colorInt = uint(SharedUtils.calcColor(255,255,255));
            font = new TextFormat("Arial",18,colorInt);
            font.align = "left";
            tf.width = 1600;
            tf.height = 1000;
            tf.defaultTextFormat = font;
            tf.setTextFormat(font);
            tf.autoSize = TextFieldAutoSize.RIGHT;
            tf.wordWrap = true;
            tf.multiline = true;
            TextFieldEx.setTextAutoSize(tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         else
         {
            colorInt = uint(SharedUtils.calcColor(255,255,255));
            font = new TextFormat("$MAIN_Font_Light",fontSize,colorInt,false,false,underline);
            font.align = "left";
            var shadow:DropShadowFilter = new DropShadowFilter(2,45,0,1,5,5,1,3,false,false,false);
            tf.x = x;
            tf.y = y;
            tf.width = fontSize * 10;
            tf.height = fontSize * 1.5;
            tf.defaultTextFormat = font;
            tf.setTextFormat(font);
            tf.filters = [shadow];
         }
      }
      
      private function colorTextField(tf:TextField, flag:Boolean) : *
      {
         var colorInt:uint = 0;
         if(flag)
         {
            colorInt = uint(SharedUtils.calcColor(this.red,this.green,this.blue));
         }
         else
         {
            colorInt = uint(SharedUtils.calcColor(Math.round(this.red / Number(2)),Math.round(this.green / Number(2)),Math.round(this.blue / Number(2))));
         }
         var font:TextFormat = new TextFormat("$MAIN_Font_Light",this.textSize,colorInt,false,false,false);
         font.align = "left";
         tf.defaultTextFormat = font;
         tf.setTextFormat(font);
      }
      
      private function SubscribeListener(eventName:String, eventFunction:Function) : Function
      {
         var uiData:UIDataFromClient;
         try
         {
            uiData = BSUIDataManager.GetDataFromClient(eventName,true,false);
            if(uiData != null)
            {
               uiData.addEventListener(Event.CHANGE,eventFunction,false,1);
               return eventFunction;
            }
            this.displayError("HUDTools error: couldn\'t subscribe to data provider: " + eventName);
            return null;
         }
         catch(e:Error)
         {
            this.displayError("HUDTools error: " + e.message);
         }
         return null;
      }
      
      private function initEntryTextfield(xVar:Number, yVar:Number, widthVar:Number, heightVar:Number, fontVar:String, sizeVar:Number, colorVar:uint) : void
      {
         this.entry_tf.x = xVar;
         this.entry_tf.y = yVar;
         this.entry_tf.width = widthVar;
         this.entry_tf.height = heightVar;
         this.entry_tf.text = "";
         this.entry_tf.mouseWheelEnabled = false;
         this.entry_tf.mouseEnabled = false;
         this.entry_tf.selectable = false;
         this.entry_tf.visible = true;
         this.entry_tf.type = TextFieldType.INPUT;
         var font:TextFormat = new TextFormat(fontVar,sizeVar,colorVar);
         this.entry_tf.defaultTextFormat = font;
         this.entry_tf.setTextFormat(font);
         this.controller_tf.x = 0;
         this.controller_tf.y = -10 - heightVar;
         this.controller_tf.width = -1;
         this.controller_tf.height = -1;
         this.controller_tf.mouseWheelEnabled = false;
         this.controller_tf.mouseEnabled = false;
         this.controller_tf.selectable = false;
         this.controller_tf.visible = true;
         this.controller_tf.type = TextFieldType.INPUT;
         this.controller_tf.defaultTextFormat = font;
         this.controller_tf.setTextFormat(font);
      }
      
      private function initMenuTextfield() : *
      {
         var font:TextFormat = new TextFormat("Arial",10,0);
         this.controller_tf.x = 0;
         this.controller_tf.y = -20;
         this.controller_tf.width = -1;
         this.controller_tf.height = -1;
         this.controller_tf.mouseWheelEnabled = false;
         this.controller_tf.mouseEnabled = false;
         this.controller_tf.selectable = false;
         this.controller_tf.visible = true;
         this.controller_tf.type = TextFieldType.INPUT;
         this.controller_tf.defaultTextFormat = font;
         this.controller_tf.setTextFormat(font);
      }
   }
}

