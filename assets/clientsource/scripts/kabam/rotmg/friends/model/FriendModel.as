package kabam.rotmg.friends.model
{
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.util.FameUtil;
   import flash.utils.Dictionary;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.friends.service.FriendDataRequestTask;
   import kabam.rotmg.servers.api.Server;
   import kabam.rotmg.servers.api.ServerModel;
   import org.osflash.signals.Signal;
   import org.swiftsuspenders.Injector;
   
   public class FriendModel
   {
      
      [Inject]
      public var serverModel:ServerModel;
      
      public var task:FriendDataRequestTask;
      
      private var _onlineFriends:Vector.<FriendVO>;
      
      private var _offlineFriends:Vector.<FriendVO>;
      
      private var _friends:Dictionary;
      
      private var _invitations:Dictionary;
      
      private var _inProcessFlag:Boolean;
      
      private var _friendTotal:int;
      
      private var _invitationTotal:int;
      
      private var _isFriDataOK:Boolean;
      
      private var _isInvDataOK:Boolean;
      
      private var _serverDict:Dictionary;
      
      private var _currentServer:Server;
      
      public var errorStr:String;
      
      public var dataSignal:Signal = new Signal(Boolean);
      
      public function FriendModel()
      {
         super();
         this._friendTotal = 0;
         this._invitationTotal = 0;
         this._invitationTotal = 0;
         this._friends = new Dictionary(true);
         this._onlineFriends = new Vector.<FriendVO>();
         this._offlineFriends = new Vector.<FriendVO>();
         this._inProcessFlag = false;
         this.loadFriendListData();
      }
      
      public function setCurrentServer(param1:Server) : void
      {
         this._currentServer = param1;
      }
      
      public function getCurrentServerName() : String
      {
         return this._currentServer ? this._currentServer.name : "";
      }
      
      public function loadFriendListData() : void
      {
         if(this._inProcessFlag)
         {
            return;
         }
         this._inProcessFlag = true;
         var _loc1_:Injector = StaticInjectorContext.getInjector();
         this.task = _loc1_.getInstance(FriendDataRequestTask);
         this.loadList(FriendConstant.getURL(FriendConstant.FRIEND_LIST),this.onFriendListResponse);
      }
      
      private function loadList(param1:String, param2:Function) : void
      {
         this.task.requestURL = param1;
         this.task.finished.addOnce(param2);
         this.task.start();
      }
      
      private function onFriendListResponse(param1:FriendDataRequestTask, param2:Boolean, param3:String = "") : void
      {
         if(param2)
         {
            this.seedFriends(param1.xml);
         }
         this._isFriDataOK = param2;
         this.errorStr = param3;
         param1.reset();
         this.loadList(FriendConstant.getURL(FriendConstant.INVITE_LIST),this.onInvitationListResponse);
      }
      
      private function onInvitationListResponse(param1:FriendDataRequestTask, param2:Boolean, param3:String = "") : void
      {
         if(param2)
         {
            this.seedInvitations(param1.xml);
         }
         this._isInvDataOK = param2;
         this.errorStr = param3;
         param1.reset();
         this._inProcessFlag = false;
         this.dataSignal.dispatch(this._isFriDataOK && this._isInvDataOK);
      }
      
      public function seedFriends(param1:XML) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:FriendVO = null;
         var _loc6_:XML = null;
         this._onlineFriends.length = 0;
         this._offlineFriends.length = 0;
         for each(_loc6_ in param1.Account)
         {
            _loc2_ = _loc6_.Name;
            _loc5_ = this._friends[_loc2_] != null ? this._friends[_loc2_].vo as FriendVO : new FriendVO(Player.fromPlayerXML(_loc2_,_loc6_.Character[0]));
            if(_loc6_.hasOwnProperty("Online"))
            {
               _loc4_ = String(_loc6_.Online);
               _loc3_ = this.serverNameDictionary()[_loc4_];
               _loc5_.online(_loc3_,_loc4_);
               this._onlineFriends.push(_loc5_);
               this._friends[_loc5_.getName()] = {
                  "vo":_loc5_,
                  "list":this._onlineFriends
               };
            }
            else
            {
               _loc5_.offline();
               this._offlineFriends.push(_loc5_);
               this._friends[_loc5_.getName()] = {
                  "vo":_loc5_,
                  "list":this._offlineFriends
               };
            }
         }
         this._onlineFriends.sort(this.sortFriend);
         this._offlineFriends.sort(this.sortFriend);
         this._friendTotal = this._onlineFriends.length + this._offlineFriends.length;
      }
      
      public function seedInvitations(param1:XML) : void
      {
         var _loc2_:String = null;
         var _loc3_:XML = null;
         var _loc4_:Player = null;
         this._invitations = new Dictionary(true);
         this._invitationTotal = 0;
         for each(_loc3_ in param1.Account)
         {
            if(this.starFilter(int(_loc3_.Character[0].ObjectType),int(_loc3_.Character[0].CurrentFame),_loc3_.Stats[0]))
            {
               _loc2_ = _loc3_.Name;
               _loc4_ = Player.fromPlayerXML(_loc2_,_loc3_.Character[0]);
               this._invitations[_loc2_] = new FriendVO(_loc4_);
               ++this._invitationTotal;
            }
         }
      }
      
      public function isMyFriend(param1:String) : Boolean
      {
         return this._friends[param1] != null;
      }
      
      public function updateFriendVO(param1:String, param2:Player) : void
      {
         var _loc3_:Object = null;
         var _loc4_:FriendVO = null;
         if(this.isMyFriend(param1))
         {
            _loc3_ = this._friends[param1];
            _loc4_ = _loc3_.vo as FriendVO;
            _loc4_.updatePlayer(param2);
         }
      }
      
      public function getFilterFriends(param1:String) : Vector.<FriendVO>
      {
         var _loc3_:FriendVO = null;
         var _loc2_:RegExp = new RegExp(param1,"gix");
         var _loc4_:Vector.<FriendVO> = new Vector.<FriendVO>();
         var _loc5_:int = 0;
         while(_loc5_ < this._onlineFriends.length)
         {
            _loc3_ = this._onlineFriends[_loc5_];
            if(_loc3_.getName().search(_loc2_) >= 0)
            {
               _loc4_.push(_loc3_);
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this._offlineFriends.length)
         {
            _loc3_ = this._offlineFriends[_loc5_];
            if(_loc3_.getName().search(_loc2_) >= 0)
            {
               _loc4_.push(_loc3_);
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function ifReachMax() : Boolean
      {
         return this._friendTotal >= FriendConstant.FRIEMD_MAX_CAP;
      }
      
      public function getAllFriends() : Vector.<FriendVO>
      {
         return this._onlineFriends.concat(this._offlineFriends);
      }
      
      public function getAllInvitations() : Vector.<FriendVO>
      {
         var _loc2_:FriendVO = null;
         var _loc1_:* = new Vector.<FriendVO>();
         for each(_loc2_ in this._invitations)
         {
            _loc1_.push(_loc2_);
         }
         _loc1_.sort(this.sortFriend);
         return _loc1_;
      }
      
      public function removeFriend(param1:String) : Boolean
      {
         var _loc2_:Object = this._friends[param1];
         if(_loc2_)
         {
            this.removeFromList(_loc2_.list,param1);
            this._friends[param1] = null;
            delete this._friends[param1];
            return true;
         }
         return false;
      }
      
      public function removeInvitation(param1:String) : Boolean
      {
         if(this._invitations[param1] != null)
         {
            this._invitations[param1] = null;
            delete this._invitations[param1];
            return true;
         }
         return false;
      }
      
      private function removeFromList(param1:Vector.<FriendVO>, param2:String) : *
      {
         var _loc3_:FriendVO = null;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_ = param1[_loc4_];
            if(_loc3_.getName() == param2)
            {
               param1.slice(_loc4_,1);
               return;
            }
            _loc4_++;
         }
      }
      
      private function sortFriend(param1:FriendVO, param2:FriendVO) : Number
      {
         if(param1.getName() < param2.getName())
         {
            return -1;
         }
         if(param1.getName() > param2.getName())
         {
            return 1;
         }
         return 0;
      }
      
      private function serverNameDictionary() : Dictionary
      {
         var _loc2_:Server = null;
         if(this._serverDict)
         {
            return this._serverDict;
         }
         var _loc1_:Vector.<Server> = this.serverModel.getServers();
         this._serverDict = new Dictionary(true);
         for each(_loc2_ in _loc1_)
         {
            this._serverDict[_loc2_.address] = _loc2_.name;
         }
         return this._serverDict;
      }
      
      private function starFilter(param1:int, param2:int, param3:XML) : Boolean
      {
         return FameUtil.numAllTimeStars(param1,param2,param3) >= Parameters.data_.friendStarRequirement;
      }
   }
}

