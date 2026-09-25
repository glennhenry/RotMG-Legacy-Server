package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class Aoe extends IncomingMessage
   {
      
      public var pos_:WorldPosData = new WorldPosData();
      
      public var radius_:Number;
      
      public var damage_:int;
      
      public var effect_:int;
      
      public var duration_:Number;
      
      public var origType_:int;
      
      public function Aoe(param1:uint, param2:Function)
      {
         super(param1,param2);
      }
      
      override public function parseFromInput(param1:IDataInput) : void
      {
         this.pos_.parseFromInput(param1);
         this.radius_ = param1.readFloat();
         this.damage_ = param1.readUnsignedShort();
         this.effect_ = param1.readUnsignedByte();
         this.duration_ = param1.readFloat();
         this.origType_ = param1.readUnsignedShort();
      }
      
      override public function toString() : String
      {
         return formatToString("AOE","pos_","radius_","damage_","effect_","duration_","origType_");
      }
   }
}

