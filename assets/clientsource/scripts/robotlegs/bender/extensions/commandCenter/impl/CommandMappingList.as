package robotlegs.bender.extensions.commandCenter.impl
{
   import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
   
   public class CommandMappingList
   {
      
      protected var _head:ICommandMapping;
      
      public function CommandMappingList()
      {
         super();
      }
      
      public function get head() : ICommandMapping
      {
         return this._head;
      }
      
      public function set head(param1:ICommandMapping) : void
      {
         if(param1 !== this._head)
         {
            this._head = param1;
         }
      }
      
      public function get tail() : ICommandMapping
      {
         if(!this._head)
         {
            return null;
         }
         var _loc1_:ICommandMapping = this._head;
         while(_loc1_.next)
         {
            _loc1_ = _loc1_.next;
         }
         return _loc1_;
      }
      
      public function remove(param1:ICommandMapping) : void
      {
         var _loc2_:ICommandMapping = this._head;
         if(_loc2_ == param1)
         {
            this._head = param1.next;
         }
         while(_loc2_)
         {
            if(_loc2_.next == param1)
            {
               _loc2_.next = param1.next;
            }
            _loc2_ = _loc2_.next;
         }
      }
   }
}

