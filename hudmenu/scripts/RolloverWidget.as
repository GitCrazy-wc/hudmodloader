package
{
   import Shared.AS3.BSButtonHintBar;
   import Shared.AS3.BSButtonHintData;
   import Shared.AS3.BSUIComponent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1376")]
   public dynamic class RolloverWidget extends BSUIComponent
   {
      
      public var RolloverName_tf:TextField;
      
      public var RolloverName_mc:MovieClip;
      
      public var RolloverTitle_tf:TextField;
      
      public var RolloverTitle_mc:MovieClip;
      
      public var ButtonHintBar_mc:BSButtonHintBar;
      
      public var LegendaryIcon_mc:MovieClip;
      
      public var TaggedForSearchIcon_mc:MovieClip;
      
      public var AButtonData:BSButtonHintData = new BSButtonHintData("","E","PSN_A","Xenon_A",1,null);
      
      public var XButtonData:BSButtonHintData = new BSButtonHintData("","R","PSN_X","Xenon_X",1,null);
      
      public var YButtonData:BSButtonHintData = new BSButtonHintData("","Space","PSN_Y","Xenon_Y",1,null);
      
      public var BButtonData:BSButtonHintData = new BSButtonHintData("","Tab","PSN_B","Xenon_B",1,null);
      
      private var m_IconSpacing:uint = 10;
      
      public function RolloverWidget()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
         this.RolloverName_tf = this.RolloverName_mc.RolloverName_tf;
         this.TaggedForSearchIcon_mc = this.RolloverName_mc.TaggedForSearchIcon_mc;
         this.LegendaryIcon_mc = this.RolloverName_mc.LegendaryIcon_mc;
         this.ButtonHintBar_mc.useBackground = false;
         this.PopulateButtonBar();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.RolloverName_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.RolloverName_tf.text = " ";
         TextFieldEx.setVerticalAlign(this.RolloverName_tf,TextFieldEx.VALIGN_BOTTOM);
         if(this.RolloverTitle_mc)
         {
            this.RolloverTitle_tf = this.RolloverTitle_mc.RolloverTitle_tf;
            TextFieldEx.setTextAutoSize(this.RolloverTitle_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            this.RolloverTitle_tf.text = " ";
            TextFieldEx.setVerticalAlign(this.RolloverTitle_tf,TextFieldEx.VALIGN_BOTTOM);
         }
         this.AdjustRolloverPositions();
         this.ButtonHintBar_mc.useVaultTecColor = true;
      }
      
      private function PopulateButtonBar() : void
      {
         var buttonHintDataV:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
         buttonHintDataV.push(this.AButtonData);
         buttonHintDataV.push(this.XButtonData);
         buttonHintDataV.push(this.YButtonData);
         buttonHintDataV.push(this.BButtonData);
         this.AButtonData.ButtonVisible = false;
         this.XButtonData.ButtonVisible = false;
         this.YButtonData.ButtonVisible = false;
         this.BButtonData.ButtonVisible = false;
         this.ButtonHintBar_mc.SetButtonHintData(buttonHintDataV);
      }
      
      public function AdjustRolloverPositions() : *
      {
         if(this.RolloverName_tf.length > 0)
         {
            this.LegendaryIcon_mc.x = this.RolloverName_tf.getCharBoundaries(0).x - this.LegendaryIcon_mc.width - this.m_IconSpacing;
            this.TaggedForSearchIcon_mc.x = this.RolloverName_tf.getCharBoundaries(0).x - this.TaggedForSearchIcon_mc.width - this.m_IconSpacing;
         }
      }
      
      public function UpdateText(aText:String, aVisible:Boolean) : void
      {
         var playerStrings:Array = GlobalFunc.GenerateNameAndTitleArray(aText);
         if(playerStrings.length > 1 && playerStrings[1] != " ")
         {
            gotoAndStop("Title");
            if(this.RolloverTitle_tf)
            {
               this.RolloverTitle_tf.text = playerStrings[1];
               GlobalFunc.TruncateSingleLineText(this.RolloverTitle_tf);
            }
         }
         else
         {
            gotoAndStop("Basic");
            if(this.RolloverTitle_tf)
            {
               this.RolloverTitle_tf.text = "";
            }
         }
         this.RolloverName_tf.text = playerStrings[0].toUpperCase();
         this.visible = aVisible;
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}

