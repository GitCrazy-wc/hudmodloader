package
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1044")]
   public class DoTIconsManager extends MovieClip
   {
      
      public static const EVENT_DOT_COMPLETE:String = "DoTIconsManager::DoTComplete";
      
      public static const NEW_ICON_THRESHOLD:uint = 1500;
      
      public static const ICON_WIDTH_WITH_GAP:uint = 38;
      
      public static const ALIGNMENT_CENTER:uint = 0;
      
      public static const ALIGNMENT_LEFT:uint = 1;
      
      public static const ALIGNMENT_RIGHT:uint = 2;
      
      private var IconContainer_mc:MovieClip;
      
      public var Sizer_mc:MovieClip;
      
      private var m_Alignment:uint = 0;
      
      private var m_NumIcons:uint = 0;
      
      private var m_IconArray:Array = new Array();
      
      private var m_bAffectedByStealth:Boolean = false;
      
      private var ORIG_Y:Number = 0;
      
      private var STEALTH_BAR_HEIGHT:Number = 32;
      
      private var STEALTH_BAR_HEIGHT_MARGIN:Number = 4;
      
      public function DoTIconsManager()
      {
         super();
         this.ORIG_Y = this.y;
         this.IconContainer_mc = new MovieClip();
         addChild(this.IconContainer_mc);
         addEventListener(DoTDamageIcon.EVENT_DAMAGE_COMPLETE,this.onDamageComplete);
      }
      
      public function set alignment(aVal:uint) : *
      {
         this.m_Alignment = aVal;
      }
      
      public function reset() : void
      {
         this.m_NumIcons = 0;
         this.m_IconArray = [];
         removeChild(this.IconContainer_mc);
         this.IconContainer_mc = new MovieClip();
         addChild(this.IconContainer_mc);
      }
      
      public function SetStealthMeterAwareness(aVal:Boolean) : void
      {
         this.m_bAffectedByStealth = aVal;
      }
      
      public function SetStealthMeterStatus(aVal:Boolean) : void
      {
         this.y = this.ORIG_Y + (this.m_bAffectedByStealth && aVal ? this.STEALTH_BAR_HEIGHT + this.STEALTH_BAR_HEIGHT_MARGIN : 0);
      }
      
      public function isActive() : Boolean
      {
         return this.m_NumIcons > 0;
      }
      
      public function get numActiveIcons() : uint
      {
         return this.m_NumIcons;
      }
      
      public function populateIcons(aTypes:Array) : Boolean
      {
         var damageTypes:Array = null;
         var i:* = undefined;
         var newBatch:* = false;
         var hasType:Boolean = false;
         var j:* = undefined;
         var x:* = undefined;
         var nextX:* = undefined;
         var newIcon:DoTDamageIcon = null;
         var activeDOT:* = false;
         if(aTypes.length == 0)
         {
            this.visible = false;
         }
         else
         {
            damageTypes = new Array();
            for(i = 0; i < aTypes.length; i++)
            {
               hasType = false;
               for(j = 0; j < damageTypes.length; j++)
               {
                  if(damageTypes[j].damageType == aTypes[i].damageType)
                  {
                     hasType = true;
                     damageTypes[j].remainingDuration = Math.max(damageTypes[j].remainingDuration,aTypes[i].remainingDuration);
                     damageTypes[j].totalDuration = Math.max(damageTypes[j].totalDuration,aTypes[i].remainingDuration);
                     break;
                  }
               }
               if(!hasType)
               {
                  damageTypes.push(aTypes[i]);
               }
            }
            newBatch = damageTypes.length != this.m_IconArray.length;
            if(!newBatch)
            {
               for(x = 0; x < damageTypes.length; x++)
               {
                  if(damageTypes[x].remainingDuration - this.m_IconArray[x].remainingDuration > NEW_ICON_THRESHOLD)
                  {
                     newBatch = true;
                     break;
                  }
               }
            }
            if(newBatch)
            {
               this.reset();
               this.visible = true;
               nextX = 0;
               for(i = 0; i < damageTypes.length; i++)
               {
                  newIcon = new DoTDamageIcon();
                  newIcon.setType(damageTypes[i].damageType,damageTypes[i].positive,damageTypes[i].remainingDuration,damageTypes[i].totalDuration);
                  this.IconContainer_mc.addChild(newIcon);
                  newIcon.x = nextX;
                  nextX += ICON_WIDTH_WITH_GAP;
                  this.m_IconArray.push(newIcon);
                  ++this.m_NumIcons;
               }
               this.alignIcons();
            }
            activeDOT = this.m_NumIcons > 0;
         }
         return activeDOT;
      }
      
      private function onDamageComplete(aEvent:Event) : void
      {
         --this.m_NumIcons;
         this.IconContainer_mc.removeChild(aEvent.target as DisplayObject);
         this.alignIcons();
         aEvent.stopPropagation();
         if(this.m_NumIcons == 0)
         {
            dispatchEvent(new Event(EVENT_DOT_COMPLETE,true,true));
         }
      }
      
      private function alignIcons(aIsRealign:Boolean = false) : void
      {
         var curIcon:DisplayObject = null;
         var nextX:* = 0;
         var numChild:uint = uint(this.IconContainer_mc.numChildren);
         for(var i:uint = 0; i < numChild; i++)
         {
            curIcon = this.IconContainer_mc.getChildAt(i);
            if(curIcon is DoTDamageIcon && (curIcon as DoTDamageIcon).remainingDuration > 0)
            {
               curIcon.x = nextX;
               nextX += ICON_WIDTH_WITH_GAP;
            }
         }
         switch(this.m_Alignment)
         {
            case ALIGNMENT_CENTER:
               this.IconContainer_mc.x = this.Sizer_mc.width / 2 - this.m_NumIcons * ICON_WIDTH_WITH_GAP / 2;
               break;
            case ALIGNMENT_LEFT:
               this.IconContainer_mc.x = aIsRealign ? this.IconContainer_mc.x - ICON_WIDTH_WITH_GAP : this.Sizer_mc.x;
               break;
            case ALIGNMENT_RIGHT:
               this.IconContainer_mc.x = this.Sizer_mc.width - this.m_NumIcons * ICON_WIDTH_WITH_GAP;
         }
      }
   }
}

