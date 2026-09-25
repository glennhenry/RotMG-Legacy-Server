package kabam.lib.ui.impl
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import kabam.lib.ui.api.Layout;
   import kabam.lib.ui.api.List;
   import kabam.lib.ui.api.Size;
   import org.osflash.signals.Signal;
   
   public class LayoutList extends Sprite implements List
   {
      
      private static const NULL_LAYOUT:Layout = new NullLayout();
      
      private static const ZERO_SIZE:Size = new Size(0,0);
      
      public const itemsChanged:Signal = new Signal();
      
      private const list:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      private const container:Sprite = new Sprite();
      
      private const containerMask:Shape = new Shape();
      
      private var layout:Layout = NULL_LAYOUT;
      
      private var size:Size = ZERO_SIZE;
      
      private var offset:int = 0;
      
      public function LayoutList()
      {
         super();
         addChild(this.container);
         addChild(this.containerMask);
      }
      
      public function getLayout() : Layout
      {
         return this.layout;
      }
      
      public function setLayout(param1:Layout) : void
      {
         this.layout = param1 || NULL_LAYOUT;
         param1.layout(this.list,-this.offset);
      }
      
      public function getSize() : Size
      {
         return this.size;
      }
      
      public function setSize(param1:Size) : void
      {
         this.size = param1 || ZERO_SIZE;
         this.applySizeToMask();
      }
      
      public function getSizeOfItems() : Size
      {
         var _loc1_:Rectangle = this.container.getRect(this.container);
         return new Size(_loc1_.width,_loc1_.height);
      }
      
      private function applySizeToMask() : void
      {
         var _loc1_:Graphics = this.containerMask.graphics;
         _loc1_.clear();
         _loc1_.beginFill(10027263);
         _loc1_.drawRect(0,0,this.size.width,this.size.height);
         _loc1_.endFill();
         this.container.mask = this.containerMask;
      }
      
      public function addItem(param1:DisplayObject) : void
      {
         this.addToListAndContainer(param1);
         this.updateLayout();
         this.itemsChanged.dispatch();
      }
      
      public function getItemAt(param1:int) : DisplayObject
      {
         return this.list[param1];
      }
      
      public function setItems(param1:Vector.<DisplayObject>) : void
      {
         this.clearList();
         this.addItemsToListAndContainer(param1);
         this.offset = 0;
         this.updateLayout();
         this.itemsChanged.dispatch();
      }
      
      public function getItemCount() : int
      {
         return this.list.length;
      }
      
      private function clearList() : void
      {
         var _loc1_:* = int(this.list.length);
         while(_loc1_--)
         {
            this.container.removeChild(this.list[_loc1_]);
         }
         this.list.length = 0;
      }
      
      private function addItemsToListAndContainer(param1:Vector.<DisplayObject>) : void
      {
         var _loc2_:DisplayObject = null;
         for each(_loc2_ in param1)
         {
            this.addToListAndContainer(_loc2_);
         }
      }
      
      private function addToListAndContainer(param1:DisplayObject) : void
      {
         this.list.push(param1);
         this.container.addChild(param1);
      }
      
      public function setOffset(param1:int) : void
      {
         this.offset = param1;
         this.updateLayout();
      }
      
      public function getOffset() : int
      {
         return this.offset;
      }
      
      public function updateLayout() : void
      {
         this.layout.layout(this.list,-this.offset);
      }
   }
}

