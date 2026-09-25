package kabam.rotmg.pets.data
{
   import kabam.rotmg.messaging.impl.data.SlotObjectData;
   
   public class FeedPetRequestVO implements IUpgradePetRequestVO
   {
      
      public var petInstanceId:int;
      
      public var slotObject:SlotObjectData;
      
      public var paymentTransType:int;
      
      public function FeedPetRequestVO(param1:int, param2:SlotObjectData, param3:int)
      {
         super();
         this.petInstanceId = param1;
         this.slotObject = param2;
         this.paymentTransType = param3;
      }
   }
}

