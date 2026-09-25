package kabam.rotmg.servers.control
{
   import com.company.assembleegameclient.parameters.Parameters;
   import kabam.rotmg.servers.api.Server;
   import kabam.rotmg.servers.api.ServerModel;
   
   public class ParseServerDataCommand
   {
      
      [Inject]
      public var servers:ServerModel;
      
      [Inject]
      public var data:XML;
      
      public function ParseServerDataCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.servers.setServers(this.makeListOfServers());
      }
      
      private function makeListOfServers() : Vector.<Server>
      {
         var _loc3_:XML = null;
         var _loc1_:XMLList = this.data.child("Servers").child("Server");
         var _loc2_:Vector.<Server> = new Vector.<Server>(0);
         for each(_loc3_ in _loc1_)
         {
            _loc2_.push(this.makeServer(_loc3_));
         }
         return _loc2_;
      }
      
      private function makeServer(param1:XML) : Server
      {
         return new Server().setName(param1.Name).setAddress(param1.DNS).setPort(Parameters.PORT).setLatLong(Number(param1.Lat),Number(param1.Long)).setUsage(param1.Usage).setIsAdminOnly(param1.hasOwnProperty("AdminOnly"));
      }
   }
}

