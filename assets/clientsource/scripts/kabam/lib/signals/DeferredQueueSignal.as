package kabam.lib.signals
{
   import org.osflash.signals.ISlot;
   import org.osflash.signals.Signal;
   
   public class DeferredQueueSignal extends Signal
   {
      
      private var data:Array = [];
      
      private var log:Boolean = true;
      
      public function DeferredQueueSignal(... rest)
      {
         super(rest);
      }
      
      override public function dispatch(... rest) : void
      {
         if(this.log)
         {
            this.data.push(rest);
         }
         super.dispatch.apply(this,rest);
      }
      
      override public function add(param1:Function) : ISlot
      {
         var _loc2_:ISlot = super.add(param1);
         while(this.data.length > 0)
         {
            param1.apply(this,this.data.shift());
         }
         this.log = false;
         return _loc2_;
      }
      
      override public function addOnce(param1:Function) : ISlot
      {
         var _loc2_:ISlot = null;
         if(this.data.length > 0)
         {
            param1.apply(this,this.data.shift());
         }
         else
         {
            _loc2_ = super.addOnce(param1);
            this.log = false;
         }
         while(this.data.length > 0)
         {
            this.data.shift();
         }
         return _loc2_;
      }
      
      public function getNumData() : int
      {
         return this.data.length;
      }
   }
}

