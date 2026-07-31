package
{
   import Shared.AS3.BSUIComponent;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Data.UIDataFromClient;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol742")]
   public dynamic class Messages extends BSUIComponent
   {
      
      public static const EVENT_MESSAGE_VISIBILITY_UPDATE:String = "HUD::MessageVisibilityUpdate";
      
      private static var MAX_SHOWN:uint = 4;
      
      private static var THROTTLE_DURATION:uint = 5 * 1000;
      
      public var MessageArray:Vector.<HUDMessageItemData>;
      
      public var ShownMessageArray:Vector.<HUDMessageItemBase>;
      
      private var MessageSpacing:int = -2;
      
      private var bAnimating:Boolean;
      
      private var ySpacing:Number;
      
      private var bqueuedMessage:Boolean = false;
      
      private var fadingOutMessage:Boolean = false;
      
      private var lastTime:Number = 0;
      
      private var bPauseUpdates:Boolean = false;
      
      private var m_TotalHeight:Number = 0;
      
      private var m_PressAndHoldActive:Boolean = false;
      
      private var m_CurrentPressAndHoldMessage:HUDMessageItemRecentActivity = null;
      
      private var _maxClipHeight:Number = 155;
      
      private var MessagePayload:UIDataFromClient = null;
      
      private var NotificationPayload:UIDataFromClient = null;
      
      private var ThrottledMessages:Vector.<Object>;
      
      private var m_ShowBottomRight:Boolean = false;
      
      public function Messages()
      {
         var processEvent:Function;
         super();
         processEvent = function(data:Object, cb:Function):*
         {
            var event:* = undefined;
            var events:* = data.events;
            var numEvents:* = events.length;
            for(var eventIndex:* = 0; eventIndex < numEvents; eventIndex++)
            {
               event = events[eventIndex];
               cb(event);
            }
         };
         this.MessageArray = new Vector.<HUDMessageItemData>();
         this.ShownMessageArray = new Vector.<HUDMessageItemBase>();
         this.ThrottledMessages = new Vector.<Object>();
         this.bAnimating = false;
         this.alpha = 1;
         this.MessagePayload = BSUIDataManager.GetDataFromClient("HUDMessageProvider");
         BSUIDataManager.Subscribe("MessageEvents",function(arEvent:FromClientDataEvent):*
         {
            var messages:* = MessagePayload.data.messages;
            processEvent(arEvent.data,function(messageEvent:Object):*
            {
               var msg:* = undefined;
               var isThrottled:* = undefined;
               var alreadyShow:Boolean = false;
               var index:* = undefined;
               var throttleIndex:* = undefined;
               var msgIndex:* = messageEvent.eventIndex;
               switch(messageEvent.eventType)
               {
                  case "new":
                     msg = MessagePayload.data.messages[msgIndex];
                     isThrottled = false;
                     if(msg.canBeThrottled)
                     {
                        for(throttleIndex = 0; throttleIndex < ThrottledMessages.length; throttleIndex++)
                        {
                           if(ThrottledMessages[throttleIndex].msg == msg.messageText && ThrottledMessages[throttleIndex].title == msg.titleText && ThrottledMessages[throttleIndex].header == msg.headerText)
                           {
                              isThrottled = true;
                              break;
                           }
                        }
                        if(!isThrottled)
                        {
                           ThrottledMessages.push({
                              "msg":msg.messageText,
                              "title":msg.titleText,
                              "header":msg.headerText,
                              "throttledTime":THROTTLE_DURATION
                           });
                        }
                     }
                     alreadyShow = false;
                     for(index = 0; index < MessageArray.length; index++)
                     {
                        if(MessageArray[index].messageID == msg.messageId && MessageArray[index].type == msg.type && MessageArray[index].data == msg)
                        {
                           alreadyShow = true;
                           break;
                        }
                     }
                     if(!isThrottled && !alreadyShow)
                     {
                        MessageArray.push(new HUDMessageItemData(msg.messageId,msg.type,msg,msg.sound));
                     }
                     else
                     {
                        DiscardMessage(msg.messageId);
                     }
                     break;
                  case "remove":
                     msg = MessagePayload.data.messages[msgIndex];
                     DiscardMessage(msg.messageId);
                     break;
                  case "clear":
                     RemoveMessages(false);
               }
            });
         });
         this.lastTime = getTimer();
         addEventListener(Event.ENTER_FRAME,this.Update);
      }
      
      public function get maxClipHeight_Inspectable() : Number
      {
         return this._maxClipHeight;
      }
      
      public function set maxClipHeight_Inspectable(aMaxClipHeight:Number) : void
      {
         this._maxClipHeight = aMaxClipHeight;
      }
      
      public function set showBottomRight(aVal:Boolean) : void
      {
         if(this.m_ShowBottomRight != aVal)
         {
            this.m_ShowBottomRight = aVal;
            this.RedrawElements();
         }
      }
      
      private function get pauseUpdates() : Boolean
      {
         return this.bPauseUpdates;
      }
      
      private function set pauseUpdates(aBool:Boolean) : void
      {
         var i:uint = 0;
         if(this.bPauseUpdates != aBool)
         {
            for(this.bPauseUpdates = aBool; i < this.ShownMessageArray.length; )
            {
               if(this.bPauseUpdates)
               {
                  this.ShownMessageArray[i].OnPause();
               }
               else
               {
                  this.ShownMessageArray[i].OnResume();
               }
               i++;
            }
         }
      }
      
      public function get pressAndHoldActive() : Boolean
      {
         return this.m_PressAndHoldActive;
      }
      
      public function get currentPressAndHoldMessage() : HUDMessageItemRecentActivity
      {
         return this.m_CurrentPressAndHoldMessage;
      }
      
      public function ClearPressAndHoldMessage() : void
      {
         this.m_CurrentPressAndHoldMessage = null;
      }
      
      public function set TutorialShowing(aShowing:Boolean) : *
      {
         if(this.pauseUpdates && !aShowing)
         {
            this.lastTime = getTimer();
         }
         this.pauseUpdates = aShowing;
         this.visible = !aShowing;
      }
      
      public function get ShownCount() : int
      {
         return this.ShownMessageArray.length;
      }
      
      private function RedrawElements() : void
      {
         var newY:Number = 0;
         for(var i:* = this.ShownCount - 1; i >= 0; i--)
         {
            if(this.ShownMessageArray[i].data.type != "")
            {
               this.ShownMessageArray[i].redrawDisplayObject();
            }
            else
            {
               this.ShownMessageArray[i].y = newY;
               if(this.m_ShowBottomRight)
               {
                  newY -= this.ShownMessageArray[i].height - this.MessageSpacing;
               }
               else
               {
                  newY += this.ShownMessageArray[i].height + this.MessageSpacing;
               }
            }
         }
      }
      
      private function HasHoldButton(newMessage:HUDFadingListItem) : Boolean
      {
         return newMessage.data.type == HUDMessageItemData.TYPE_INFESTATION;
      }
      
      private function StartMessage(newMessage:HUDFadingListItem) : void
      {
         newMessage.FadeIn();
         dispatchEvent(new CustomEvent(EVENT_MESSAGE_VISIBILITY_UPDATE,{
            "messageType":newMessage.data.type,
            "fadedIn":true
         },true));
         this.m_TotalHeight += newMessage.height + this.MessageSpacing;
         BSUIDataManager.dispatchEvent(new CustomEvent(GlobalFunc.PLAY_MENU_SOUND,{"soundID":newMessage.data.sound}));
         if(this.HasHoldButton(newMessage))
         {
            this.m_PressAndHoldActive = true;
            BSUIDataManager.dispatchEvent(new CustomEvent(HUDMenu.EVENT_QUICK_HOLD_TOGGLE,{"flyoutHasHold":true}));
            if(this.m_CurrentPressAndHoldMessage == null)
            {
               this.m_CurrentPressAndHoldMessage = newMessage as HUDMessageItemRecentActivity;
            }
         }
      }
      
      public function UpdatePositions() : void
      {
         var onlyMessage:HUDFadingListItem = null;
         var msgIdx:int = 0;
         var remainingDistanceToAnimate:int = 0;
         var newMessage:HUDMessageItemBase = null;
         var newMessageStartingPoint:uint = 0;
         var prevMessage:HUDMessageItemBase = null;
         var prevMessageStartingPoint:uint = 0;
         var prevMessageTargetY:int = 0;
         var canFadeIn:Boolean = false;
         var amountToDip:* = undefined;
         var removableIndex:Number = NaN;
         var fadableIndex:int = 0;
         var numClips:int = this.ShownCount;
         if(numClips == 1)
         {
            onlyMessage = this.ShownMessageArray[0];
            if(!onlyMessage.fadeInStarted)
            {
               if(onlyMessage.CanFadeIn())
               {
                  this.bAnimating = true;
                  this.StartMessage(onlyMessage);
               }
               this.fadingOutMessage = false;
            }
            else if(this.MessageArray.length == 0 && !this.fadingOutMessage && onlyMessage.CanFadeOut())
            {
               this.FadeOutMessage(this.ShownMessageArray[0]);
               this.bAnimating = false;
               this.fadingOutMessage = true;
            }
            else
            {
               this.bAnimating = false;
               this.fadingOutMessage = false;
            }
         }
         else if(numClips > 1)
         {
            for(msgIdx = 0; msgIdx < this.ShownMessageArray.length; msgIdx++)
            {
               remainingDistanceToAnimate = 0;
               newMessage = this.ShownMessageArray[msgIdx];
               newMessageStartingPoint = this.m_ShowBottomRight ? uint(newMessage.y) : uint(newMessage.height);
               if(msgIdx > 0)
               {
                  prevMessage = this.ShownMessageArray[msgIdx - 1];
                  prevMessageStartingPoint = this.m_ShowBottomRight ? uint(prevMessage.height) : uint(prevMessage.y);
                  prevMessageTargetY = this.m_ShowBottomRight ? newMessageStartingPoint - this.MessageSpacing - prevMessageStartingPoint : newMessageStartingPoint + this.MessageSpacing;
                  remainingDistanceToAnimate = this.m_ShowBottomRight ? int(prevMessage.y - prevMessageTargetY) : prevMessageTargetY - prevMessageStartingPoint;
               }
               this.bAnimating = remainingDistanceToAnimate > 0 || newMessage.bIsDirty;
               if(!newMessage.bIsDirty)
               {
                  canFadeIn = !newMessage.fadeInStarted && newMessage.CanFadeIn() && this.m_TotalHeight + this.MessageSpacing + newMessage.height <= this._maxClipHeight;
                  if(canFadeIn)
                  {
                     this.StartMessage(newMessage);
                  }
                  if(this.bAnimating && newMessage.fadeInStarted)
                  {
                     amountToDip = 1;
                     for(removableIndex = 0; removableIndex < msgIdx; removableIndex++)
                     {
                        if(this.ShownMessageArray[removableIndex].fadeInStarted)
                        {
                           if(this.m_ShowBottomRight)
                           {
                              this.ShownMessageArray[removableIndex].y -= amountToDip;
                           }
                           else
                           {
                              this.ShownMessageArray[removableIndex].y += amountToDip;
                           }
                        }
                     }
                  }
                  else if(!this.fadingOutMessage)
                  {
                     if(!this.bqueuedMessage || numClips == MAX_SHOWN || !canFadeIn && newMessage.CanFadeIn())
                     {
                        for(fadableIndex = 0; fadableIndex < this.ShownMessageArray.length; fadableIndex++)
                        {
                           if(this.ShownMessageArray[fadableIndex].CanFadeOut())
                           {
                              this.FadeOutMessage(this.ShownMessageArray[fadableIndex]);
                              break;
                           }
                        }
                     }
                  }
               }
               if(!newMessage.fadeInStarted)
               {
                  return;
               }
            }
         }
      }
      
      private function FadeOutMessage(aMessage:HUDMessageItemBase) : void
      {
         var fadeOutLength:* = HUDMessageItemData.GetMessageFadeOutLength(aMessage.data.type);
         if(fadeOutLength != HUDMessageItemData.INVALID_FADE_TIME)
         {
            aMessage.FadeOutCustomLength(fadeOutLength);
         }
         else
         {
            aMessage.FadeOut();
         }
         this.fadingOutMessage = true;
      }
      
      public function RemoveMessages(abConditional:Boolean) : *
      {
         var removedMessageArray:Vector.<HUDMessageItemBase> = null;
         var i:int = int(this.ShownMessageArray.length - 1);
         while(i >= 0 && this.ShownMessageArray.length > 0)
         {
            if(!abConditional || this.ShownMessageArray[i].currentFrame >= this.ShownMessageArray[i].endAnimFrame || this.ShownMessageArray[i].fullyFadedOut)
            {
               removedMessageArray = this.ShownMessageArray.splice(i,1);
               this.m_TotalHeight -= removedMessageArray[0].height + this.MessageSpacing;
               this.removeChild(removedMessageArray[0]);
               this.fadingOutMessage = false;
               BSUIDataManager.dispatchEvent(new CustomEvent(HUDMenu.EVENT_QUICK_HOLD_TOGGLE,{"flyoutHasHold":false}));
               this.m_CurrentPressAndHoldMessage = null;
               this.m_PressAndHoldActive = false;
               dispatchEvent(new CustomEvent(EVENT_MESSAGE_VISIBILITY_UPDATE,{
                  "messageType":removedMessageArray[0].data.type,
                  "fadedIn":false
               },true));
               this.DiscardMessage(removedMessageArray[0].data.messageID);
            }
            i--;
         }
         if(this.ShownMessageArray.length == 0)
         {
            this.m_TotalHeight = 0;
         }
      }
      
      private function DiscardMessage(messageId:Number) : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("HUDMessages::DiscardMessage",{"id":messageId}));
      }
      
      public function Update(e:Event) : *
      {
         var frameTime:* = undefined;
         var deltaTime:* = undefined;
         var numThrottled:* = undefined;
         var showingAtStart:* = false;
         var showingAtEnd:* = false;
         var throttleIndex:* = undefined;
         var itemData:HUDMessageItemData = null;
         var messageItem:HUDMessageItemBase = null;
         if(!this.pauseUpdates)
         {
            frameTime = getTimer();
            deltaTime = frameTime - this.lastTime;
            numThrottled = this.ThrottledMessages.length;
            if(numThrottled > 0)
            {
               for(throttleIndex = 0; throttleIndex < numThrottled; throttleIndex++)
               {
                  this.ThrottledMessages[throttleIndex].throttledTime -= deltaTime;
               }
               while(numThrottled > 0 && this.ThrottledMessages[0].throttledTime <= 0)
               {
                  this.ThrottledMessages.shift();
                  numThrottled--;
               }
            }
            this.bqueuedMessage = this.MessageArray.length > 0;
            showingAtStart = this.ShownCount > 0;
            this.RemoveMessages(true);
            if(this.bqueuedMessage && !this.bAnimating && !this.fadingOutMessage && this.ShownCount < MAX_SHOWN)
            {
               itemData = this.MessageArray.shift();
               switch(itemData.type)
               {
                  case HUDMessageItemData.TYPE_EVENT:
                     messageItem = new HUDMessageItemBox();
                     break;
                  case HUDMessageItemData.TYPE_KILL_SINGLE:
                     messageItem = new HUDMessageItemKill();
                     break;
                  case HUDMessageItemData.TYPE_KILL_TEAM:
                     messageItem = new HUDMessageItemTeamKill();
                     break;
                  case HUDMessageItemData.TYPE_UNDER_ATTACK:
                     messageItem = new HUDMessageItemUnderAttack();
                     break;
                  case HUDMessageItemData.TYPE_COMEBACK:
                     messageItem = new HUDMessageItemRevenge();
                     break;
                  case HUDMessageItemData.TYPE_KILL_GROUP:
                     messageItem = new HUDMessageItemGroupKill();
                     break;
                  case HUDMessageItemData.TYPE_MUTATED_EVENT:
                  case HUDMessageItemData.TYPE_DAILY_OPS:
                  case HUDMessageItemData.TYPE_INFESTATION:
                     messageItem = new HUDMessageItemRecentActivity(uiPlatform);
                     break;
                  case HUDMessageItemData.TYPE_CASINO:
                     messageItem = new HUDMessageItemCasino();
                     break;
                  default:
                     messageItem = new HUDMessageItem();
               }
               messageItem.data = itemData;
               this.addChild(messageItem);
               this.ShownMessageArray.push(messageItem as HUDMessageItemBase);
            }
            this.UpdatePositions();
            showingAtEnd = this.ShownCount > 0;
            if(showingAtStart || showingAtEnd)
            {
               SetIsDirty();
            }
            this.lastTime = frameTime;
         }
      }
   }
}

