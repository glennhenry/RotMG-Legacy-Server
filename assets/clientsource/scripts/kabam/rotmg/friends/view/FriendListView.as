package kabam.rotmg.friends.view
{
   import com.company.assembleegameclient.account.ui.TextInputField;
   import com.company.assembleegameclient.ui.DeprecatedTextButton;
   import com.company.assembleegameclient.ui.dialogs.DialogCloser;
   import com.company.ui.BaseSimpleText;
   import com.company.util.GraphicsUtil;
   import flash.display.CapsStyle;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.display.IGraphicsData;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import kabam.rotmg.friends.model.FriendConstant;
   import kabam.rotmg.friends.model.FriendVO;
   import kabam.rotmg.pets.util.PetsViewAssetFactory;
   import kabam.rotmg.pets.view.components.DialogCloseButton;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import org.osflash.signals.Signal;
   
   public class FriendListView extends Sprite implements DialogCloser
   {
      
      public static const TEXT_WIDTH:int = 500;
      
      public static const TEXT_HEIGHT:int = 500;
      
      public static const LIST_ITEM_WIDTH:int = 490;
      
      public static const LIST_ITEM_HEIGHT:int = 40;
      
      public var closeDialogSignal:Signal = new Signal();
      
      public var actionSignal:* = new Signal(String,String);
      
      public var tabSignal:* = new Signal(String);
      
      public var _tabView:FriendTabView;
      
      public var _w:int;
      
      public var _h:int;
      
      private var _friendTotalText:TextFieldDisplayConcrete;
      
      private var _friendDefaultText:TextFieldDisplayConcrete;
      
      private var _inviteDefaultText:TextFieldDisplayConcrete;
      
      private var _addButton:DeprecatedTextButton;
      
      private var _findButton:DeprecatedTextButton;
      
      private var _nameInput:TextInputField;
      
      private var _friendsContainer:FriendListContainer;
      
      private var _invitationsContainer:FriendListContainer;
      
      private var _currentServerName:String;
      
      private const closeButton:DialogCloseButton = PetsViewAssetFactory.returnCloseButton(TEXT_WIDTH);
      
      private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(3355443,1);
      
      private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private var lineStyle_:GraphicsStroke = new GraphicsStroke(2,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,this.outlineFill_);
      
      private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[this.lineStyle_,this.backgroundFill_,this.path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
      
      public function FriendListView()
      {
         super();
      }
      
      public function init(param1:Vector.<FriendVO>, param2:Vector.<FriendVO>, param3:String) : void
      {
         this._w = TEXT_WIDTH;
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this._tabView = new FriendTabView(TEXT_WIDTH,TEXT_HEIGHT);
         this._tabView.tabSelected.add(this.onTabClicked);
         addChild(this._tabView);
         this.createFriendTab();
         this.createInvitationsTab();
         addChild(this.closeButton);
         this.drawBackground();
         this._currentServerName = param3;
         this.seedData(param1,param2);
         this._tabView.setSelectedTab(0);
      }
      
      public function destroy() : void
      {
         while(numChildren > 0)
         {
            this.removeChildAt(numChildren - 1);
         }
         this._addButton.removeEventListener(MouseEvent.CLICK,this.onAddFriendClicked);
         this._addButton = null;
         this._tabView.destroy();
         this._tabView = null;
         this._nameInput.removeEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
         this._nameInput = null;
         this._friendsContainer = null;
         this._invitationsContainer = null;
      }
      
      public function updateFriendTab(param1:Vector.<FriendVO>, param2:String) : void
      {
         var _loc3_:FriendVO = null;
         var _loc4_:FListItem = null;
         var _loc5_:* = 0;
         this._friendDefaultText.visible = param1.length <= 0;
         _loc5_ = int(this._friendsContainer.getTotal() - param1.length);
         while(_loc5_ > 0)
         {
            this._friendsContainer.removeChildAt(this._friendsContainer.getTotal() - 1);
            _loc5_--;
         }
         _loc5_ = 0;
         while(_loc5_ < this._friendsContainer.getTotal())
         {
            _loc3_ = param1.pop();
            if(_loc3_ != null)
            {
               _loc4_ = this._friendsContainer.getChildAt(_loc5_) as FListItem;
               _loc4_.update(_loc3_,param2);
            }
            _loc5_++;
         }
         for each(_loc3_ in param1)
         {
            _loc4_ = new FriendListItem(_loc3_,LIST_ITEM_WIDTH,LIST_ITEM_HEIGHT,param2);
            _loc4_.actionSignal.add(this.onListItemAction);
            _loc4_.x = 2;
            this._friendsContainer.addListItem(_loc4_);
         }
         param1.length = 0;
         param1 = null;
      }
      
      public function updateInvitationTab(param1:Vector.<FriendVO>) : void
      {
         var _loc2_:FriendVO = null;
         var _loc3_:FListItem = null;
         var _loc4_:* = 0;
         this._tabView.showTabBadget(1,param1.length);
         this._inviteDefaultText.visible = param1.length == 0;
         _loc4_ = int(this._invitationsContainer.getTotal() - param1.length);
         while(_loc4_ > 0)
         {
            this._invitationsContainer.removeChildAt(this._invitationsContainer.getTotal() - 1);
            _loc4_--;
         }
         _loc4_ = 0;
         while(_loc4_ < this._invitationsContainer.getTotal())
         {
            _loc2_ = param1.pop();
            if(_loc2_ != null)
            {
               _loc3_ = this._invitationsContainer.getChildAt(_loc4_) as FListItem;
               _loc3_.update(_loc2_,"");
            }
            _loc4_++;
         }
         for each(_loc2_ in param1)
         {
            _loc3_ = new InvitationListItem(_loc2_,LIST_ITEM_WIDTH,LIST_ITEM_HEIGHT);
            _loc3_.actionSignal.add(this.onListItemAction);
            this._invitationsContainer.addListItem(_loc3_);
         }
         param1.length = 0;
         param1 = null;
      }
      
      private function createFriendTab() : void
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.name = FriendConstant.FRIEND_TAB;
         this._nameInput = new TextInputField(TextKey.FRIEND_ADD_TITLE,false);
         this._nameInput.x = 3;
         this._nameInput.y = 0;
         this._nameInput.addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
         _loc1_.addChild(this._nameInput);
         this._addButton = new DeprecatedTextButton(14,TextKey.FRIEND_ADD_BUTTON,110);
         this._addButton.y = 30;
         this._addButton.x = 253;
         this._addButton.addEventListener(MouseEvent.CLICK,this.onAddFriendClicked);
         _loc1_.addChild(this._addButton);
         this._findButton = new DeprecatedTextButton(14,TextKey.EDITOR_SEARCH,110);
         this._findButton.y = 30;
         this._findButton.x = 380;
         this._findButton.addEventListener(MouseEvent.CLICK,this.onSearchFriendClicked);
         _loc1_.addChild(this._findButton);
         this._friendDefaultText = new TextFieldDisplayConcrete().setSize(18).setColor(16777215).setBold(true).setAutoSize(TextFieldAutoSize.CENTER);
         this._friendDefaultText.setStringBuilder(new LineBuilder().setParams(TextKey.FRIEND_DEFAULT_TEXT));
         this._friendDefaultText.x = 250;
         this._friendDefaultText.y = 200;
         _loc1_.addChild(this._friendDefaultText);
         this._friendTotalText = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setBold(true).setAutoSize(TextFieldAutoSize.CENTER);
         this._friendTotalText.x = 400;
         this._friendTotalText.y = 0;
         _loc1_.addChild(this._friendTotalText);
         this._friendsContainer = new FriendListContainer(TEXT_WIDTH,TEXT_HEIGHT - 110);
         this._friendsContainer.x = 3;
         this._friendsContainer.y = 80;
         _loc1_.addChild(this._friendsContainer);
         var _loc2_:BaseSimpleText = new BaseSimpleText(18,16777215,false,100,26);
         _loc2_.setAlignment(TextFormatAlign.CENTER);
         _loc2_.text = FriendConstant.FRIEND_TAB;
         this._tabView.addTab(_loc2_,_loc1_);
      }
      
      private function createInvitationsTab() : void
      {
         var _loc1_:Sprite = null;
         _loc1_ = new Sprite();
         _loc1_.name = FriendConstant.INVITE_TAB;
         this._invitationsContainer = new FriendListContainer(TEXT_WIDTH,TEXT_HEIGHT - 30);
         this._invitationsContainer.x = 3;
         _loc1_.addChild(this._invitationsContainer);
         this._inviteDefaultText = new TextFieldDisplayConcrete().setSize(18).setColor(16777215).setBold(true).setAutoSize(TextFieldAutoSize.CENTER);
         this._inviteDefaultText.setStringBuilder(new LineBuilder().setParams(TextKey.FRIEND_INVITATION_DEFAULT_TEXT));
         this._inviteDefaultText.x = 250;
         this._inviteDefaultText.y = 200;
         _loc1_.addChild(this._inviteDefaultText);
         var _loc2_:BaseSimpleText = new BaseSimpleText(18,16777215,false,100,26);
         _loc2_.text = FriendConstant.INVITE_TAB;
         _loc2_.setAlignment(TextFormatAlign.CENTER);
         this._tabView.addTab(_loc2_,_loc1_);
      }
      
      private function seedData(param1:Vector.<FriendVO>, param2:Vector.<FriendVO>) : void
      {
         this._friendTotalText.setStringBuilder(new LineBuilder().setParams(TextKey.FRIEND_TOTAL,{"total":param1.length}));
         this.updateFriendTab(param1,this._currentServerName);
         this.updateInvitationTab(param2);
      }
      
      private function onTabClicked(param1:String) : void
      {
         this.tabSignal.dispatch(param1);
      }
      
      public function getCloseSignal() : Signal
      {
         return this.closeDialogSignal;
      }
      
      public function updateInput(param1:String, param2:Object = null) : void
      {
         this._nameInput.setError(param1,param2);
      }
      
      private function onFocusIn(param1:FocusEvent) : void
      {
         this._nameInput.clearText();
         this._nameInput.clearError();
         this.actionSignal.dispatch(FriendConstant.SEARCH,this._nameInput.text());
      }
      
      private function onAddFriendClicked(param1:MouseEvent) : void
      {
         this.actionSignal.dispatch(FriendConstant.INVITE,this._nameInput.text());
      }
      
      private function onSearchFriendClicked(param1:MouseEvent) : void
      {
         this.actionSignal.dispatch(FriendConstant.SEARCH,this._nameInput.text());
      }
      
      private function onListItemAction(param1:String, param2:String) : void
      {
         this.actionSignal.dispatch(param1,param2);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.destroy();
      }
      
      private function drawBackground() : void
      {
         this._h = TEXT_HEIGHT + 8;
         x = 800 / 2 - this._w / 2;
         y = 600 / 2 - this._h / 2;
         graphics.clear();
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(-6,-6,this._w + 12,this._h + 12,4,[1,1,1,1],this.path_);
         graphics.drawGraphicsData(this.graphicsData_);
      }
   }
}

