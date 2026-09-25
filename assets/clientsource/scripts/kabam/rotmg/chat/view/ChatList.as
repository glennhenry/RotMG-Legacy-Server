package kabam.rotmg.chat.view
{
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import kabam.rotmg.chat.model.ChatModel;
   
   public class ChatList extends Sprite
   {
      
      private var listItems:Vector.<ChatListItem>;
      
      private var visibleItems:Vector.<ChatListItem>;
      
      private var visibleItemCount:int;
      
      private var index:int;
      
      private var isCurrent:Boolean;
      
      private const timer:Timer = new Timer(1000);
      
      private const itemsToRemove:Vector.<ChatListItem> = new Vector.<ChatListItem>();
      
      private var ignoreTimeOuts:Boolean = false;
      
      private var maxLength:int;
      
      public function ChatList(param1:int = 7, param2:uint = 150)
      {
         super();
         mouseEnabled = true;
         mouseChildren = true;
         this.listItems = new Vector.<ChatListItem>();
         this.visibleItems = new Vector.<ChatListItem>();
         this.visibleItemCount = param1;
         this.maxLength = param2;
         this.index = 0;
         this.isCurrent = true;
         this.timer.addEventListener(TimerEvent.TIMER,this.onCheckTimeout);
         this.timer.start();
      }
      
      private function onCheckTimeout(param1:TimerEvent) : void
      {
         var _loc2_:ChatListItem = null;
         var _loc3_:ChatListItem = null;
         for each(_loc2_ in this.visibleItems)
         {
            if(!(_loc2_.isTimedOut() && !this.ignoreTimeOuts))
            {
               break;
            }
            this.itemsToRemove.push(_loc2_);
         }
         while(this.itemsToRemove.length > 0)
         {
            this.onItemTimedOut(this.itemsToRemove.pop());
            if(!this.isCurrent)
            {
               _loc3_ = this.listItems[this.index++];
               if(!_loc3_.isTimedOut())
               {
                  this.addNewItem(_loc3_);
                  this.isCurrent = this.index == this.listItems.length;
                  this.positionItems();
               }
            }
         }
      }
      
      public function setup(param1:ChatModel) : void
      {
         this.visibleItemCount = param1.visibleItemCount;
      }
      
      public function addMessage(param1:ChatListItem) : void
      {
         var _loc2_:ChatListItem = null;
         if(this.listItems.length > this.maxLength)
         {
            _loc2_ = this.listItems.shift();
            this.onItemTimedOut(_loc2_);
            --this.index;
            if(!this.isCurrent && this.index < this.visibleItemCount)
            {
               this.pageDown();
            }
         }
         this.listItems.push(param1);
         if(this.isCurrent)
         {
            this.displayNewItem(param1);
         }
      }
      
      private function onItemTimedOut(param1:ChatListItem) : void
      {
         var _loc2_:int = this.visibleItems.indexOf(param1);
         if(_loc2_ != -1)
         {
            removeChild(param1);
            this.visibleItems.splice(_loc2_,1);
            this.isCurrent = this.index == this.listItems.length;
         }
      }
      
      private function displayNewItem(param1:ChatListItem) : void
      {
         ++this.index;
         this.addNewItem(param1);
         this.removeOldestVisibleIfNeeded();
         this.positionItems();
      }
      
      public function scrollUp() : void
      {
         if(this.ignoreTimeOuts && this.canScrollUp())
         {
            this.scrollItemsUp();
         }
         else
         {
            this.showAvailable();
         }
         this.ignoreTimeOuts = true;
      }
      
      public function showAvailable() : void
      {
         var _loc4_:ChatListItem = null;
         var _loc1_:int = this.index - this.visibleItems.length - 1;
         var _loc2_:int = Math.max(0,this.index - this.visibleItemCount - 1);
         var _loc3_:* = _loc1_;
         while(_loc3_ > _loc2_)
         {
            _loc4_ = this.listItems[_loc3_];
            if(this.visibleItems.indexOf(_loc4_) == -1)
            {
               this.addOldItem(_loc4_);
            }
            _loc3_--;
         }
         this.positionItems();
      }
      
      public function scrollDown() : void
      {
         if(this.ignoreTimeOuts)
         {
            this.ignoreTimeOuts = false;
            this.scrollToCurrent();
            this.onCheckTimeout(null);
         }
         if(!this.isCurrent)
         {
            this.scrollItemsDown();
         }
         else if(this.ignoreTimeOuts)
         {
            this.ignoreTimeOuts = false;
         }
      }
      
      public function scrollToCurrent() : void
      {
         while(!this.isCurrent)
         {
            this.scrollItemsDown();
         }
      }
      
      public function pageUp() : void
      {
         var _loc1_:int = 0;
         if(!this.ignoreTimeOuts)
         {
            this.showAvailable();
            this.ignoreTimeOuts = true;
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < this.visibleItemCount)
            {
               if(!this.canScrollUp())
               {
                  break;
               }
               this.scrollItemsUp();
               _loc1_++;
            }
         }
      }
      
      public function pageDown() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.visibleItemCount)
         {
            if(this.isCurrent)
            {
               this.ignoreTimeOuts = false;
               break;
            }
            this.scrollItemsDown();
            _loc1_++;
         }
      }
      
      private function addNewItem(param1:ChatListItem) : void
      {
         this.visibleItems.push(param1);
         addChild(param1);
      }
      
      private function removeOldestVisibleIfNeeded() : void
      {
         if(this.visibleItems.length > this.visibleItemCount)
         {
            removeChild(this.visibleItems.shift());
         }
      }
      
      private function canScrollUp() : Boolean
      {
         return this.index > this.visibleItemCount;
      }
      
      private function scrollItemsUp() : void
      {
         var _loc1_:ChatListItem = this.listItems[--this.index - this.visibleItemCount];
         this.addOldItem(_loc1_);
         this.removeNewestVisibleIfNeeded();
         this.positionItems();
         this.isCurrent = false;
      }
      
      private function scrollItemsDown() : void
      {
         if(this.index < 0)
         {
            this.index = 0;
         }
         var _loc1_:ChatListItem = this.listItems[this.index];
         ++this.index;
         this.addNewItem(_loc1_);
         this.removeOldestVisibleIfNeeded();
         this.isCurrent = this.index == this.listItems.length;
         this.positionItems();
      }
      
      private function addOldItem(param1:ChatListItem) : void
      {
         this.visibleItems.unshift(param1);
         addChild(param1);
      }
      
      private function removeNewestVisibleIfNeeded() : void
      {
         if(this.visibleItems.length > this.visibleItemCount)
         {
            removeChild(this.visibleItems.pop());
         }
      }
      
      private function positionItems() : void
      {
         var _loc3_:ChatListItem = null;
         var _loc1_:int = 0;
         var _loc2_:* = int(this.visibleItems.length);
         while(_loc2_--)
         {
            _loc3_ = this.visibleItems[_loc2_];
            _loc3_.y = _loc1_;
            _loc1_ -= _loc3_.height;
         }
      }
   }
}

