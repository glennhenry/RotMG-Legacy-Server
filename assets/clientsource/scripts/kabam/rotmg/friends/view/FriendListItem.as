package kabam.rotmg.friends.view
{
   import com.company.assembleegameclient.ui.icons.IconButton;
   import com.company.assembleegameclient.ui.icons.IconButtonFactory;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.friends.model.FriendConstant;
   import kabam.rotmg.friends.model.FriendVO;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   
   public class FriendListItem extends FListItem
   {
      
      private const ONLINE_COLOR:uint = 3407650;
      
      private const NORMAL_COLOR:uint = 11776947;
      
      private var _senderName:String;
      
      private var _serverName:String;
      
      private var _isOnline:Boolean;
      
      private var _portrait:Bitmap;
      
      private var _nameText:TextFieldDisplayConcrete;
      
      private var _serverText:TextFieldDisplayConcrete;
      
      private var _whisperButton:IconButton;
      
      private var _jumpButton:IconButton;
      
      private var _removeButton:FriendRemoveButton;
      
      public function FriendListItem(param1:FriendVO, param2:Number, param3:Number, param4:String)
      {
         super();
         this.init(param2,param3);
         this.update(param1,param4);
      }
      
      override protected function init(param1:Number, param2:Number) : void
      {
         this.graphics.beginFill(6710886);
         this.graphics.drawRoundRect(0,0,param1,param2,10,10);
         this.graphics.endFill();
         this._portrait = new Bitmap();
         this._portrait.x = 2;
         this._portrait.y = -8;
         var _temp_1:* = this._portrait;
         this._portrait.scaleY = 1.2;
         _temp_1.scaleX = 1.2;
         addChild(this._portrait);
         this._nameText = new TextFieldDisplayConcrete().setSize(18).setColor(this._isOnline ? this.ONLINE_COLOR : this.NORMAL_COLOR);
         this._nameText.setStringBuilder(new StaticStringBuilder(this._senderName));
         this._nameText.y = 4;
         addChild(this._nameText);
         this._serverText = new TextFieldDisplayConcrete().setSize(16).setColor(this.NORMAL_COLOR);
         this._serverText.x = this.width - 250;
         this._serverText.setStringBuilder(new StaticStringBuilder(this._serverName));
         addChild(this._serverText);
         var _loc3_:IconButtonFactory = StaticInjectorContext.getInjector().getInstance(IconButtonFactory);
         this._jumpButton = _loc3_.create(AssetLibrary.getImageFromSet("lofiInterface2",3),TextKey.FRIEND_TELEPORT_TITLE,"","");
         this._jumpButton.setToolTipTitle(TextKey.FRIEND_TELEPORT_TITLE);
         this._jumpButton.x = this.width - 270;
         this._jumpButton.y = 4;
         this._jumpButton.addEventListener(MouseEvent.CLICK,this.onJumpClicked);
         addChild(this._jumpButton);
         this._whisperButton = _loc3_.create(AssetLibrary.getImageFromSet("lofiInterfaceBig",21),TextKey.PLAYERMENU_PM,"","");
         this._whisperButton.x = this.width - 130;
         this._whisperButton.y = 4;
         this._whisperButton.addEventListener(MouseEvent.CLICK,this.onWhisperClicked);
         addChild(this._whisperButton);
         this._removeButton = new FriendRemoveButton(TextKey.FRIEND_REMOVE_BUTTON,TextKey.FRIEND_REMOVE_BUTTON_DESC);
         this._removeButton.addEventListener(MouseEvent.CLICK,this.onRemoveClicked);
         this._removeButton.x = this.width - 30;
         this._removeButton.y = 11;
         addChild(this._removeButton);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromState);
      }
      
      override public function update(param1:FriendVO, param2:String) : void
      {
         this._portrait.bitmapData = param1.getPortrait();
         if(param1.getName() != this._senderName)
         {
            this._senderName = param1.getName();
            this._nameText.x = this._portrait.width + 8;
            this._nameText.setStringBuilder(new StaticStringBuilder(this._senderName));
            this._serverText.y = this._nameText.y + 16;
         }
         if(param1.getServerName() != this._serverName)
         {
            this._serverName = param1.getServerName();
            this._serverText.setStringBuilder(new StaticStringBuilder(this._serverName));
         }
         this._isOnline = param1.isOnline;
         this._nameText.setColor(this._isOnline ? this.ONLINE_COLOR : this.NORMAL_COLOR);
         this._whisperButton.visible = this._isOnline;
         this._jumpButton.visible = this._isOnline;
         this._jumpButton.setToolTipText(TextKey.FRIEND_TELEPORT_DESC,{"name":this._serverName});
         this._jumpButton.enabled = this._serverName != param2;
      }
      
      override public function destroy() : void
      {
         while(numChildren > 0)
         {
            this.removeChildAt(numChildren - 1);
         }
         this._portrait = null;
         this._nameText = null;
         this._serverText = null;
         this._whisperButton.removeEventListener(MouseEvent.CLICK,this.onWhisperClicked);
         this._whisperButton = null;
         this._jumpButton.removeEventListener(MouseEvent.CLICK,this.onJumpClicked);
         this._jumpButton = null;
         this._removeButton.removeEventListener(MouseEvent.CLICK,this.onRemoveClicked);
         this._removeButton.destroy();
         this._removeButton = null;
      }
      
      private function onRemovedFromState(param1:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromState);
         this.destroy();
      }
      
      private function onRemoveClicked(param1:MouseEvent) : void
      {
         actionSignal.dispatch(FriendConstant.REMOVE,this._senderName);
      }
      
      private function onWhisperClicked(param1:MouseEvent) : void
      {
         actionSignal.dispatch(FriendConstant.WHISPER,this._senderName);
      }
      
      private function onJumpClicked(param1:MouseEvent) : void
      {
         actionSignal.dispatch(FriendConstant.JUMP,this._serverName);
      }
   }
}

