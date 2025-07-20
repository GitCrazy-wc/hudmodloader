package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.getQualifiedClassName;
   
   public class hudmodloader extends MovieClip
   {
      
      private var topLevel:* = null;
      
      private var iniLoader:URLLoader;
      
      private var loaders:Array = new Array();
      
      private var sharedTools:SharedHUDTools;
      
      private var modName:String = "HUDModLoader";
      
      public function hudmodloader()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
      }
      
      private function addedToStageHandler(param1:Event) : *
      {
         this.topLevel = stage.getChildAt(0);
         if(this.topLevel != null && getQualifiedClassName(this.topLevel) == "HUDMenu")
         {
            BSUIDataManager.Subscribe("PlayerInventoryData",this.onDataUpdate);
            this.iniLoader = new URLLoader();
            this.iniLoader.addEventListener(Event.COMPLETE,this.onConfigLoaded);
            this.iniLoader.load(new URLRequest("../hudmodloader.ini"));
            this.sharedTools = new SharedHUDTools(this.modName);
            this.sharedTools.Register(this.onReceiveMessage);
            this.sharedTools.RegisterMenu(this.onBuildMenu,this.onSelectMenu);
         }
         else
         {
            trace("ERROR: hudmodloader not injected into HUDMenu.");
         }
      }
      
      private function onConfigLoaded(configEvent:Event) : void
      {
         var modConfig:Array;
         var modName:String;
         var helper:LoaderHelper;
         var loadType:String;
         var looseType:String;
         var modType:String = "HUD";
         var line:* = undefined;
         var lineArray:Array = configEvent.target.data.split("\r\n");
         try
         {
            helper = new LoaderHelper(this.topLevel,"HUDTools","HUD","required");
            loaders.push(helper);
            helper.load();
         }
         catch(e:Error)
         {
            this.topLevel.displayError("HUDTools load error: " + e.toString());
         }
         for each(line in lineArray)
         {
            if(line != null && line.length > 0 && line.substr(0,1) != ";")
            {
               try
               {
                  if(line.substr(0,1) == "[")
                  {
                     continue;
                  }
                  modConfig = line.split(",");
                  if(modConfig.length > 0)
                  {
                     modName = modConfig[0];
                     if(indexOfMod(modName) < 0)
                     {
                        loadType = "true";
                        if(modConfig.length > 1)
                        {
                           loadType = modConfig[1].toLowerCase();
                        }
                        looseType = "false";
                        if(modConfig.length > 2)
                        {
                           looseType = modConfig[2].toLowerCase();
                        }
                        helper = new LoaderHelper(this.topLevel,modName,modType,loadType,looseType);
                        loaders.push(helper);
                        helper.load();
                     }
                  }
               }
               catch(e:Error)
               {
                  this.topLevel.displayError(modName + " load error: " + e.toString());
                  continue;
               }
            }
         }
      }
      
      private function onDataUpdate(invEvent:FromClientDataEvent) : void
      {
      }
      
      private function indexOfMod(name:String) : int
      {
         var i:int = 0;
         while(i < loaders.length)
         {
            if(loaders[i].modName == name)
            {
               return i;
            }
            i++;
         }
         return -1;
      }
      
      public function onReceiveMessage(sender:String, msg:String) : void
      {
      }
      
      public function onBuildMenu(parentItem:String = null) : *
      {
         var i:int = 0;
         try
         {
            if(parentItem == this.modName)
            {
               this.sharedTools.AddMenuItem("UNMENU","Unload Mod",true,true);
               this.sharedTools.AddMenuItem("LDMENU","Load Mod",true,true);
            }
            else if(parentItem == "UNMENU")
            {
               while(i < loaders.length)
               {
                  if(loaders[i].isFound && loaders[i].isLoaded && loaders[i].isReloadable)
                  {
                     this.sharedTools.AddMenuItem("UN" + i,loaders[i].modName);
                  }
                  i++;
               }
            }
            else if(parentItem == "LDMENU")
            {
               while(i < loaders.length)
               {
                  if(loaders[i].isFound && !loaders[i].isLoaded && loaders[i].isReloadable)
                  {
                     this.sharedTools.AddMenuItem("LD" + i,loaders[i].modName);
                  }
                  i++;
               }
            }
         }
         catch(e:Error)
         {
            this.topLevel.displayError("HUDModLoader.onBuildMenu error: " + e.message);
         }
      }
      
      public function onSelectMenu(selectItem:String) : *
      {
         var helper:*;
         var newMsgString:String;
         var loaderIndex:int = -1;
         try
         {
            if(selectItem.substr(0,2) == "UN" && selectItem != "UNMENU")
            {
               loaderIndex = int(selectItem.substr(2));
               if(loaderIndex >= 0 && loaderIndex <= loaders.length)
               {
                  loaders[loaderIndex].unload();
                  newMsgString = this.sharedTools.formatMsg(SharedHUDTools.HUDTOOLS,SharedHUDTools.UNLOAD,[loaders[loaderIndex].modName]);
                  this.sharedTools.dispatchMessage(newMsgString);
               }
            }
            else if(selectItem.substr(0,2) == "LD" && selectItem != "LDMENU")
            {
               loaderIndex = int(selectItem.substr(2));
               if(loaderIndex >= 0 && loaderIndex <= loaders.length)
               {
                  loaders[loaderIndex].load();
               }
            }
         }
         catch(e:Error)
         {
            this.topLevel.displayError("HUDModLoader.onSelectMenu error: " + e.message + "," + selectItem);
         }
      }
   }
}

