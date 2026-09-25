package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class Failure extends IncomingMessage
   {
      
      public static const INCORRECT_VERSION:int = 4;
      
      public static const BAD_KEY:int = 5;
      
      public static const INVALID_TELEPORT_TARGET:int = 6;
      
      public static const EMAIL_VERIFICATION_NEEDED:int = 7;
      
      public var errorId_:int;
      
      public var errorDescription_:String;
      
      public function Failure(param1:uint, param2:Function)
      {
         super(param1,param2);
      }
      
      override public function parseFromInput(param1:IDataInput) : void
      {
         this.errorId_ = param1.readInt();
         this.errorDescription_ = param1.readUTF();
      }
      
      override public function toString() : String
      {
         return formatToString("FAILURE","errorId_","errorDescription_");
      }
   }
}

