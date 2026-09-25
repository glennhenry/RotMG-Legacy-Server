package kabam.rotmg.game.view.components
{
   import flash.display.DisplayObjectContainer;
   
   public class QueuedStatusTextList
   {
      
      public var target:DisplayObjectContainer;
      
      private var head:QueuedStatusText;
      
      private var tail:QueuedStatusText;
      
      public function QueuedStatusTextList()
      {
         super();
      }
      
      public function shift() : void
      {
         this.target.removeChild(this.head);
         this.head = this.head.next;
         if(this.head)
         {
            this.target.addChild(this.head);
         }
         else
         {
            this.tail = null;
         }
      }
      
      public function append(param1:QueuedStatusText) : void
      {
         param1.list = this;
         if(this.tail)
         {
            this.tail.next = param1;
            this.tail = param1;
         }
         else
         {
            this.head = this.tail = param1;
            this.target.addChild(param1);
         }
      }
   }
}

