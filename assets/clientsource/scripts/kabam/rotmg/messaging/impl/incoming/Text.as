package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class Text extends IncomingMessage
   {
      
      public var name_:String = new String();
      
      public var objectId_:int;
      
      public var numStars_:int;
      
      public var bubbleTime_:uint;
      
      public var recipient_:String;
      
      public var text_:String = new String();
      
      public var cleanText_:String = new String();
      
      public function Text(param1:uint, param2:Function)
      {
         super(param1,param2);
      }
      
      override public function parseFromInput(param1:IDataInput) : void
      {
         this.name_ = param1.readUTF();
         this.objectId_ = param1.readInt();
         this.numStars_ = param1.readInt();
         this.bubbleTime_ = param1.readUnsignedByte();
         this.recipient_ = param1.readUTF();
         this.text_ = param1.readUTF();
         this.cleanText_ = param1.readUTF();
      }
      
      override public function toString() : String
      {
         return formatToString("TEXT","name_","objectId_","numStars_","bubbleTime_","recipient_","text_","cleanText_");
      }
   }
}

