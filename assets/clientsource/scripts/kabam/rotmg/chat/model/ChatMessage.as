package kabam.rotmg.chat.model
{
   public class ChatMessage
   {
      
      public var name:String;
      
      public var text:String;
      
      public var objectId:int = -1;
      
      public var numStars:int = -1;
      
      public var recipient:String = "";
      
      public var isToMe:Boolean;
      
      public var isWhisper:Boolean;
      
      public var tokens:Object;
      
      public function ChatMessage()
      {
         super();
      }
      
      public static function make(param1:String, param2:String, param3:int = -1, param4:int = -1, param5:String = "", param6:Boolean = false, param7:Object = null, param8:Boolean = false) : ChatMessage
      {
         var _loc9_:ChatMessage = new ChatMessage();
         _loc9_.name = param1;
         _loc9_.text = param2;
         _loc9_.objectId = param3;
         _loc9_.numStars = param4;
         _loc9_.recipient = param5;
         _loc9_.isToMe = param6;
         _loc9_.isWhisper = param8;
         _loc9_.tokens = param7 == null ? {} : param7;
         return _loc9_;
      }
   }
}

