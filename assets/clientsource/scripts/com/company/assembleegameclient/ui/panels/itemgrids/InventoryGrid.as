package com.company.assembleegameclient.ui.panels.itemgrids
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InventoryTile;
   
   public class InventoryGrid extends ItemGrid
   {
      
      private const NUM_SLOTS:uint = 8;
      
      private var tiles:Vector.<InventoryTile>;
      
      private var isBackpack:Boolean;
      
      public function InventoryGrid(param1:GameObject, param2:Player, param3:int = 0, param4:Boolean = false)
      {
         var _loc6_:InventoryTile = null;
         super(param1,param2,param3);
         this.tiles = new Vector.<InventoryTile>(this.NUM_SLOTS);
         this.isBackpack = param4;
         var _loc5_:int = 0;
         while(_loc5_ < this.NUM_SLOTS)
         {
            _loc6_ = new InventoryTile(_loc5_ + indexOffset,this,interactive);
            _loc6_.addTileNumber(_loc5_ + 1);
            addToGrid(_loc6_,2,_loc5_);
            this.tiles[_loc5_] = _loc6_;
            _loc5_++;
         }
      }
      
      override public function setItems(param1:Vector.<int>, param2:int = 0) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1)
         {
            _loc3_ = false;
            _loc4_ = int(param1.length);
            _loc5_ = 0;
            while(_loc5_ < this.NUM_SLOTS)
            {
               if(_loc5_ + indexOffset < _loc4_)
               {
                  if(this.tiles[_loc5_].setItem(param1[_loc5_ + indexOffset]))
                  {
                     _loc3_ = true;
                  }
               }
               else if(this.tiles[_loc5_].setItem(-1))
               {
                  _loc3_ = true;
               }
               _loc5_++;
            }
            if(_loc3_)
            {
               refreshTooltip();
            }
         }
      }
   }
}

