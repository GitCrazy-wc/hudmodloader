package Shared.AS3
{
   public class BSScrollingListFadeEntry extends BSScrollingListEntry
   {
      
      internal const fUnselectedBorderAlpha:Number = 0.5;
      
      public function BSScrollingListFadeEntry()
      {
         super();
      }
      
      override public function SetEntryText(aEntryObject:Object, astrTextOption:String) : *
      {
         super.SetEntryText(aEntryObject,astrTextOption);
         var focus:* = stage.focus == this.parent;
         if(!focus && this.parent != null)
         {
            focus = stage.focus == this.parent.parent;
         }
         if(!focus && this.selected)
         {
            border.alpha = this.fUnselectedBorderAlpha;
         }
      }
   }
}

