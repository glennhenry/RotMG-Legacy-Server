package kabam.rotmg.pets.view.components
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import kabam.lib.ui.impl.LayoutList;
   import kabam.lib.ui.impl.VerticalLayout;
   import kabam.rotmg.ui.view.SignalWaiter;
   import org.osflash.signals.Signal;
   
   public class CaretakerQueryDialogCategoryList extends LayoutList
   {
      
      private const waiter:SignalWaiter = new SignalWaiter();
      
      public const ready:Signal = this.waiter.complete;
      
      public const selected:Signal = new Signal(String);
      
      public function CaretakerQueryDialogCategoryList(param1:Array)
      {
         super();
         setLayout(this.makeLayout());
         setItems(this.makeItems(param1));
         this.ready.addOnce(updateLayout);
      }
      
      private function makeLayout() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.setPadding(2);
         return _loc1_;
      }
      
      private function makeItems(param1:Array) : Vector.<DisplayObject>
      {
         var _loc2_:Vector.<DisplayObject> = new Vector.<DisplayObject>();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(this.makeItem(param1[_loc3_]));
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function makeItem(param1:Object) : CaretakerQueryDialogCategoryItem
      {
         var _loc2_:CaretakerQueryDialogCategoryItem = new CaretakerQueryDialogCategoryItem(param1.category,param1.info);
         _loc2_.addEventListener(MouseEvent.CLICK,this.onClick);
         this.waiter.push(_loc2_.textChanged);
         return _loc2_;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:CaretakerQueryDialogCategoryItem = param1.currentTarget as CaretakerQueryDialogCategoryItem;
         this.selected.dispatch(_loc2_.info);
      }
   }
}

