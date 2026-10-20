package
{
   public class HUDMessageItemData
   {
      
      public static const TYPE_EVENT:String = "eventBox";
      
      public static const TYPE_KILL_SINGLE:String = "kill";
      
      public static const TYPE_KILL_TEAM:String = "teamKill";
      
      public static const TYPE_UNDER_ATTACK:String = "underAttack";
      
      public static const TYPE_COMEBACK:String = "comeback";
      
      public static const TYPE_KILL_GROUP:String = "groupKill";
      
      public static const TYPE_DAILY_OPS:String = "dailyOps";
      
      public static const TYPE_MUTATED_EVENT:String = "mutatedEvent";
      
      public static const TYPE_CASINO:String = "casino";
      
      public static const TYPE_RAID:String = "raid";
      
      public static const TYPE_INFESTATION:String = "infestation";
      
      public static const INVALID_FADE_TIME:* = -1;
      
      private var m_MessageID:Number;
      
      private var m_Type:String;
      
      private var m_Data:Object = new Object();
      
      private var m_Sound:String;
      
      public function HUDMessageItemData(aMessageID:Number, aType:String, aData:Object, aSound:String)
      {
         super();
         this.messageID = aMessageID;
         this.type = aType;
         this.data = aData;
         this.sound = aSound;
      }
      
      public static function GetMessageFadeOutLength(aType:String) : Number
      {
         switch(aType)
         {
            case HUDMessageItemData.TYPE_INFESTATION:
               return 7;
            default:
               return INVALID_FADE_TIME;
         }
      }
      
      public function set messageID(aMessageID:Number) : void
      {
         this.m_MessageID = aMessageID;
      }
      
      public function get messageID() : Number
      {
         return this.m_MessageID;
      }
      
      public function set type(aType:String) : void
      {
         this.m_Type = aType;
      }
      
      public function get type() : String
      {
         return this.m_Type;
      }
      
      public function set data(aData:Object) : void
      {
         var prop:String = null;
         for(prop in aData)
         {
            this.m_Data[prop] = aData[prop];
         }
      }
      
      public function get data() : Object
      {
         return this.m_Data;
      }
      
      public function set sound(aSound:String) : void
      {
         this.m_Sound = aSound;
      }
      
      public function get sound() : String
      {
         return this.m_Sound;
      }
   }
}

