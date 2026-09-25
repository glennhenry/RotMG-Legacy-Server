package robotlegs.bender.framework.impl
{
   import flash.utils.Dictionary;
   import robotlegs.bender.framework.api.IMessageDispatcher;
   
   public final class MessageDispatcher implements IMessageDispatcher
   {
      
      private const _handlers:Dictionary = new Dictionary();
      
      public function MessageDispatcher()
      {
         super();
      }
      
      public function addMessageHandler(param1:Object, param2:Function) : void
      {
         var _loc3_:Array = this._handlers[param1];
         if(_loc3_)
         {
            if(_loc3_.indexOf(param2) == -1)
            {
               _loc3_.push(param2);
            }
         }
         else
         {
            this._handlers[param1] = [param2];
         }
      }
      
      public function hasMessageHandler(param1:Object) : Boolean
      {
         return this._handlers[param1];
      }
      
      public function removeMessageHandler(param1:Object, param2:Function) : void
      {
         var _loc3_:Array = null;
         _loc3_ = this._handlers[param1];
         if((_loc3_ ? _loc3_.indexOf(param2) : -1) != -1)
         {
            _loc3_.splice(-1,1);
            if(_loc3_.length == 0)
            {
               delete this._handlers[param1];
            }
         }
      }
      
      public function dispatchMessage(param1:Object, param2:Function = null, param3:Boolean = false) : void
      {
         var _loc4_:Array = this._handlers[param1];
         if(_loc4_)
         {
            _loc4_ = _loc4_.concat();
            param3 || _loc4_.reverse();
            new MessageRunner(param1,_loc4_,param2).run();
         }
         else
         {
            param2 && safelyCallBack(param2);
         }
      }
   }
}

class MessageRunner
{
   
   private var _message:Object;
   
   private var _handlers:Array;
   
   private var _callback:Function;
   
   public function MessageRunner(param1:Object, param2:Array, param3:Function)
   {
      super();
      this._message = param1;
      this._handlers = param2;
      this._callback = param3;
   }
   
   public function run() : void
   {
      this.next();
   }
   
   private function next() : void
   {
      var handler:Function = null;
      var handled:Boolean = false;
      while(Boolean(handler = this._handlers.pop()))
      {
         if(handler.length == 0)
         {
            handler();
         }
         else
         {
            if(handler.length != 1)
            {
               if(handler.length == 2)
               {
                  handler(this._message,function(param1:Object = null, param2:Object = null):void
                  {
                     if(handled)
                     {
                        return;
                     }
                     handled = true;
                     if(Boolean(param1) || _handlers.length == 0)
                     {
                        _callback && safelyCallBack(_callback,param1,_message);
                     }
                     else
                     {
                        next();
                     }
                  });
                  return;
               }
               throw new Error("Bad handler signature");
            }
            handler(this._message);
         }
      }
      this._callback && safelyCallBack(this._callback,null,this._message);
   }
}
