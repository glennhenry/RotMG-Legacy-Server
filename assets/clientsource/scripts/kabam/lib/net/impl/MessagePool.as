package kabam.lib.net.impl
{
   public class MessagePool
   {
      
      public var type:Class;
      
      public var callback:Function;
      
      public var id:int;
      
      private var tail:Message;
      
      private var count:int = 0;
      
      public function MessagePool(param1:int, param2:Class, param3:Function)
      {
         super();
         this.type = param2;
         this.id = param1;
         this.callback = param3;
      }
      
      public function populate(param1:int) : MessagePool
      {
         var _loc2_:Message = null;
         this.count += param1;
         while(param1--)
         {
            _loc2_ = new this.type(this.id,this.callback);
            _loc2_.pool = this;
            this.tail && (this.tail.next = _loc2_);
            _loc2_.prev = this.tail;
            this.tail = _loc2_;
         }
         return this;
      }
      
      public function require() : Message
      {
         var _loc1_:Message = this.tail;
         if(_loc1_)
         {
            this.tail = this.tail.prev;
            _loc1_.prev = null;
            _loc1_.next = null;
         }
         else
         {
            _loc1_ = new this.type(this.id,this.callback);
            _loc1_.pool = this;
            ++this.count;
         }
         return _loc1_;
      }
      
      public function getCount() : int
      {
         return this.count;
      }
      
      internal function append(param1:Message) : void
      {
         this.tail && (this.tail.next = param1);
         param1.prev = this.tail;
         this.tail = param1;
      }
      
      public function dispose() : void
      {
         this.tail = null;
      }
   }
}

