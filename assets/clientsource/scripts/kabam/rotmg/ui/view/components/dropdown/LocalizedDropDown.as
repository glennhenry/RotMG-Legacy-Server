package kabam.rotmg.ui.view.components.dropdown
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import kabam.rotmg.ui.view.SignalWaiter;
   
   public class LocalizedDropDown extends Sprite
   {
      
      protected var strings_:Vector.<String>;
      
      protected var w_:int = 0;
      
      protected const h_:int = 36;
      
      protected var selected_:LocalizedDropDownItem;
      
      private var items_:Vector.<LocalizedDropDownItem> = new Vector.<LocalizedDropDownItem>();
      
      private var all_:Sprite = new Sprite();
      
      private var waiter:SignalWaiter = new SignalWaiter();
      
      public function LocalizedDropDown(param1:Vector.<String>)
      {
         super();
         this.strings_ = param1;
         this.makeDropDownItems();
         this.updateView();
         addChild(this.all_);
         this.all_.visible = false;
         this.waiter.complete.addOnce(this.onComplete);
      }
      
      public function getValue() : String
      {
         return this.selected_.getValue();
      }
      
      public function setValue(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc2_:int = this.strings_.indexOf(param1);
         if(_loc2_ > 0)
         {
            _loc3_ = this.strings_[0];
            this.strings_[_loc2_] = _loc3_;
            this.strings_[0] = param1;
            this.updateView();
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function getClosedHeight() : int
      {
         return this.h_;
      }
      
      private function makeDropDownItems() : void
      {
         var _loc1_:LocalizedDropDownItem = null;
         if(this.strings_.length > 0)
         {
            _loc1_ = this.makeDropDownItem(this.strings_[0]);
            this.items_.push(_loc1_);
            this.selected_ = _loc1_;
            this.selected_.addEventListener(MouseEvent.CLICK,this.onClick);
            addChild(this.selected_);
         }
         var _loc2_:int = 1;
         while(_loc2_ < this.strings_.length)
         {
            _loc1_ = this.makeDropDownItem(this.strings_[_loc2_]);
            _loc1_.addEventListener(MouseEvent.CLICK,this.onSelect);
            _loc1_.y = this.h_ * _loc2_;
            this.items_.push(_loc1_);
            this.all_.addChild(_loc1_);
            _loc2_++;
         }
      }
      
      private function makeDropDownItem(param1:String) : LocalizedDropDownItem
      {
         var _loc2_:LocalizedDropDownItem = new LocalizedDropDownItem(param1,0,this.h_);
         this.waiter.push(_loc2_.getTextChanged());
         return _loc2_;
      }
      
      private function updateView() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.strings_.length)
         {
            this.items_[_loc1_].setValue(this.strings_[_loc1_]);
            this.items_[_loc1_].setWidth(this.w_);
            _loc1_++;
         }
         if(this.items_.length > 0)
         {
            this.selected_ = this.items_[0];
         }
      }
      
      private function showAll() : void
      {
         this.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.all_.visible = true;
      }
      
      private function hideAll() : void
      {
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.all_.visible = false;
      }
      
      private function onComplete() : void
      {
         var _loc2_:LocalizedDropDownItem = null;
         var _loc1_:int = 83;
         for each(_loc2_ in this.items_)
         {
            _loc1_ = Math.max(_loc2_.width,_loc1_);
         }
         this.w_ = _loc1_;
         this.updateView();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         this.selected_.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.selected_.addEventListener(MouseEvent.CLICK,this.onSelect);
         this.showAll();
      }
      
      private function onSelect(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         this.selected_.addEventListener(MouseEvent.CLICK,this.onClick);
         this.selected_.removeEventListener(MouseEvent.CLICK,this.onSelect);
         this.hideAll();
         var _loc2_:LocalizedDropDownItem = param1.target as LocalizedDropDownItem;
         this.setValue(_loc2_.getValue());
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.selected_.addEventListener(MouseEvent.CLICK,this.onClick);
         this.selected_.removeEventListener(MouseEvent.CLICK,this.onSelect);
         this.hideAll();
      }
   }
}

