package com.company.assembleegameclient.ui.panels.itemgrids
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InteractiveItemTile;
   
   public class ContainerGrid extends ItemGrid
   {
      
      private const NUM_SLOTS:uint = 8;
      
      private var tiles:Vector.<InteractiveItemTile>;
      
      public function ContainerGrid(param1:GameObject, param2:Player)
      {
         var _loc4_:InteractiveItemTile = null;
         super(param1,param2,0);
         this.tiles = new Vector.<InteractiveItemTile>(this.NUM_SLOTS);
         var _loc3_:int = 0;
         while(_loc3_ < this.NUM_SLOTS)
         {
            _loc4_ = new InteractiveItemTile(_loc3_ + indexOffset,this,interactive);
            addToGrid(_loc4_,2,_loc3_);
            this.tiles[_loc3_] = _loc4_;
            _loc3_++;
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

