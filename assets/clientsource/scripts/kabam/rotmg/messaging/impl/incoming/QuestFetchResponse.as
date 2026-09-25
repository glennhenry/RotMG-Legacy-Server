package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class QuestFetchResponse extends IncomingMessage
   {
      
      public var tier:int;
      
      public var goal:String;
      
      public var description:String;
      
      public var image:String;
      
      public function QuestFetchResponse(param1:uint, param2:Function)
      {
         super(param1,param2);
      }
      
      override public function parseFromInput(param1:IDataInput) : void
      {
         this.tier = param1.readInt();
         this.goal = param1.readUTF();
         this.description = param1.readUTF();
         this.image = param1.readUTF();
         param1 = param1;
      }
      
      override public function toString() : String
      {
         return formatToString("QUESTFETCHRESPONSE","tier","goal","description","image");
      }
   }
}

