package kabam.rotmg.friends.model
{
   import com.company.assembleegameclient.objects.Player;
   import flash.display.BitmapData;
   
   public class FriendVO
   {
      
      public var playerName:String;
      
      private var _player:Player;
      
      private var _isOnline:Boolean;
      
      private var _serverName:String;
      
      private var _serverAddr:String;
      
      public function FriendVO(param1:Player, param2:Boolean = false, param3:String = "", param4:String = "")
      {
         super();
         this._player = param1;
         this._isOnline = param2;
         this._serverName = param3;
         this._serverAddr = param4;
         this.playerName = this._player.getName();
      }
      
      public function updatePlayer(param1:Player) : void
      {
         this._player = param1;
         this.playerName = this._player.getName();
      }
      
      public function getServerName() : String
      {
         return this._serverName;
      }
      
      public function getName() : String
      {
         return this._player.getName();
      }
      
      public function getPortrait() : BitmapData
      {
         return this._player.getPortrait();
      }
      
      public function get isOnline() : Boolean
      {
         return this._isOnline;
      }
      
      public function online(param1:String, param2:String) : void
      {
         this._isOnline = true;
         this._serverName = param1;
         this._serverAddr = param2;
      }
      
      public function offline() : void
      {
         this._isOnline = false;
         this._serverName = "";
         this._serverAddr = "";
      }
   }
}

