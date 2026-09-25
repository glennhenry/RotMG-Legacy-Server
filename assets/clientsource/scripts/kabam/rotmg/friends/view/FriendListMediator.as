package kabam.rotmg.friends.view
{
   import com.company.assembleegameclient.appengine.SavedCharacter;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.dialogs.ErrorDialog;
   import kabam.rotmg.chat.control.ShowChatInputSignal;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.friends.controller.FriendActionSignal;
   import kabam.rotmg.friends.model.FriendConstant;
   import kabam.rotmg.friends.model.FriendModel;
   import kabam.rotmg.friends.model.FriendRequestVO;
   import kabam.rotmg.game.model.GameInitData;
   import kabam.rotmg.game.signals.PlayGameSignal;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.ui.signals.EnterGameSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class FriendListMediator extends Mediator
   {
      
      [Inject]
      public var view:FriendListView;
      
      [Inject]
      public var model:FriendModel;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var closeDialog:CloseDialogsSignal;
      
      [Inject]
      public var actionSignal:FriendActionSignal;
      
      [Inject]
      public var chatSignal:ShowChatInputSignal;
      
      [Inject]
      public var enterGame:EnterGameSignal;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var playGame:PlayGameSignal;
      
      public function FriendListMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.actionSignal.add(this.onFriendActed);
         this.view.tabSignal.add(this.onTabSwitched);
         this.model.dataSignal.add(this.initView);
         this.model.loadFriendListData();
      }
      
      override public function destroy() : void
      {
         this.view.actionSignal.removeAll();
         this.view.tabSignal.removeAll();
      }
      
      private function initView(param1:Boolean = false) : *
      {
         if(param1)
         {
            this.view.init(this.model.getAllFriends(),this.model.getAllInvitations(),this.model.getCurrentServerName());
         }
         else
         {
            this.reportError(this.model.errorStr);
         }
      }
      
      private function reportError(param1:String) : void
      {
         this.openDialog.dispatch(new ErrorDialog(param1));
      }
      
      private function onTabSwitched(param1:String) : void
      {
         switch(param1)
         {
            case FriendConstant.FRIEND_TAB:
               this.view.updateFriendTab(this.model.getAllFriends(),this.model.getCurrentServerName());
               break;
            case FriendConstant.INVITE_TAB:
               this.view.updateInvitationTab(this.model.getAllInvitations());
         }
      }
      
      private function onFriendActed(param1:String, param2:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc3_:FriendRequestVO = new FriendRequestVO(param1,param2);
         switch(param1)
         {
            case FriendConstant.SEARCH:
               if(param2 != null && param2 != "")
               {
                  this.view.updateFriendTab(this.model.getFilterFriends(param2),this.model.getCurrentServerName());
               }
               else if(param2 == "")
               {
                  this.view.updateFriendTab(this.model.getAllFriends(),this.model.getCurrentServerName());
               }
               return;
            case FriendConstant.INVITE:
               if(this.model.ifReachMax())
               {
                  this.view.updateInput(TextKey.FRIEND_REACH_CAPACITY);
                  return;
               }
               _loc3_.callback = this.inviteFriendCallback;
               break;
            case FriendConstant.ACCEPT:
               _loc3_.callback = this.acceptInvitationCallback;
               break;
            case FriendConstant.REJECT:
               _loc3_.callback = this.rejectInvitationCallback;
               break;
            case FriendConstant.REMOVE:
               _loc3_.callback = this.removeFriendCallback;
               _loc4_ = TextKey.FRIEND_REMOVE_TITLE;
               _loc5_ = TextKey.FRIEND_REMOVE_TEXT;
               this.openDialog.dispatch(new FriendUpdateConfirmDialog(_loc4_,_loc5_,TextKey.FRAME_CANCEL,TextKey.FRIEND_REMOVE_BUTTON,_loc3_,{"name":_loc3_.target}));
               return;
            case FriendConstant.BLOCK:
               _loc3_.callback = this.blockInvitationCallback;
               _loc4_ = TextKey.FRIEND_BLOCK_TITLE;
               _loc5_ = TextKey.FRIEND_BLOCK_TEXT;
               this.openDialog.dispatch(new FriendUpdateConfirmDialog(_loc4_,_loc5_,TextKey.FRAME_CANCEL,TextKey.FRIEND_BLOCK_BUTTON,_loc3_,{"name":_loc3_.target}));
               return;
            case FriendConstant.WHISPER:
               this.whisperCallback(param2);
               return;
            case FriendConstant.JUMP:
               this.jumpCallback(param2);
               return;
         }
         this.actionSignal.dispatch(_loc3_);
      }
      
      private function inviteFriendCallback(param1:Boolean, param2:String, param3:String) : void
      {
         if(param1)
         {
            this.view.updateInput(TextKey.FRIEND_SENT_INVITATION_TEXT,{"name":param3});
         }
         else if(param2 == "Blocked")
         {
            this.view.updateInput(TextKey.FRIEND_SENT_INVITATION_TEXT,{"name":param3});
         }
         else
         {
            this.view.updateInput(param2);
         }
      }
      
      private function removeFriendCallback(param1:Boolean, param2:String, param3:String) : void
      {
         if(param1)
         {
            this.model.removeFriend(param3);
         }
         else
         {
            this.reportError(param2);
         }
      }
      
      private function acceptInvitationCallback(param1:Boolean, param2:String, param3:String) : void
      {
         if(param1)
         {
            this.model.seedFriends(XML(param2));
            if(this.model.removeInvitation(param3))
            {
               this.view.updateInvitationTab(this.model.getAllInvitations());
            }
         }
         else
         {
            this.reportError(param2);
         }
      }
      
      private function rejectInvitationCallback(param1:Boolean, param2:String, param3:String) : void
      {
         if(param1)
         {
            if(this.model.removeInvitation(param3))
            {
               this.view.updateInvitationTab(this.model.getAllInvitations());
            }
         }
         else
         {
            this.reportError(param2);
         }
      }
      
      private function blockInvitationCallback(param1:String) : void
      {
         this.model.removeInvitation(param1);
      }
      
      private function whisperCallback(param1:String) : void
      {
         this.chatSignal.dispatch(true,"/tell " + param1 + " ");
         this.view.getCloseSignal().dispatch();
      }
      
      private function jumpCallback(param1:String) : void
      {
         Parameters.data_.preferredServer = param1;
         Parameters.save();
         this.enterGame.dispatch();
         var _loc2_:SavedCharacter = this.playerModel.getCharacterById(this.playerModel.currentCharId);
         var _loc3_:GameInitData = new GameInitData();
         _loc3_.createCharacter = false;
         _loc3_.charId = _loc2_.charId();
         _loc3_.isNewGame = true;
         this.playGame.dispatch(_loc3_);
         this.closeDialog.dispatch();
      }
   }
}

