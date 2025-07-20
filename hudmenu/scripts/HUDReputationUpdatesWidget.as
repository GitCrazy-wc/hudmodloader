package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Data.UIDataFromClient;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Factions;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class HUDReputationUpdatesWidget extends MovieClip
   {
      
      public static const EVENT_LEVELUP_VISIBLE:String = "Reputation::LevelUpVisible";
      
      public static const EVENT_HIDDEN:String = "Reputation::LevelUpHidden";
      
      public static const EVENT_CHANGE_VISIBLE:String = "Reputation::ChangeVisible";
      
      public static const EVENT_FADEOUT_END:String = "Reputation::FadeOutEnd";
      
      public static const TEST_MODE:Boolean = false;
      
      public static const EVENT_PULL:String = "Reputation::Consume";
      
      public var ReputationMeter_mc:HUDReputationUpdateMeter;
      
      public var LevelUpAnimation_mc:MovieClip;
      
      private var m_IsBusy:Boolean = false;
      
      private var m_ReputationData:UIDataFromClient;
      
      private var m_LastUpdate:Object;
      
      private var m_CurUpdate:Object;
      
      private var m_LastFullyShown:Boolean = false;
      
      public function HUDReputationUpdatesWidget()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(EVENT_FADEOUT_END,this.onFadeOutEnd);
         addEventListener(HUDReputationUpdateMeter.DISPLAY_COMPLETE,this.onDisplayComplete);
      }
      
      private function onDataUpdate(param1:FromClientDataEvent) : void
      {
         this.evaluateQueue();
      }
      
      private function evaluateQueue() : void
      {
         var _loc1_:Array = null;
         if(!this.m_IsBusy)
         {
            _loc1_ = this.m_ReputationData.data.reputationDeltaArray;
            if(_loc1_.length > 0)
            {
               if(this.m_LastFullyShown)
               {
                  if(this.m_CurUpdate != null && _loc1_[0].uFactionID == this.m_CurUpdate.factionID && _loc1_[0].uTierStart == _loc1_[0].uTierEnd && this.m_CurUpdate.tierStart == this.m_CurUpdate.tierEnd)
                  {
                     this.animateUpdate(_loc1_[0]);
                  }
                  else
                  {
                     this.m_IsBusy = true;
                     this.ReputationMeter_mc.fadeOut();
                  }
               }
               else
               {
                  this.animateUpdate(_loc1_[0]);
               }
            }
            else if(this.m_LastFullyShown)
            {
               this.ReputationMeter_mc.fadeOut();
            }
         }
      }
      
      private function animateUpdate(param1:Object) : void
      {
         var _loc3_:Array = null;
         if(TEST_MODE)
         {
            _loc3_ = this.m_ReputationData.data.reputationDeltaArray;
            _loc3_.shift();
         }
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_PULL,{"uDeltaID":param1.uDeltaID},true));
         this.m_IsBusy = true;
         this.m_LastUpdate = this.m_CurUpdate;
         var _loc2_:Object = this.buildDeltaInfo(param1);
         this.m_CurUpdate = _loc2_;
         if(_loc2_.tierStart != _loc2_.tierEnd)
         {
            if(_loc2_.tierEnd > _loc2_.tierStart)
            {
               this.LevelUpAnimation_mc.RepLevelUpBoy_mc.gotoAndStop(_loc2_.factionCode);
               this.LevelUpAnimation_mc.gotoAndPlay("rollOn");
               dispatchEvent(new Event(EVENT_LEVELUP_VISIBLE,true));
            }
            else
            {
               this.m_IsBusy = false;
            }
         }
         else
         {
            if(!this.m_LastFullyShown)
            {
               this.ReputationMeter_mc.fadeIn();
               dispatchEvent(new Event(EVENT_CHANGE_VISIBLE,true));
            }
            this.ReputationMeter_mc.data = _loc2_;
         }
      }
      
      public function buildDeltaInfo(param1:Object) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc2_:Object = {};
         var _loc3_:Array = ["Crater","Foundation"];
         var _loc7_:uint = 0;
         while(_loc7_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc7_];
            _loc4_ = this.m_ReputationData.data["factionData" + _loc5_];
            if(param1.uFactionID == _loc4_.uFactionID)
            {
               _loc2_.factionID = _loc4_.uFactionID;
               _loc2_.factionName = _loc4_.szFactionName;
               _loc2_.factionCode = _loc5_;
               _loc2_.tierInfo = _loc4_.reputationTiers;
               break;
            }
            _loc7_++;
         }
         _loc2_.tierStart = param1.uTierStart;
         _loc2_.tierEnd = param1.uTierEnd;
         _loc2_.percentStart = Factions.getNextReputationTierPercent(param1.fAmountStart,param1.uTierStart,_loc4_.reputationTiers);
         if(param1.uTierStart == param1.uTierEnd)
         {
            _loc2_.percentEnd = Factions.getNextReputationTierPercent(param1.fAmountEnd,param1.uTierStart,_loc4_.reputationTiers);
         }
         else
         {
            _loc2_.percentEnd = _loc2_.percentStart;
         }
         return _loc2_;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         BSUIDataManager.Subscribe("ReputationData",this.onDataUpdate,TEST_MODE);
         this.m_ReputationData = BSUIDataManager.GetDataFromClient("ReputationData");
      }
      
      public function onDisplayComplete(param1:Event = null) : void
      {
         this.m_LastFullyShown = true;
         this.m_IsBusy = false;
         this.evaluateQueue();
      }
      
      public function onFadeOutEnd(param1:Event) : void
      {
         dispatchEvent(new Event(EVENT_HIDDEN,true));
         this.m_LastFullyShown = false;
         this.m_IsBusy = false;
         this.evaluateQueue();
      }
   }
}

