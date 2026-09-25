package com.company.assembleegameclient.ui.panels.itemgrids
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.EquipmentTile;
   import com.company.util.ArrayIterator;
   import com.company.util.IIterator;
   import kabam.lib.util.VectorAS3Util;
   
   public class EquippedGrid extends ItemGrid
   {
      
      public static const NUM_SLOTS:uint = 4;
      
      private var tiles:Vector.<EquipmentTile>;
      
      public function EquippedGrid(param1:GameObject, param2:Vector.<int>, param3:Player, param4:int = 0)
      {
         var _loc6_:EquipmentTile = null;
         super(param1,param3,param4);
         this.tiles = new Vector.<EquipmentTile>(NUM_SLOTS);
         var _loc5_:int = 0;
         while(_loc5_ < NUM_SLOTS)
         {
            _loc6_ = new EquipmentTile(_loc5_,this,interactive);
            addToGrid(_loc6_,1,_loc5_);
            _loc6_.setType(param2[_loc5_]);
            this.tiles[_loc5_] = _loc6_;
            _loc5_++;
         }
      }
      
      public function createInteractiveItemTileIterator() : IIterator
      {
         return new ArrayIterator(VectorAS3Util.toArray(this.tiles));
      }
      
      override public function setItems(param1:Vector.<int>, param2:int = 0) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1)
         {
            _loc3_ = int(param1.length);
            _loc4_ = 0;
            while(_loc4_ < this.tiles.length)
            {
               if(_loc4_ + param2 < _loc3_)
               {
                  this.tiles[_loc4_].setItem(param1[_loc4_ + param2]);
               }
               else
               {
                  this.tiles[_loc4_].setItem(-1);
               }
               this.tiles[_loc4_].updateDim(curPlayer);
               _loc4_++;
            }
         }
      }
   }
}

