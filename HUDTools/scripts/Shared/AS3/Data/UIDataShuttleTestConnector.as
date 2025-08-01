package Shared.AS3.Data
{
   import com.adobe.serialization.json.JSONDecoder;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   
   public class UIDataShuttleTestConnector extends UIDataShuttleConnector
   {
      
      public function UIDataShuttleTestConnector()
      {
         super();
      }
      
      override public function Watch(param1:String, param2:UIDataFromClient = null) : UIDataFromClient
      {
         var _loc3_:UIDataFromClient = new UIDataFromClient(new Object());
         var _loc4_:TestProviderLoader = new TestProviderLoader(param1,_loc3_);
         _loc4_.addEventListener(Event.COMPLETE,this.onLoadComplete);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadFailedPrimaryLocation);
         _loc4_.load(new URLRequest("Providers/" + param1 + ".json"));
         _loc3_.isTest = true;
         return _loc3_;
      }
      
      internal function onLoadComplete(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:TestProviderLoader = param1.target as TestProviderLoader;
         var _loc4_:UIDataFromClient = _loc3_.fromClient;
         var _loc5_:Object = new JSONDecoder(_loc3_.data,true).getValue();
         var _loc6_:Object = _loc4_.data;
         for(_loc2_ in _loc5_)
         {
            _loc6_[_loc2_] = _loc5_[_loc2_];
         }
         _loc3_.fromClient.SetReady();
      }
      
      internal function onLoadFailedPrimaryLocation(param1:IOErrorEvent) : *
      {
         var _loc2_:TestProviderLoader = param1.target as TestProviderLoader;
         var _loc3_:* = new TestProviderLoader(_loc2_.providerName,_loc2_.fromClient);
         _loc3_.addEventListener(Event.COMPLETE,this.onLoadComplete);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadFailed);
         _loc3_.load(new URLRequest("../Interface/Providers/" + _loc2_.providerName + ".json"));
      }
      
      internal function onLoadFailed(param1:IOErrorEvent) : *
      {
         var _loc2_:TestProviderLoader = TestProviderLoader(param1.target);
         var _loc3_:String = _loc2_.providerName;
         trace("WARNING - UIDataShuttleTestConnector.onLoadFailed - TEST PROVIDER: " + _loc3_ + " NOT FOUND");
      }
   }
}

