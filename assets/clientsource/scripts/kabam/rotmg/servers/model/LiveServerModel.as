package kabam.rotmg.servers.model
{
   import com.company.assembleegameclient.parameters.Parameters;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.servers.api.LatLong;
   import kabam.rotmg.servers.api.Server;
   import kabam.rotmg.servers.api.ServerModel;
   
   public class LiveServerModel implements ServerModel
   {
      
      [Inject]
      public var model:PlayerModel;
      
      private var _descendingFlag:Boolean;
      
      private const servers:Vector.<Server> = new Vector.<Server>(0);
      
      public function LiveServerModel()
      {
         super();
      }
      
      public function setServers(param1:Vector.<Server>) : void
      {
         var _loc2_:Server = null;
         this.servers.length = 0;
         for each(_loc2_ in param1)
         {
            this.servers.push(_loc2_);
         }
         this._descendingFlag = false;
         this.servers.sort(this.compareServerName);
      }
      
      public function getServers() : Vector.<Server>
      {
         return this.servers;
      }
      
      public function getServer() : Server
      {
         var _loc6_:Server = null;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc1_:Boolean = this.model.isAdmin();
         var _loc2_:LatLong = this.model.getMyPos();
         var _loc3_:Server = null;
         var _loc4_:Number = Number.MAX_VALUE;
         var _loc5_:int = int.MAX_VALUE;
         for each(_loc6_ in this.servers)
         {
            if(!(_loc6_.isFull() && !_loc1_))
            {
               if(_loc6_.name == Parameters.data_.preferredServer)
               {
                  return _loc6_;
               }
               _loc7_ = _loc6_.priority();
               _loc8_ = LatLong.distance(_loc2_,_loc6_.latLong);
               if(_loc7_ < _loc5_ || _loc7_ == _loc5_ && _loc8_ < _loc4_)
               {
                  _loc3_ = _loc6_;
                  _loc4_ = _loc8_;
                  _loc5_ = _loc7_;
               }
            }
         }
         return _loc3_;
      }
      
      public function getServerNameByAddress(param1:String) : String
      {
         var _loc2_:Server = null;
         for each(_loc2_ in this.servers)
         {
            if(_loc2_.address == param1)
            {
               return _loc2_.name;
            }
         }
         return "";
      }
      
      public function isServerAvailable() : Boolean
      {
         return this.servers.length > 0;
      }
      
      private function compareServerName(param1:Server, param2:Server) : int
      {
         if(param1.name < param2.name)
         {
            return this._descendingFlag ? -1 : 1;
         }
         if(param1.name > param2.name)
         {
            return this._descendingFlag ? 1 : -1;
         }
         return 0;
      }
   }
}

