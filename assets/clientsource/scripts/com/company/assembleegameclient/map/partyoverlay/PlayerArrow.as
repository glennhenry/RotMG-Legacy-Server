package com.company.assembleegameclient.map.partyoverlay
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.menu.Menu;
   import com.company.assembleegameclient.ui.menu.PlayerGroupMenu;
   import com.company.assembleegameclient.ui.tooltip.PlayerGroupToolTip;
   import flash.events.MouseEvent;
   
   public class PlayerArrow extends GameObjectArrow
   {
      
      public function PlayerArrow()
      {
         super(16777215,4179794,false);
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
         super.onMouseOver(param1);
         setToolTip(new PlayerGroupToolTip(this.getFullPlayerVec(),false));
      }
      
      override protected function onMouseOut(param1:MouseEvent) : void
      {
         super.onMouseOut(param1);
         setToolTip(null);
      }
      
      override protected function onMouseDown(param1:MouseEvent) : void
      {
         super.onMouseDown(param1);
         removeMenu();
         setMenu(this.getMenu());
      }
      
      protected function getMenu() : Menu
      {
         var _loc1_:Player = go_ as Player;
         if(_loc1_ == null || _loc1_.map_ == null)
         {
            return null;
         }
         var _loc2_:Player = _loc1_.map_.player_;
         if(_loc2_ == null)
         {
            return null;
         }
         return new PlayerGroupMenu(_loc1_.map_,this.getFullPlayerVec());
      }
      
      private function getFullPlayerVec() : Vector.<Player>
      {
         var _loc2_:GameObject = null;
         var _loc1_:Vector.<Player> = new <Player>[go_ as Player];
         for each(_loc2_ in extraGOs_)
         {
            _loc1_.push(_loc2_ as Player);
         }
         return _loc1_;
      }
   }
}

