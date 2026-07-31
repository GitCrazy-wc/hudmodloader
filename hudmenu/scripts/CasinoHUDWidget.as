package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import scaleform.gfx.TextFieldEx;
   
   public class CasinoHUDWidget extends MovieClip
   {
      
      public static const EVENT_WIDGET_ANIM_COMPLETE:String = "CasinoHUDWidget::WidgetAnimComplete";
      
      public var WidgetPanel_mc:MovieClip;
      
      private var WidgetAnimation_mc:MovieClip;
      
      private var WinnerText_mc:MovieClip;
      
      private var NumberBox_mc:MovieClip;
      
      private var YourBetText_mc:MovieClip;
      
      private var m_Data:Object = null;
      
      private var m_WinStateDisplayed:Boolean = false;
      
      public function CasinoHUDWidget()
      {
         super();
         this.WinnerText_mc = this.WidgetPanel_mc.WinnerText_mc;
         this.NumberBox_mc = this.WidgetPanel_mc.NumberBox_mc;
         this.YourBetText_mc = this.WidgetPanel_mc.YourBetText_mc;
         TextFieldEx.setTextAutoSize(this.WinnerText_mc.WinnerTextAnim_mc.WinnerText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.YourBetText_mc.YourBetText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         addEventListener(EVENT_WIDGET_ANIM_COMPLETE,this.onWidgetAnimComplete);
      }
      
      public function get isDataSet() : Boolean
      {
         return this.m_Data != null;
      }
      
      public function get winStateDisplayed() : Boolean
      {
         return this.m_WinStateDisplayed;
      }
      
      public function init(aData:Object) : void
      {
         if(aData)
         {
            this.m_WinStateDisplayed = false;
            this.m_Data = aData;
            if(this.m_Data.casinoGameType == CasinoShared.CASINO_GAME_TYPE_ROULETTE)
            {
               this.WidgetPanel_mc.gotoAndStop(this.m_Data.capsWon == 0 ? "RouletteLose" : "Roulette");
            }
            else if(this.m_Data.casinoGameType == CasinoShared.CASINO_GAME_TYPE_LUCKY_DICE)
            {
               this.WidgetPanel_mc.gotoAndStop(this.m_Data.capsWon == 0 ? "LuckyDiceLose" : "LuckyDice");
            }
            this.WidgetAnimation_mc = this.WidgetPanel_mc.WidgetAnimation_mc;
            if(this.m_Data.casinoGameType == CasinoShared.CASINO_GAME_TYPE_ROULETTE)
            {
               this.WidgetAnimation_mc.gotoAndPlay("rollOn");
               GlobalFunc.PlayMenuSound("UICasinoRouletteSpin");
            }
            else if(this.m_Data.casinoGameType == CasinoShared.CASINO_GAME_TYPE_LUCKY_DICE)
            {
               this.WidgetAnimation_mc.DiceNumber_mc.WinningNumberText_mc.WinningNumberText_tf.text = this.m_Data.winningNumber;
               addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
               GlobalFunc.PlayMenuSound("UICasinoDiceRoll");
            }
            this.YourBetText_mc.YourBetText_tf.text = GlobalFunc.LocalizeFormattedString("$CASINO_YOUR_BET:",this.getBetText(this.m_Data.bet,this.m_Data.casinoGameType));
         }
      }
      
      public function fadeIn() : void
      {
         gotoAndPlay("rollOn");
      }
      
      public function fadeOut() : void
      {
         gotoAndPlay("rollOff");
      }
      
      public function reset() : void
      {
         this.WinnerText_mc.gotoAndStop("off");
         gotoAndStop("off");
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function getBetText(aBet:uint, aGameType:uint) : String
      {
         var betText:String = "";
         switch(aGameType)
         {
            case CasinoShared.CASINO_GAME_TYPE_ROULETTE:
               betText = this.getBetTextRoulette(aBet);
               break;
            case CasinoShared.CASINO_GAME_TYPE_DERBY_RACE:
               betText = this.getBetTextDerby(aBet);
               break;
            case CasinoShared.CASINO_GAME_TYPE_LUCKY_DICE:
               betText = aBet.toString();
         }
         return betText;
      }
      
      private function getBetTextDerby(aLaneIndex:uint) : String
      {
         var betText:String = "";
         switch(aLaneIndex)
         {
            case 0:
               betText = "$CASINO_DERBY_LANE_ONE";
               break;
            case 1:
               betText = "$CASINO_DERBY_LANE_TWO";
               break;
            case 2:
               betText = "$CASINO_DERBY_LANE_THREE";
               break;
            case 3:
               betText = "$CASINO_DERBY_LANE_FOUR";
               break;
            case 4:
               betText = "$CASINO_DERBY_LANE_FIVE";
         }
         return betText;
      }
      
      private function getBetTextRoulette(aRouletteOption:uint) : String
      {
         var betText:String = "";
         switch(aRouletteOption)
         {
            case CasinoShared.ROULETTE_OPTION_JACKPOT:
               betText = "0";
               break;
            case CasinoShared.ROULETTE_OPTION_FIRST_THIRD:
               betText = "$CASINO_ROULETTE_FIRST_THIRD";
               break;
            case CasinoShared.ROULETTE_OPTION_SECOND_THIRD:
               betText = "$CASINO_ROULETTE_SECOND_THIRD";
               break;
            case CasinoShared.ROULETTE_OPTION_LAST_THIRD:
               betText = "$CASINO_ROULETTE_LAST_THIRD";
               break;
            case CasinoShared.ROULETTE_OPTION_RED_EVEN:
               betText = "$$CASINO_ROULETTE_RED / $$CASINO_ROULETTE_EVEN";
               break;
            case CasinoShared.ROULETTE_OPTION_BLACK_ODD:
               betText = "$$CASINO_ROULETTE_BLACK / $$CASINO_ROULETTE_ODD";
         }
         return betText;
      }
      
      private function onWidgetAnimComplete(aEvent:Event) : void
      {
         if(aEvent)
         {
            aEvent.stopPropagation();
         }
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         if(this.m_Data)
         {
            this.WinnerText_mc.WinnerTextAnim_mc.WinnerText_tf.text = this.m_Data.capsWon == 0 ? "$TRYAGAIN" : "$WINNER";
            this.NumberBox_mc.WinningColorText_mc.WinningColorText_tf.text = "";
            this.WinnerText_mc.gotoAndPlay("rollOn");
            if(this.m_Data.casinoGameType == CasinoShared.CASINO_GAME_TYPE_ROULETTE)
            {
               switch(this.m_Data.winningColor)
               {
                  case CasinoShared.ROULETTE_COLOR_BLACK:
                     this.NumberBox_mc.gotoAndPlay("RevealBlack");
                     this.NumberBox_mc.WinningColorText_mc.WinningColorText_tf.text = "$CASINO_COLOR_BLACK";
                     break;
                  case CasinoShared.ROULETTE_COLOR_RED:
                     this.NumberBox_mc.gotoAndPlay("RevealRed");
                     this.NumberBox_mc.WinningColorText_mc.WinningColorText_tf.text = "$CASINO_COLOR_RED";
                     break;
                  case CasinoShared.ROULETTE_COLOR_GREEN:
                     this.NumberBox_mc.gotoAndPlay("RevealGreen");
                     this.NumberBox_mc.WinningColorText_mc.WinningColorText_tf.text = "$CASINO_COLOR_GREEN";
               }
               this.NumberBox_mc.WinningNumberText_mc.WinningNumberText_tf.text = this.m_Data.winningNumber;
            }
            else if(this.m_Data.casinoGameType == CasinoShared.CASINO_GAME_TYPE_LUCKY_DICE)
            {
               this.NumberBox_mc.gotoAndPlay("Default");
               this.NumberBox_mc.WinningNumberText_mc.WinningNumberText_tf.text = this.m_Data.winningNumber;
            }
            GlobalFunc.PlayMenuSound(this.m_Data.capsWon == 0 ? "UICasinoLose" : "UICasinoWin");
         }
         this.m_WinStateDisplayed = true;
      }
      
      private function onEnterFrame(aEvent:Event) : void
      {
         if(Boolean(this.m_Data) && this.m_Data.casinoGameType == CasinoShared.CASINO_GAME_TYPE_LUCKY_DICE)
         {
            this.WidgetAnimation_mc = this.WidgetPanel_mc.WidgetAnimation_mc;
            this.WidgetAnimation_mc.DiceNumber_mc.WinningNumberText_mc.WinningNumberText_tf.text = this.m_Data.winningNumber;
         }
      }
   }
}

