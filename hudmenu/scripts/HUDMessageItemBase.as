package
{
   import flash.display.MovieClip;
   
   public class HUDMessageItemBase extends HUDFadingListItem
   {
      
      protected static var m_ShowBottomRight:Boolean = false;
      
      public var Internal_mc:MovieClip;
      
      protected var m_Data:HUDMessageItemData = null;
      
      public function HUDMessageItemBase()
      {
         super();
      }
      
      public static function set showBottomRight(aVal:Boolean) : void
      {
         m_ShowBottomRight = aVal;
      }
      
      public function get data() : HUDMessageItemData
      {
         return this.m_Data;
      }
      
      public function set data(value:HUDMessageItemData) : void
      {
         this.m_Data = value;
         SetIsDirty();
      }
   }
}

