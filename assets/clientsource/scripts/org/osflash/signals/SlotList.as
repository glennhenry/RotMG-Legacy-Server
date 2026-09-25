package org.osflash.signals
{
   public final class SlotList
   {
      
      public static const NIL:SlotList = new SlotList(null,null);
      
      public var head:ISlot;
      
      public var tail:SlotList;
      
      public var nonEmpty:Boolean = false;
      
      public function SlotList(param1:ISlot, param2:SlotList = null)
      {
         super();
         if(!param1 && !param2)
         {
            if(NIL)
            {
               throw new ArgumentError("Parameters head and tail are null. Use the NIL element instead.");
            }
            this.nonEmpty = false;
         }
         else
         {
            if(!param1)
            {
               throw new ArgumentError("Parameter head cannot be null.");
            }
            this.head = param1;
            this.tail = param2 || NIL;
            this.nonEmpty = true;
         }
      }
      
      public function get length() : uint
      {
         if(!this.nonEmpty)
         {
            return 0;
         }
         if(this.tail == NIL)
         {
            return 1;
         }
         var _loc1_:uint = 0;
         var _loc2_:SlotList = this;
         while(_loc2_.nonEmpty)
         {
            _loc1_++;
            _loc2_ = _loc2_.tail;
         }
         return _loc1_;
      }
      
      public function prepend(param1:ISlot) : SlotList
      {
         return new SlotList(param1,this);
      }
      
      public function append(param1:ISlot) : SlotList
      {
         if(!param1)
         {
            return this;
         }
         if(!this.nonEmpty)
         {
            return new SlotList(param1);
         }
         if(this.tail == NIL)
         {
            return new SlotList(param1).prepend(this.head);
         }
         var _loc2_:SlotList = new SlotList(this.head);
         var _loc3_:SlotList = _loc2_;
         var _loc4_:SlotList = this.tail;
         while(_loc4_.nonEmpty)
         {
            _loc3_ = _loc3_.tail = new SlotList(_loc4_.head);
            _loc4_ = _loc4_.tail;
         }
         _loc3_.tail = new SlotList(param1);
         return _loc2_;
      }
      
      public function insertWithPriority(param1:ISlot) : SlotList
      {
         if(!this.nonEmpty)
         {
            return new SlotList(param1);
         }
         var _loc2_:int = param1.priority;
         if(_loc2_ > this.head.priority)
         {
            return this.prepend(param1);
         }
         var _loc3_:SlotList = new SlotList(this.head);
         var _loc4_:SlotList = _loc3_;
         var _loc5_:SlotList = this.tail;
         while(_loc5_.nonEmpty)
         {
            if(_loc2_ > _loc5_.head.priority)
            {
               _loc4_.tail = _loc5_.prepend(param1);
               return _loc3_;
            }
            _loc4_ = _loc4_.tail = new SlotList(_loc5_.head);
            _loc5_ = _loc5_.tail;
         }
         _loc4_.tail = new SlotList(param1);
         return _loc3_;
      }
      
      public function filterNot(param1:Function) : SlotList
      {
         if(!this.nonEmpty || param1 == null)
         {
            return this;
         }
         if(param1 == this.head.listener)
         {
            return this.tail;
         }
         var _loc2_:SlotList = new SlotList(this.head);
         var _loc3_:SlotList = _loc2_;
         var _loc4_:SlotList = this.tail;
         while(_loc4_.nonEmpty)
         {
            if(_loc4_.head.listener == param1)
            {
               _loc3_.tail = _loc4_.tail;
               return _loc2_;
            }
            _loc3_ = _loc3_.tail = new SlotList(_loc4_.head);
            _loc4_ = _loc4_.tail;
         }
         return this;
      }
      
      public function contains(param1:Function) : Boolean
      {
         if(!this.nonEmpty)
         {
            return false;
         }
         var _loc2_:SlotList = this;
         while(_loc2_.nonEmpty)
         {
            if(_loc2_.head.listener == param1)
            {
               return true;
            }
            _loc2_ = _loc2_.tail;
         }
         return false;
      }
      
      public function find(param1:Function) : ISlot
      {
         if(!this.nonEmpty)
         {
            return null;
         }
         var _loc2_:SlotList = this;
         while(_loc2_.nonEmpty)
         {
            if(_loc2_.head.listener == param1)
            {
               return _loc2_.head;
            }
            _loc2_ = _loc2_.tail;
         }
         return null;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         var _loc2_:SlotList = this;
         while(_loc2_.nonEmpty)
         {
            _loc1_ += _loc2_.head + " -> ";
            _loc2_ = _loc2_.tail;
         }
         _loc1_ += "NIL";
         return "[List " + _loc1_ + "]";
      }
   }
}

