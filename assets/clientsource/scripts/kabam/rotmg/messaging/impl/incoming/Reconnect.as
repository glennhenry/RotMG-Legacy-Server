package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class Reconnect extends IncomingMessage
   {
      
      public var name_:String;
      
      public var host_:String;
      
      public var port_:int;
      
      public var gameId_:int;
      
      public var keyTime_:int;
      
      public var key_:ByteArray = new ByteArray();
      
      public var isFromArena_:Boolean;
      
      public function Reconnect(param1:uint, param2:Function)
      {
         super(param1,param2);
      }
      
      override public function parseFromInput(param1:IDataInput) : void
      {
         this.name_ = param1.readUTF();
         this.host_ = param1.readUTF();
         this.port_ = param1.readInt();
         this.gameId_ = param1.readInt();
         this.keyTime_ = param1.readInt();
         this.isFromArena_ = param1.readBoolean();
         var _loc2_:int = param1.readShort();
         this.key_.length = 0;
         param1.readBytes(this.key_,0,_loc2_);
      }
      
      override public function toString() : String
      {
         return formatToString("RECONNECT","name_","host_","port_","gameId_","keyTime_","key_","isFromArena_");
      }
   }
}

