package kabam.rotmg.friends.view
{
   import com.company.assembleegameclient.ui.Scrollbar;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class FriendListContainer extends Sprite
   {
      
      private const GAP_Y:int = 3;
      
      private var _currentY:int;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _itemContainer:Sprite;
      
      private var _scrollbar:Scrollbar;
      
      public function FriendListContainer(param1:Number, param2:Number)
      {
         super();
         this._currentY = 0;
         this._width = param1;
         this._height = param2;
         var _loc3_:Shape = new Shape();
         _loc3_.graphics.beginFill(2245785);
         _loc3_.graphics.drawRect(0,0,this._width,this._height);
         _loc3_.graphics.endFill();
         addChild(_loc3_);
         this.mask = _loc3_;
         this._itemContainer = new Sprite();
         addChild(this._itemContainer);
         this._scrollbar = new Scrollbar(16,this._height);
         this._scrollbar.x = this._width - 18;
         this._scrollbar.y = 0;
         this._scrollbar.visible = false;
         this._scrollbar.addEventListener(Event.CHANGE,this.onScrollBarChange);
         addChild(this._scrollbar);
      }
      
      public function addListItem(param1:FListItem) : void
      {
         param1.y = this._currentY;
         this._itemContainer.addChild(param1);
         this._currentY += param1.height + this.GAP_Y;
         this.updateScrollbar(this._currentY > this._height);
      }
      
      public function getTotal() : int
      {
         return this._itemContainer.numChildren;
      }
      
      override public function getChildAt(param1:int) : DisplayObject
      {
         return this._itemContainer.getChildAt(param1) as Sprite;
      }
      
      override public function removeChildAt(param1:int) : DisplayObject
      {
         var _loc2_:Sprite = this._itemContainer.getChildAt(param1) as Sprite;
         if(_loc2_ != null)
         {
            this._currentY -= _loc2_.height + this.GAP_Y;
         }
         return this._itemContainer.removeChildAt(param1) as Sprite;
      }
      
      public function clear() : void
      {
         while(this._itemContainer.numChildren > 0)
         {
            this._itemContainer.removeChildAt(this._itemContainer.numChildren - 1);
         }
         this._currentY = 0;
      }
      
      private function updateScrollbar(param1:Boolean) : void
      {
         this._scrollbar.visible = param1;
         if(param1)
         {
            this._scrollbar.setIndicatorSize(this._height,this._currentY);
         }
      }
      
      private function onScrollBarChange(param1:Event) : void
      {
         this._itemContainer.y = -this._scrollbar.pos() * (this._itemContainer.height - this._height + 20);
      }
   }
}

