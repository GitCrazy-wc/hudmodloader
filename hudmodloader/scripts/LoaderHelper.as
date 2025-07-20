package
{
   import flash.display.Loader;
   import flash.events.*;
   import flash.net.*;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class LoaderHelper
   {
      
      protected var _topLevel:Object;
      
      protected var _modName:String;
      
      protected var _modType:String;
      
      protected var _loadType:String;
      
      protected var _loader:Loader;
      
      protected var _context:LoaderContext;
      
      protected var _needsAddChild:Boolean = false;
      
      public var isReloadable:Boolean = false;
      
      public var isFound:Boolean = false;
      
      public var isLoaded:Boolean = false;
      
      public function LoaderHelper(top:Object, name:String = "", mType:String = "HUD", lType:String = "true")
      {
         super();
         this._modName = name;
         this._topLevel = top;
         this._modType = mType;
         this._loadType = lType;
         this._loader = new Loader();
         if(name.length > 0)
         {
            this.initialize();
         }
      }
      
      private function initialize() : *
      {
         if(this.isLoadingType() || this._loadType == "required")
         {
            this._topLevel.addChild(this._loader);
         }
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCompleteHandler);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onErrorHandler);
         this._loader.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.uncaughtErrorHandler);
         this._context = new LoaderContext(false,ApplicationDomain.currentDomain);
      }
      
      public function load() : *
      {
         var urlName:String = this._modName;
         if(urlName.indexOf(".swf") < 0)
         {
            urlName += ".swf";
         }
         try
         {
            this._loader.load(new URLRequest(urlName),this._context);
         }
         catch(e:Error)
         {
            this._topLevel.displayError(this._modName + " helper error: " + e.toString());
         }
      }
      
      public function duplicate(lh:LoaderHelper) : *
      {
         this._modName = lh._modName;
         this._topLevel = lh._topLevel;
         this._modType = lh._modType;
         this._loadType = lh._loadType;
         this.initialize();
      }
      
      public function unload() : *
      {
         if(this.isLoaded)
         {
            this.isLoaded = false;
            this._topLevel.removeChild(this._loader);
            this._loader.unloadAndStop();
            this._loader.close();
            this._needsAddChild = true;
         }
      }
      
      public function uncaughtErrorHandler(param1:UncaughtErrorEvent) : *
      {
         this._topLevel.displayError(this._modName + ": " + param1.toString());
      }
      
      public function onCompleteHandler(evt:Event) : *
      {
         var target:Loader = evt.currentTarget.loader as Loader;
         this.isFound = true;
         try
         {
            this.isReloadable = this._loader.content.isReloadable;
            if(this._needsAddChild)
            {
               this._needsAddChild = false;
               this._topLevel.addChild(this._loader);
            }
         }
         catch(e:Error)
         {
            this.isReloadable = false;
         }
         if(this.isLoadingType() || this._loadType == "required")
         {
            this.isLoaded = true;
         }
         else
         {
            this.unload();
         }
      }
      
      public function onErrorHandler(evt:Event) : *
      {
      }
      
      public function get modName() : String
      {
         return this._modName;
      }
      
      private function isLoadingType() : Boolean
      {
         if(this._loadType == "true" || this._loadType == "yes")
         {
            return true;
         }
         return false;
      }
   }
}

