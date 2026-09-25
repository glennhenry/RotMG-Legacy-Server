package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.DeprecatedTextButton;
   import com.company.assembleegameclient.ui.RankText;
   import com.company.assembleegameclient.ui.panels.Panel;
   import com.company.assembleegameclient.util.Currency;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFormatAlign;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   import kabam.rotmg.util.components.LegacyBuyButton;
   import org.osflash.signals.Signal;
   
   public class NameChangerPanel extends Panel
   {
      
      public var chooseName:Signal;
      
      public var buy_:Boolean;
      
      private var title_:TextFieldDisplayConcrete;
      
      private var button_:Sprite;
      
      public function NameChangerPanel(param1:GameSprite, param2:int)
      {
         var _loc3_:Player = null;
         var _loc4_:String = null;
         this.chooseName = new Signal();
         super(param1);
         if(this.hasMapAndPlayer())
         {
            _loc3_ = gs_.map.player_;
            this.buy_ = _loc3_.nameChosen_;
            _loc4_ = this.createNameText();
            if(this.buy_)
            {
               this.handleAlreadyHasName(_loc4_);
            }
            else if(_loc3_.numStars_ < param2)
            {
               this.handleInsufficientRank(param2);
            }
            else
            {
               this.handleNoName();
            }
         }
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         if(this.button_)
         {
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         }
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function hasMapAndPlayer() : Boolean
      {
         return Boolean(gs_.map) && Boolean(gs_.map.player_);
      }
      
      private function createNameText() : String
      {
         var _loc1_:String = null;
         _loc1_ = gs_.model.getName();
         this.title_ = new TextFieldDisplayConcrete().setSize(18).setColor(16777215).setTextWidth(WIDTH);
         this.title_.setBold(true).setWordWrap(true).setMultiLine(true).setHorizontalAlign(TextFormatAlign.CENTER);
         this.title_.filters = [new DropShadowFilter(0,0,0)];
         return _loc1_;
      }
      
      private function handleAlreadyHasName(param1:String) : void
      {
         this.title_.setStringBuilder(this.makeNameText(param1));
         this.title_.y = 0;
         addChild(this.title_);
         var _loc2_:LegacyBuyButton = new LegacyBuyButton(TextKey.NAME_CHANGER_CHANGE,16,Parameters.NAME_CHANGE_PRICE,Currency.GOLD);
         _loc2_.readyForPlacement.addOnce(this.positionButton);
         this.button_ = _loc2_;
         addChild(this.button_);
         this.addListeners();
      }
      
      private function positionButton() : void
      {
         this.button_.x = WIDTH / 2 - this.button_.width / 2;
         this.button_.y = HEIGHT - this.button_.height / 2 - 17;
      }
      
      private function handleNoName() : void
      {
         this.title_.setStringBuilder(new LineBuilder().setParams(TextKey.NAME_CHANGER_TEXT));
         this.title_.y = 6;
         addChild(this.title_);
         var _loc1_:DeprecatedTextButton = new DeprecatedTextButton(16,TextKey.NAME_CHANGER_CHOOSE);
         _loc1_.textChanged.addOnce(this.positionTextButton);
         this.button_ = _loc1_;
         addChild(this.button_);
         this.addListeners();
      }
      
      private function positionTextButton() : void
      {
         this.button_.x = WIDTH / 2 - this.button_.width / 2;
         this.button_.y = HEIGHT - this.button_.height - 4;
      }
      
      private function addListeners() : void
      {
         this.button_.addEventListener(MouseEvent.CLICK,this.onButtonClick);
      }
      
      private function handleInsufficientRank(param1:int) : void
      {
         var _loc2_:Sprite = null;
         var _loc4_:Sprite = null;
         this.title_.setStringBuilder(new LineBuilder().setParams(TextKey.NAME_CHANGER_TEXT));
         addChild(this.title_);
         _loc2_ = new Sprite();
         var _loc3_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(16777215);
         _loc3_.setBold(true);
         _loc3_.setStringBuilder(new LineBuilder().setParams(TextKey.NAME_CHANGER_REQUIRE_RANK));
         _loc3_.filters = [new DropShadowFilter(0,0,0)];
         _loc2_.addChild(_loc3_);
         _loc4_ = new RankText(param1,false,false);
         _loc4_.x = _loc3_.width + 4;
         _loc4_.y = _loc3_.height / 2 - _loc4_.height / 2;
         _loc2_.addChild(_loc4_);
         _loc2_.x = WIDTH / 2 - _loc2_.width / 2;
         _loc2_.y = HEIGHT - _loc2_.height / 2 - 20;
         addChild(_loc2_);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function makeNameText(param1:String) : StringBuilder
      {
         return new LineBuilder().setParams(TextKey.NAME_CHANGER_NAME_IS,{"name":param1});
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Parameters.data_.interact && stage.focus == null)
         {
            this.performAction();
         }
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         this.performAction();
      }
      
      private function performAction() : void
      {
         this.chooseName.dispatch();
      }
      
      public function updateName(param1:String) : void
      {
         this.title_.setStringBuilder(this.makeNameText(param1));
         this.title_.y = 0;
      }
   }
}

