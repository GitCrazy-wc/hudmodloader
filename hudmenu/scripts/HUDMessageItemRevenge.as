package
{
   import Shared.GlobalFunc;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol286")]
   public class HUDMessageItemRevenge extends HUDMessageItemBase
   {
      
      public function HUDMessageItemRevenge()
      {
         super();
         addFrameScript(4,this.frame5,26,this.frame27,772,this.frame773);
      }
      
      override public function redrawUIComponent() : void
      {
         if(data != null)
         {
            Internal_mc.gotoAndStop(m_ShowBottomRight ? "bottomRight" : "default");
            visible = true;
            GlobalFunc.SetText(Internal_mc.RewardHeader_tf,m_Data.data.rewardHeader,true);
            GlobalFunc.SetText(Internal_mc.RewardValue_tf,m_Data.data.rewardValue,true);
            GlobalFunc.SetText(Internal_mc.PlayerName_tf,m_Data.data.titleText,true);
         }
         else
         {
            visible = false;
         }
      }
      
      internal function frame5() : *
      {
         stop();
      }
      
      internal function frame27() : *
      {
         OnFadeInComplete();
         stop();
      }
      
      internal function frame773() : *
      {
         OnFadeOutComplete();
         stop();
      }
   }
}

