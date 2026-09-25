package kabam.rotmg.account.kongregate.services
{
   import com.company.assembleegameclient.util.GUID;
   import flash.net.SharedObject;
   
   public class KongregateSharedObject
   {
      
      private var guid:String;
      
      public function KongregateSharedObject()
      {
         super();
      }
      
      public function getGuestGUID() : String
      {
         return this.guid = this.guid || this.makeGuestGUID();
      }
      
      private function makeGuestGUID() : String
      {
         var _loc1_:String = null;
         var _loc2_:SharedObject = null;
         try
         {
            _loc2_ = SharedObject.getLocal("KongregateRotMG","/");
            if(_loc2_.data.hasOwnProperty("GuestGUID"))
            {
               _loc1_ = _loc2_.data["GuestGUID"];
            }
         }
         catch(error:Error)
         {
         }
         if(_loc1_ == null)
         {
            _loc1_ = GUID.create();
            try
            {
               _loc2_ = SharedObject.getLocal("KongregateRotMG","/");
               _loc2_.data["GuestGUID"] = _loc1_;
               _loc2_.flush();
            }
            catch(error:Error)
            {
            }
         }
         return _loc1_;
      }
   }
}

