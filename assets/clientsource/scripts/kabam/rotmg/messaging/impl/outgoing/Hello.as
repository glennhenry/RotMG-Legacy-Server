package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.ByteArray;
   import flash.utils.IDataOutput;
   
   public class Hello extends OutgoingMessage
   {
      
      public var buildVersion_:String = new String();
      
      public var gameId_:int = 0;
      
      public var guid_:String = new String();
      
      public var password_:String = new String();
      
      public var secret_:String = new String();
      
      public var keyTime_:int = 0;
      
      public var key_:ByteArray = new ByteArray();
      
      public var mapJSON_:String = new String();
      
      public var entrytag_:String = "";
      
      public var gameNet:String = "";
      
      public var gameNetUserId:String = "";
      
      public var playPlatform:String = "";
      
      public var platformToken:String = "";
      
      public function Hello(param1:uint, param2:Function)
      {
         super(param1,param2);
      }
      
      override public function writeToOutput(param1:IDataOutput) : void
      {
         param1.writeUTF(this.buildVersion_);
         param1.writeInt(this.gameId_);
         param1.writeUTF(this.guid_);
         param1.writeInt(int(Math.floor(Math.random() * 1000000000)));
         param1.writeUTF(this.password_);
         param1.writeInt(int(Math.floor(Math.random() * 1000000000)));
         param1.writeUTF(this.secret_);
         param1.writeInt(this.keyTime_);
         param1.writeShort(this.key_.length);
         param1.writeBytes(this.key_);
         param1.writeInt(this.mapJSON_.length);
         param1.writeUTFBytes(this.mapJSON_);
         param1.writeUTF(this.entrytag_);
         param1.writeUTF(this.gameNet);
         param1.writeUTF(this.gameNetUserId);
         param1.writeUTF(this.playPlatform);
         param1.writeUTF(this.platformToken);
      }
      
      override public function toString() : String
      {
         return formatToString("HELLO","buildVersion_","gameId_","guid_","password_","secret_");
      }
   }
}

