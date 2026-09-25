package kabam.rotmg.friends.model
{
   public class FriendRequestVO
   {
      
      public var request:String;
      
      public var target:String;
      
      public var callback:Function;
      
      public function FriendRequestVO(param1:String, param2:String, param3:Function = null)
      {
         super();
         this.request = param1;
         this.target = param2;
         this.callback = param3;
      }
   }
}

