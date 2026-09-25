package kabam.rotmg.chat.model
{
   public class TellModel
   {
      
      private var pastRecipients:Vector.<String> = new Vector.<String>();
      
      private var index:int = 0;
      
      public function TellModel()
      {
         super();
      }
      
      public function push(param1:String) : void
      {
         var _loc2_:int = this.pastRecipients.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.pastRecipients.splice(_loc2_,1);
         }
         this.pastRecipients.unshift(param1);
      }
      
      public function getNext() : String
      {
         if(this.pastRecipients.length > 0)
         {
            this.index = (this.index + 1) % this.pastRecipients.length;
            return this.pastRecipients[this.index];
         }
         return "";
      }
      
      public function resetRecipients() : void
      {
         this.index = -1;
      }
      
      public function clearRecipients() : void
      {
         this.pastRecipients = new Vector.<String>();
         this.index = 0;
      }
   }
}

