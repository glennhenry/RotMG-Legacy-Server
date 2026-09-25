package kabam.rotmg.messaging.impl.outgoing.arena
{
   import flash.utils.IDataOutput;
   import kabam.rotmg.messaging.impl.data.SlotObjectData;
   import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;
   
   public class QuestRedeem extends OutgoingMessage
   {
      
      public var slotObject:SlotObjectData = new SlotObjectData();
      
      public function QuestRedeem(param1:uint, param2:Function)
      {
         super(param1,param2);
      }
      
      override public function writeToOutput(param1:IDataOutput) : void
      {
         this.slotObject.writeToOutput(param1);
      }
   }
}

