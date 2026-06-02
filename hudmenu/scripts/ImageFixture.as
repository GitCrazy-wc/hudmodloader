package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.SWFLoaderClip;
   import Shared.GlobalFunc;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   
   public class ImageFixture extends SWFLoaderClip
   {
      
      private static const DEMAND_IMAGE:String = "ImageFixtureManager::DemandImage";
      
      private static const REGISTER_IMAGE:String = "ImageFixtureManager::RegisterImage";
      
      private static const UNREGISTER_IMAGE:String = "ImageFixtureManager::UnregisterImage";
      
      private static const DOWNLOAD_ASSOC_MEDIA:String = "ImageFixtureManager::DownloadAssociatedMedia";
      
      public static const NONE_LOADED:int = 0;
      
      public static const SWF_LOADED:int = 1;
      
      public static const IN_LOADED:int = 2;
      
      public static const EX_LOADED:int = 3;
      
      public static const ASSOC_MEDIA_PENDING:int = 4;
      
      public static const ASSOC_MEDIA_LOADED:int = 5;
      
      public static const FT_INVALID:int = -1;
      
      public static const FT_INTERNAL:int = 0;
      
      public static const FT_EXTERNAL:int = 1;
      
      public static const FT_SYMBOL:int = 2;
      
      public static const FT_ASSOC_MEDIA:int = 3;
      
      private var m_FixtureState:int = 0;
      
      private var m_ClipInstance:MovieClip = null;
      
      private var m_BitmapInstance:Bitmap = null;
      
      private var m_ImgLoader:Loader = new Loader();
      
      private var m_Image:String = "";
      
      private var m_BufferName:String = "";
      
      public var LoadingSpinner_mc:MovieClip;
      
      private var m_ScaleLoadingSpinnerWithImage:Boolean = true;
      
      private var m_LoadingSpinnerEnabled:Boolean = true;
      
      private var m_FixtureType:int = -1;
      
      private var m_OnLoadAttemptComplete:Function;
      
      public function ImageFixture()
      {
         super();
         if(this.LoadingSpinner_mc != null)
         {
            this.LoadingSpinner_mc.visible = false;
         }
         this.m_ImgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onBitmapLoaded);
         this.m_ImgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onBitmapLoadFailed);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStageEvent);
      }
      
      public function set onLoadAttemptComplete(aFunc:Function) : void
      {
         this.m_OnLoadAttemptComplete = aFunc;
      }
      
      public function set fixtureType(aType:int) : void
      {
         this.m_FixtureType = aType;
      }
      
      public function set scaleLoadingSpinnerWithImage(abEnabled:Boolean) : void
      {
         this.m_ScaleLoadingSpinnerWithImage = abEnabled;
      }
      
      public function set loadingSpinnerEnabled(abEnabled:Boolean) : void
      {
         if(abEnabled != this.m_LoadingSpinnerEnabled)
         {
            this.m_LoadingSpinnerEnabled = abEnabled;
            this.RefreshLoadingSpinner();
         }
      }
      
      public function get loadingSpinnerEnabled() : Boolean
      {
         return this.m_LoadingSpinnerEnabled;
      }
      
      public function get scaleLoadingSpinnerWithImage() : Boolean
      {
         return this.m_ScaleLoadingSpinnerWithImage;
      }
      
      public function get fixtureType() : int
      {
         return this.m_FixtureType;
      }
      
      public function get fixtureState() : int
      {
         return this.m_FixtureState;
      }
      
      public function get clipInstance() : MovieClip
      {
         return this.m_ClipInstance;
      }
      
      public function get bitmapInstance() : Bitmap
      {
         return this.m_BitmapInstance;
      }
      
      public function get isExternalFixtureType() : Boolean
      {
         return this.fixtureType == FT_EXTERNAL || this.fixtureType == FT_ASSOC_MEDIA;
      }
      
      public function get imagePath() : String
      {
         return this.m_Image;
      }
      
      public function LoadImageFixtureFromUIData(aObj:Object, aBufferName:String) : void
      {
         this.fixtureType = aObj.fixtureType;
         switch(aObj.fixtureType)
         {
            case FT_INTERNAL:
               this.LoadInternal(aObj.directory + aObj.imageName,aBufferName);
               break;
            case FT_EXTERNAL:
               this.LoadExternal(aObj.directory + aObj.imageName,aBufferName);
               break;
            case FT_SYMBOL:
               this.LoadSymbol(aObj.imageName);
               break;
            case FT_ASSOC_MEDIA:
               this.LoadAssocMedia(aObj.directory + aObj.imageName,aObj.assocMediaPayload);
               break;
            default:
               trace("ImageFixture::LoadImageFixtureFromUIData: Fixture type is invalid, cannot load.");
         }
         this.RefreshLoadingSpinner();
      }
      
      public function LoadSymbol(aImage:String) : void
      {
         if(this.m_Image != aImage || this.m_FixtureState != SWF_LOADED)
         {
            this.destroyCurrent();
            this.m_Image = aImage;
            this.m_FixtureState = SWF_LOADED;
            this.SymbolHelper(aImage);
         }
         if(this.m_OnLoadAttemptComplete != null)
         {
            this.m_OnLoadAttemptComplete();
         }
      }
      
      public function LoadInternal(aImage:String, aBufferName:String) : void
      {
         if(this.m_Image != aImage || this.m_FixtureState != IN_LOADED)
         {
            this.destroyCurrent();
            this.m_Image = aImage;
            this.m_FixtureState = IN_LOADED;
            this.m_BufferName = aBufferName;
            this.LoadBitmap();
         }
         else if(this.m_OnLoadAttemptComplete != null)
         {
            this.m_OnLoadAttemptComplete();
         }
      }
      
      public function LoadExternal(aImage:String, aBufferName:String) : void
      {
         if(this.m_Image != aImage || this.m_FixtureState != EX_LOADED)
         {
            this.destroyCurrent();
            this.m_Image = aImage;
            this.m_FixtureState = EX_LOADED;
            this.m_BufferName = aBufferName;
            this.LoadBitmap();
         }
         else if(this.m_OnLoadAttemptComplete != null)
         {
            this.m_OnLoadAttemptComplete();
         }
      }
      
      public function LoadAssocMedia(aImage:String, aAssocMediaPayload:Object) : void
      {
         if(aAssocMediaPayload)
         {
            if(this.m_Image != aImage || this.m_FixtureState != ASSOC_MEDIA_LOADED && this.m_FixtureState != ASSOC_MEDIA_PENDING)
            {
               this.destroyCurrent();
               this.m_Image = aImage;
               this.m_FixtureState = ASSOC_MEDIA_PENDING;
               this.m_BufferName = aAssocMediaPayload.bufferName;
               BSUIDataManager.dispatchEvent(new CustomEvent(DOWNLOAD_ASSOC_MEDIA,aAssocMediaPayload));
            }
            else if(this.m_OnLoadAttemptComplete != null)
            {
               this.m_OnLoadAttemptComplete();
            }
         }
      }
      
      public function Unload() : *
      {
         this.destroyCurrent();
      }
      
      private function removeLoadedImage() : void
      {
         if(this.m_ClipInstance != null)
         {
            this.removeChild(this.m_ClipInstance);
            this.m_ClipInstance = null;
         }
         this.UnloadBitmap();
      }
      
      private function destroyCurrent() : void
      {
         this.removeLoadedImage();
         this.m_Image = "";
         this.m_FixtureState = NONE_LOADED;
         this.m_BufferName = "";
      }
      
      private function SymbolHelper(aImage:String) : void
      {
         this.m_ClipInstance = this.setContainerIconClip(aImage);
         if(!this.m_ClipInstance)
         {
            trace("ImageFixture: Load Symbol Failure [" + aImage + "]");
            this.destroyCurrent();
         }
      }
      
      private function LoadBitmap() : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(DEMAND_IMAGE,{
            "imageName":this.m_Image,
            "isExternal":this.isExternalFixtureType,
            "bufferName":this.m_BufferName
         }));
         var url:* = "img://" + this.m_Image;
         this.m_ImgLoader.load(new URLRequest(url));
      }
      
      private function UnloadBitmap() : *
      {
         if(this.m_BitmapInstance != null)
         {
            this.removeChild(this.m_BitmapInstance);
            this.m_BitmapInstance = null;
         }
         if(Boolean(this.m_Image) && Boolean(this.m_BufferName))
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(UNREGISTER_IMAGE,{
               "imageName":this.m_Image,
               "isExternal":this.isExternalFixtureType,
               "bufferName":this.m_BufferName
            }));
         }
      }
      
      private function RefreshLoadingSpinner() : *
      {
         if(this.LoadingSpinner_mc != null)
         {
            if(this.m_ScaleLoadingSpinnerWithImage)
            {
               this.LoadingSpinner_mc.scaleX = ClipScale;
               this.LoadingSpinner_mc.scaleY = ClipScale;
            }
            this.LoadingSpinner_mc.visible = this.fixtureType == FT_ASSOC_MEDIA && this.fixtureState == ASSOC_MEDIA_PENDING;
         }
      }
      
      private function onBitmapLoadFailed(e:Event) : void
      {
         trace("WARNING: ImageFixture:onBitmapLoadFailed | " + this.m_Image);
         if(this.m_OnLoadAttemptComplete != null)
         {
            this.m_OnLoadAttemptComplete();
         }
      }
      
      private function onBitmapLoaded(e:Event) : void
      {
         var loaderInfo:* = e.target as LoaderInfo;
         var url:* = "img://" + this.m_Image;
         if(loaderInfo.url != url)
         {
            trace("INFO: ImageFixture::onBitmapLoaded | Discarding stale bitmap...");
            return;
         }
         if(this.m_BitmapInstance != null)
         {
            this.removeLoadedImage();
         }
         BSUIDataManager.dispatchEvent(new CustomEvent(REGISTER_IMAGE,{
            "imageName":this.m_Image,
            "isExternal":this.isExternalFixtureType,
            "bufferName":this.m_BufferName
         }));
         GlobalFunc.BSASSERT(loaderInfo.content as Bitmap,"ERROR: ImageFixture::onBitmapLoaded | Expected a valid bitmap object!");
         this.m_BitmapInstance = loaderInfo.content as Bitmap;
         this.m_BitmapInstance.smoothing = true;
         this.addChild(this.m_BitmapInstance);
         this.m_BitmapInstance.scaleX = ClipScale;
         this.m_BitmapInstance.scaleY = ClipScale;
         if(ClipWidth != 0)
         {
            this.m_BitmapInstance.width = ClipWidth;
         }
         if(ClipHeight != 0)
         {
            this.m_BitmapInstance.height = ClipHeight;
         }
         if(CenterClip)
         {
            this.m_BitmapInstance.x -= ClipWidth / 2;
            this.m_BitmapInstance.y -= ClipHeight / 2;
         }
         this.m_BitmapInstance.x += ClipXOffset;
         this.m_BitmapInstance.y += ClipYOffset;
         this.RefreshLoadingSpinner();
         if(this.m_OnLoadAttemptComplete != null)
         {
            this.m_OnLoadAttemptComplete();
         }
      }
      
      private function onRemoveFromStageEvent(e:Event) : void
      {
         this.m_ImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onBitmapLoaded);
         this.m_ImgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onBitmapLoadFailed);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStageEvent);
         this.destroyCurrent();
      }
      
      public function onImageFixtureManagerData(aEvent:FromClientDataEvent) : void
      {
         var i:int = 0;
         if(aEvent && aEvent.data && aEvent.data.completedDownloads && this.fixtureType == FT_ASSOC_MEDIA && this.m_FixtureState == ASSOC_MEDIA_PENDING)
         {
            for(i = 0; i < aEvent.data.completedDownloads.length; i++)
            {
               if(aEvent.data.completedDownloads[i] == this.m_Image)
               {
                  this.LoadBitmap();
                  this.m_FixtureState = ASSOC_MEDIA_LOADED;
                  break;
               }
            }
         }
      }
   }
}

