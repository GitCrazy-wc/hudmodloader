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
      
      public static function set showBottomRight(param1:Boolean) : void
      {
         m_ShowBottomRight = param1;
      }
      
      public function get data() : HUDMessageItemData
      {
         return this.m_Data;
      }
      
      public function set data(param1:HUDMessageItemData) : void
      {
         this.m_Data = param1;
         SetIsDirty();
      }
   }
}

