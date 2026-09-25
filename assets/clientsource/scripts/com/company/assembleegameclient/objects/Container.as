package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.map.Map;
   import com.company.assembleegameclient.sound.SoundEffectLibrary;
   import com.company.assembleegameclient.ui.panels.Panel;
   import com.company.assembleegameclient.ui.panels.itemgrids.ContainerGrid;
   import com.company.util.PointUtil;
   
   public class Container extends GameObject implements IInteractiveObject
   {
      
      public var isLoot_:Boolean;
      
      public var ownerId_:String;
      
      public function Container(param1:XML)
      {
         super(param1);
         isInteractive_ = true;
         this.isLoot_ = param1.hasOwnProperty("Loot");
         this.ownerId_ = "";
      }
      
      public function setOwnerId(param1:String) : void
      {
         this.ownerId_ = param1;
         isInteractive_ = this.ownerId_ == "" || this.isBoundToCurrentAccount();
      }
      
      public function isBoundToCurrentAccount() : Boolean
      {
         return map_.player_.accountId_ == this.ownerId_;
      }
      
      override public function addTo(param1:Map, param2:Number, param3:Number) : Boolean
      {
         if(!super.addTo(param1,param2,param3))
         {
            return false;
         }
         if(map_.player_ == null)
         {
            return true;
         }
         var _loc4_:Number = PointUtil.distanceXY(map_.player_.x_,map_.player_.y_,param2,param3);
         if(this.isLoot_ && _loc4_ < 10)
         {
            SoundEffectLibrary.play("loot_appears");
         }
         return true;
      }
      
      public function getPanel(param1:GameSprite) : Panel
      {
         var _loc2_:Player = Boolean(param1) && Boolean(param1.map) ? param1.map.player_ : null;
         return new ContainerGrid(this,_loc2_);
      }
   }
}

