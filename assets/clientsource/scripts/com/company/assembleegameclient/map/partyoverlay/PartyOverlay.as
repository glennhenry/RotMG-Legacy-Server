package com.company.assembleegameclient.map.partyoverlay
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Map;
   import com.company.assembleegameclient.objects.Party;
   import com.company.assembleegameclient.objects.Player;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class PartyOverlay extends Sprite
   {
      
      public var map_:Map;
      
      public var partyMemberArrows_:Vector.<PlayerArrow> = null;
      
      public var questArrow_:QuestArrow;
      
      public function PartyOverlay(param1:Map)
      {
         var _loc3_:PlayerArrow = null;
         super();
         this.map_ = param1;
         this.partyMemberArrows_ = new Vector.<PlayerArrow>(Party.NUM_MEMBERS,true);
         var _loc2_:int = 0;
         while(_loc2_ < Party.NUM_MEMBERS)
         {
            _loc3_ = new PlayerArrow();
            this.partyMemberArrows_[_loc2_] = _loc3_;
            addChild(_loc3_);
            _loc2_++;
         }
         this.questArrow_ = new QuestArrow(this.map_);
         addChild(this.questArrow_);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         GameObjectArrow.removeMenu();
      }
      
      public function draw(param1:Camera, param2:int) : void
      {
         var _loc6_:PlayerArrow = null;
         var _loc7_:Player = null;
         var _loc8_:int = 0;
         var _loc9_:PlayerArrow = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(this.map_.player_ == null)
         {
            return;
         }
         var _loc3_:Party = this.map_.party_;
         var _loc4_:Player = this.map_.player_;
         var _loc5_:int = 0;
         while(_loc5_ < Party.NUM_MEMBERS)
         {
            _loc6_ = this.partyMemberArrows_[_loc5_];
            if(!_loc6_.mouseOver_)
            {
               if(_loc5_ >= _loc3_.members_.length)
               {
                  _loc6_.setGameObject(null);
               }
               else
               {
                  _loc7_ = _loc3_.members_[_loc5_];
                  if(_loc7_.drawn_ || _loc7_.map_ == null || _loc7_.dead_)
                  {
                     _loc6_.setGameObject(null);
                  }
                  else
                  {
                     _loc6_.setGameObject(_loc7_);
                     _loc8_ = 0;
                     while(_loc8_ < _loc5_)
                     {
                        _loc9_ = this.partyMemberArrows_[_loc8_];
                        _loc10_ = _loc6_.x - _loc9_.x;
                        _loc11_ = _loc6_.y - _loc9_.y;
                        if(_loc10_ * _loc10_ + _loc11_ * _loc11_ < 64)
                        {
                           if(!_loc9_.mouseOver_)
                           {
                              _loc9_.addGameObject(_loc7_);
                           }
                           _loc6_.setGameObject(null);
                           break;
                        }
                        _loc8_++;
                     }
                     _loc6_.draw(param2,param1);
                  }
               }
            }
            _loc5_++;
         }
         if(!this.questArrow_.mouseOver_)
         {
            this.questArrow_.draw(param2,param1);
         }
      }
   }
}

