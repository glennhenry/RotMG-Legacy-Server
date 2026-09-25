package kabam.rotmg.servers.api
{
   public class Server
   {
      
      public var name:String;
      
      public var address:String;
      
      public var port:int;
      
      public var latLong:LatLong;
      
      public var usage:Number;
      
      public var isAdminOnly:Boolean;
      
      public function Server()
      {
         super();
      }
      
      public function setName(param1:String) : Server
      {
         this.name = param1;
         return this;
      }
      
      public function setAddress(param1:String) : Server
      {
         this.address = param1;
         return this;
      }
      
      public function setPort(param1:int) : Server
      {
         this.port = param1;
         return this;
      }
      
      public function setLatLong(param1:Number, param2:Number) : Server
      {
         this.latLong = new LatLong(param1,param2);
         return this;
      }
      
      public function setUsage(param1:Number) : Server
      {
         this.usage = param1;
         return this;
      }
      
      public function setIsAdminOnly(param1:Boolean) : Server
      {
         this.isAdminOnly = param1;
         return this;
      }
      
      public function priority() : int
      {
         if(this.isAdminOnly)
         {
            return 2;
         }
         if(this.isCrowded())
         {
            return 1;
         }
         return 0;
      }
      
      public function isCrowded() : Boolean
      {
         return this.usage >= 0.66;
      }
      
      public function isFull() : Boolean
      {
         return this.usage >= 1;
      }
      
      public function toString() : String
      {
         return "[" + this.name + ": " + this.address + ":" + this.port + ":" + this.latLong + ":" + this.usage + ":" + this.isAdminOnly + "]";
      }
   }
}

