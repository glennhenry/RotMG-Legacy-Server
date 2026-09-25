package kabam.rotmg.classes.view
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import kabam.lib.ui.api.Size;
   import kabam.rotmg.util.components.VerticalScrollingList;
   
   public class CharacterSkinListView extends Sprite
   {
      
      public static const PADDING:int = 5;
      
      public static const WIDTH:int = 442;
      
      public static const HEIGHT:int = 400;
      
      private const list:VerticalScrollingList = this.makeList();
      
      private var items:Vector.<DisplayObject>;
      
      public function CharacterSkinListView()
      {
         super();
      }
      
      private function makeList() : VerticalScrollingList
      {
         var _loc1_:VerticalScrollingList = new VerticalScrollingList();
         _loc1_.setSize(new Size(WIDTH,HEIGHT));
         _loc1_.scrollStateChanged.add(this.onScrollStateChanged);
         _loc1_.setPadding(PADDING);
         addChild(_loc1_);
         return _loc1_;
      }
      
      public function setItems(param1:Vector.<DisplayObject>) : void
      {
         this.items = param1;
         this.list.setItems(param1);
         this.onScrollStateChanged(this.list.isScrollbarVisible());
      }
      
      private function onScrollStateChanged(param1:Boolean) : void
      {
         var _loc3_:CharacterSkinListItem = null;
         var _loc2_:int = CharacterSkinListItem.WIDTH;
         if(!param1)
         {
            _loc2_ += VerticalScrollingList.SCROLLBAR_GUTTER;
         }
         for each(_loc3_ in this.items)
         {
            _loc3_.setWidth(_loc2_);
         }
      }
      
      public function getListHeight() : Number
      {
         return this.list.getListHeight();
      }
   }
}

