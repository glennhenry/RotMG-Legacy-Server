package kabam.rotmg.messaging.impl
{
   import flash.utils.IDataOutput;
   import kabam.rotmg.messaging.impl.data.SlotObjectData;
   import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;
   
   public class PetUpgradeRequest extends OutgoingMessage
   {
      
      public static const GOLD_PAYMENT_TYPE:int = 0;
      
      public static const FAME_PAYMENT_TYPE:int = 1;
      
      public var petTransType:int;
      
      public var PIDOne:int;
      
      public var PIDTwo:int;
      
      public var objectId:int;
      
      public var slotObject:SlotObjectData = new SlotObjectData();
      
      public var paymentTransType:int;
      
      public function PetUpgradeRequest(param1:uint, param2:Function)
      {
         super(param1,param2);
      }
      
      override public function writeToOutput(param1:IDataOutput) : void
      {
         param1.writeByte(this.petTransType);
         param1.writeInt(this.PIDOne);
         param1.writeInt(this.PIDTwo);
         param1.writeInt(this.objectId);
         this.slotObject.writeToOutput(param1);
         param1.writeByte(this.paymentTransType);
      }
   }
}

