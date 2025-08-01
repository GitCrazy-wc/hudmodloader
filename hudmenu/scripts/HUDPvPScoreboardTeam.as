package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1747")]
   public class HUDPvPScoreboardTeam extends MovieClip
   {
      
      public static const PLAYERS_MAX:uint = 4;
      
      public var capsGained_mc:MovieClip;
      
      public var capsBonus_mc:MovieClip;
      
      public var pvpVsText_mc:MovieClip;
      
      public var pvpPlayerIcon0:MovieClip;
      
      public var pvpPlayerIcon1:MovieClip;
      
      public var pvpPlayerIcon2:MovieClip;
      
      public var pvpPlayerIcon3:MovieClip;
      
      public var pvpEnemyIcon0:MovieClip;
      
      public var pvpEnemyIcon1:MovieClip;
      
      public var pvpEnemyIcon2:MovieClip;
      
      public var pvpEnemyIcon3:MovieClip;
      
      public var pvpPlayerScoreText_mc:MovieClip;
      
      public var pvpEnemyScoreText_mc:MovieClip;
      
      public var pvpStrokeColor_mc:MovieClip;
      
      public var pvpDeathXFrames_mc:MovieClip;
      
      public var pvpArrowMarkerFrames_mc:MovieClip;
      
      public var pvpIdentifierFrames_mc:MovieClip;
      
      private var m_Data:Object;
      
      public function HUDPvPScoreboardTeam()
      {
         var _loc1_:uint = 0;
         var _loc2_:ImageFixture = null;
         super();
         addFrameScript(9,this.frame10);
         _loc1_ = 0;
         while(_loc1_ < PLAYERS_MAX)
         {
            _loc2_ = this["pvpPlayerIcon" + _loc1_].pvpIconTransform_mc.PlayerIcon_mc as ImageFixture;
            _loc2_.clipWidth = _loc2_.width * (1 / _loc2_.scaleX);
            _loc2_.clipHeight = _loc2_.height * (1 / _loc2_.scaleY);
            _loc2_ = this["pvpEnemyIcon" + _loc1_].pvpIconTransform_mc.PlayerIcon_mc as ImageFixture;
            _loc2_.clipWidth = _loc2_.width * (1 / _loc2_.scaleX);
            _loc2_.clipHeight = _loc2_.height * (1 / _loc2_.scaleY);
            _loc1_++;
         }
      }
      
      public function get data() : Object
      {
         return this.m_Data;
      }
      
      public function set data(param1:Object) : void
      {
         var _loc5_:uint = 0;
         this.m_Data = param1;
         this.capsGained_mc.capsGained_tf.text = param1.capsGained;
         this.capsBonus_mc.capsBonus_tf.text = param1.capsBonus;
         var _loc2_:String = "Player";
         var _loc3_:String = "Enemy";
         var _loc4_:String = "gold";
         if(this.m_Data.type == HUDPvPScoreboard.TYPE_TEAMDEATH)
         {
            _loc2_ = "Enemy";
            _loc3_ = "Player";
            _loc4_ = "red";
         }
         this.pvpStrokeColor_mc.gotoAndStop(_loc4_);
         this.pvpVsText_mc.gotoAndStop(_loc4_);
         this.pvpPlayerScoreText_mc.gotoAndStop(_loc4_);
         this.pvpEnemyScoreText_mc.gotoAndStop(_loc4_);
         this.pvpIdentifierFrames_mc.pvpIdentifier_mc.gotoAndStop(_loc4_);
         this.pvpArrowMarkerFrames_mc.pvpArrowMarker_mc.pvpArrowMarkerContainer_mc.gotoAndStop(_loc4_);
         this.pvpDeathXFrames_mc.gotoAndStop(_loc3_ + this.m_Data.deadMemberIndex);
         this.pvpArrowMarkerFrames_mc.gotoAndStop(_loc2_ + this.m_Data.actingMemberIndex);
         this.pvpIdentifierFrames_mc.gotoAndStop(_loc2_ + this.m_Data.actingMemberIndex);
         _loc5_ = 0;
         while(_loc5_ < PLAYERS_MAX)
         {
            if(_loc5_ < param1.team.length)
            {
               this["pvpPlayerIcon" + _loc5_].visible = true;
               this["pvpPlayerIcon" + _loc5_].pvpIconTransform_mc.PlayerIcon_mc.LoadInternal(GlobalFunc.GetAccountIconPath(param1.team[_loc5_].avatarId),GlobalFunc.PLAYER_ICON_TEXTURE_BUFFER);
            }
            else
            {
               this["pvpPlayerIcon" + _loc5_].visible = false;
            }
            if(_loc5_ < param1.enemies.length)
            {
               this["pvpEnemyIcon" + _loc5_].visible = true;
               this["pvpEnemyIcon" + _loc5_].pvpIconTransform_mc.PlayerIcon_mc.LoadInternal(GlobalFunc.GetAccountIconPath(param1.enemies[_loc5_].avatarId),GlobalFunc.PLAYER_ICON_TEXTURE_BUFFER);
            }
            else
            {
               this["pvpEnemyIcon" + _loc5_].visible = false;
            }
            if(this.m_Data.type == HUDPvPScoreboard.TYPE_TEAMDEATH)
            {
               if(_loc5_ == this.m_Data.deadMemberIndex)
               {
                  this["pvpPlayerIcon" + _loc5_].gotoAndStop("teamInactive");
               }
               else
               {
                  this["pvpPlayerIcon" + _loc5_].gotoAndStop("teamActive");
               }
               this["pvpEnemyIcon" + _loc5_].gotoAndStop("teamActive");
            }
            else
            {
               if(_loc5_ == this.m_Data.deadMemberIndex)
               {
                  this["pvpEnemyIcon" + _loc5_].gotoAndStop("teamInactive");
               }
               else
               {
                  this["pvpEnemyIcon" + _loc5_].gotoAndStop("teamActive");
               }
               this["pvpPlayerIcon" + _loc5_].gotoAndStop("teamActive");
            }
            _loc5_++;
         }
         this.pvpPlayerScoreText_mc.pvpPlayerScoreText_tf.text = param1.playerScore;
         this.pvpEnemyScoreText_mc.pvpEnemyScoreText_tf.text = param1.enemyScore;
         this.pvpIdentifierFrames_mc.pvpIdentifier_mc.pvpIdentifier_tf.text = "$KILLER";
         this.pvpDeathXFrames_mc.pvpDeathX_mc.gotoAndPlay("rollOn");
      }
      
      internal function frame10() : *
      {
         stop();
      }
   }
}

