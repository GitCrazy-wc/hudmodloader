package Shared.AS3.Styles
{
   import Shared.AS3.BSScrollingList;
   
   public class Pipboy_DataPage_ObjectivesListStyle
   {
      
      public static var listEntryClass_Inspectable:String = "ObjectivesListEntry";
      
      public static var numListItems_Inspectable:uint = 6;
      
      public static var textOption_Inspectable:String = BSScrollingList.TEXT_OPTION_MULTILINE;
      
      public static var restoreListIndex_Inspectable:Boolean = false;
      
      public static var verticalSpacing_Inspectable:Number = 1.75;
      
      public function Pipboy_DataPage_ObjectivesListStyle()
      {
         super();
      }
   }
}

