package kabam.rotmg.arena.view
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import kabam.lib.ui.api.Size;
   import kabam.rotmg.arena.model.ArenaLeaderboardEntry;
   import kabam.rotmg.util.components.VerticalScrollingList;
   
   public class ArenaLeaderboardList extends Sprite
   {
      
      private const MAX_SIZE:int = 20;
      
      private var listItemPool:Vector.<DisplayObject> = new Vector.<DisplayObject>(this.MAX_SIZE);
      
      private var scrollList:VerticalScrollingList = new VerticalScrollingList();
      
      public function ArenaLeaderboardList()
      {
         super();
         var _loc1_:int = 0;
         while(_loc1_ < this.MAX_SIZE)
         {
            this.listItemPool[_loc1_] = new ArenaLeaderboardListItem();
            _loc1_++;
         }
         this.scrollList.setSize(new Size(786,400));
         addChild(this.scrollList);
      }
      
      public function setItems(param1:Vector.<ArenaLeaderboardEntry>, param2:Boolean) : void
      {
         var _loc4_:ArenaLeaderboardEntry = null;
         var _loc5_:ArenaLeaderboardListItem = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.listItemPool.length)
         {
            _loc4_ = _loc3_ < param1.length ? param1[_loc3_] : null;
            _loc5_ = this.listItemPool[_loc3_] as ArenaLeaderboardListItem;
            _loc5_.apply(_loc4_,param2);
            _loc3_++;
         }
         this.scrollList.setItems(this.listItemPool);
      }
   }
}

