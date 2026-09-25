package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.map.Map;
   import com.company.util.PointUtil;
   import flash.utils.Dictionary;
   import kabam.rotmg.messaging.impl.incoming.AccountList;
   
   public class Party
   {
      
      public static const NUM_MEMBERS:int = 6;
      
      private static const SORT_ON_FIELDS:Array = ["starred_","distSqFromThisPlayer_","objectId_"];
      
      private static const SORT_ON_PARAMS:Array = [Array.NUMERIC | Array.DESCENDING,Array.NUMERIC,Array.NUMERIC];
      
      private static const PARTY_DISTANCE_SQ:int = 50 * 50;
      
      public var map_:Map;
      
      public var members_:Array = [];
      
      private var starred_:Dictionary = new Dictionary(true);
      
      private var ignored_:Dictionary = new Dictionary(true);
      
      private var lastUpdate_:int = -2147483648;
      
      public function Party(param1:Map)
      {
         super();
         this.map_ = param1;
      }
      
      public function update(param1:int, param2:int) : void
      {
         var _loc4_:GameObject = null;
         var _loc5_:Player = null;
         if(param1 < this.lastUpdate_ + 500)
         {
            return;
         }
         this.lastUpdate_ = param1;
         this.members_.length = 0;
         var _loc3_:Player = this.map_.player_;
         if(_loc3_ == null)
         {
            return;
         }
         for each(_loc4_ in this.map_.goDict_)
         {
            _loc5_ = _loc4_ as Player;
            if(!(_loc5_ == null || _loc5_ == _loc3_))
            {
               _loc5_.starred_ = this.starred_[_loc5_.accountId_] != undefined;
               _loc5_.ignored_ = this.ignored_[_loc5_.accountId_] != undefined;
               _loc5_.distSqFromThisPlayer_ = PointUtil.distanceSquaredXY(_loc3_.x_,_loc3_.y_,_loc5_.x_,_loc5_.y_);
               if(!(_loc5_.distSqFromThisPlayer_ > PARTY_DISTANCE_SQ && !_loc5_.starred_))
               {
                  this.members_.push(_loc5_);
               }
            }
         }
         this.members_.sortOn(SORT_ON_FIELDS,SORT_ON_PARAMS);
         if(this.members_.length > NUM_MEMBERS)
         {
            this.members_.length = NUM_MEMBERS;
         }
      }
      
      public function lockPlayer(param1:Player) : void
      {
         this.starred_[param1.accountId_] = 1;
         this.lastUpdate_ = int.MIN_VALUE;
         this.map_.gs_.gsc_.editAccountList(0,true,param1.objectId_);
      }
      
      public function unlockPlayer(param1:Player) : void
      {
         delete this.starred_[param1.accountId_];
         param1.starred_ = false;
         this.lastUpdate_ = int.MIN_VALUE;
         this.map_.gs_.gsc_.editAccountList(0,false,param1.objectId_);
      }
      
      public function setStars(param1:AccountList) : void
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.accountIds_.length)
         {
            _loc3_ = param1.accountIds_[_loc2_];
            this.starred_[_loc3_] = 1;
            this.lastUpdate_ = int.MIN_VALUE;
            _loc2_++;
         }
      }
      
      public function removeStars(param1:AccountList) : void
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.accountIds_.length)
         {
            _loc3_ = param1.accountIds_[_loc2_];
            delete this.starred_[_loc3_];
            this.lastUpdate_ = int.MIN_VALUE;
            _loc2_++;
         }
      }
      
      public function ignorePlayer(param1:Player) : void
      {
         this.ignored_[param1.accountId_] = 1;
         this.lastUpdate_ = int.MIN_VALUE;
         this.map_.gs_.gsc_.editAccountList(1,true,param1.objectId_);
      }
      
      public function unignorePlayer(param1:Player) : void
      {
         delete this.ignored_[param1.accountId_];
         param1.ignored_ = false;
         this.lastUpdate_ = int.MIN_VALUE;
         this.map_.gs_.gsc_.editAccountList(1,false,param1.objectId_);
      }
      
      public function setIgnores(param1:AccountList) : void
      {
         var _loc3_:String = null;
         this.ignored_ = new Dictionary(true);
         var _loc2_:int = 0;
         while(_loc2_ < param1.accountIds_.length)
         {
            _loc3_ = param1.accountIds_[_loc2_];
            this.ignored_[_loc3_] = 1;
            this.lastUpdate_ = int.MIN_VALUE;
            _loc2_++;
         }
      }
   }
}

