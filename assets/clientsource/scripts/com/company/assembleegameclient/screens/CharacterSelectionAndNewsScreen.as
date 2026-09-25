package com.company.assembleegameclient.screens
{
   import com.company.assembleegameclient.ui.DeprecatedClickableText;
   import com.company.assembleegameclient.ui.Scrollbar;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.game.view.CreditDisplay;
   import kabam.rotmg.news.view.NewsView;
   import kabam.rotmg.packages.view.PackageButton;
   import kabam.rotmg.promotions.view.BeginnersPackageButton;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.ui.view.ButtonFactory;
   import kabam.rotmg.ui.view.components.MenuOptionsBar;
   import kabam.rotmg.ui.view.components.ScreenBase;
   import org.osflash.signals.Signal;
   
   public class CharacterSelectionAndNewsScreen extends Sprite
   {
      
      private static const NEWS_X:int = 475;
      
      private static const TAB_UNSELECTED:uint = 11776947;
      
      private static const TAB_SELECTED:uint = 16777215;
      
      public var close:Signal;
      
      public var showClasses:Signal;
      
      public var newCharacter:Signal = new Signal();
      
      public var chooseName:Signal = new Signal();
      
      public var playGame:Signal = new Signal();
      
      public var beginnersPackageButton:BeginnersPackageButton;
      
      private const SCROLLBAR_REQUIREMENT_HEIGHT:Number = 400;
      
      private const CHARACTER_LIST_Y_POS:int = 108;
      
      private const CHARACTER_LIST_X_POS:int = 18;
      
      private const DROP_SHADOW:DropShadowFilter = new DropShadowFilter(0,0,0,1,8,8);
      
      private var model:PlayerModel;
      
      private var isInitialized:Boolean;
      
      private var nameText:TextFieldDisplayConcrete;
      
      private var nameChooseLink_:DeprecatedClickableText;
      
      private var creditDisplay:CreditDisplay;
      
      private var openCharactersText:TextFieldDisplayConcrete;
      
      private var openGraveyardText:TextFieldDisplayConcrete;
      
      private var newsText:TextFieldDisplayConcrete;
      
      private var characterList:CharacterList;
      
      private var characterListType:int = 1;
      
      private var characterListHeight:Number;
      
      private var lines:Shape;
      
      private var scrollBar:Scrollbar;
      
      private var packageButton:PackageButton;
      
      private var playButton:TitleMenuOption = ButtonFactory.getPlayButton();
      
      private var classesButton:TitleMenuOption = ButtonFactory.getClassesButton();
      
      private var backButton:TitleMenuOption = ButtonFactory.getMainButton();
      
      private var menuOptionsBar:MenuOptionsBar;
      
      private var BOUNDARY_LINE_ONE_Y:int = 106;
      
      public function CharacterSelectionAndNewsScreen()
      {
         super();
         this.close = this.backButton.clicked;
         this.showClasses = this.classesButton.clicked;
         addChild(new ScreenBase());
         addChild(new AccountScreen());
      }
      
      public function initialize(param1:PlayerModel) : void
      {
         if(this.isInitialized)
         {
            return;
         }
         this.isInitialized = true;
         this.model = param1;
         this.createDisplayAssets(param1);
      }
      
      private function createDisplayAssets(param1:PlayerModel) : void
      {
         this.createNameText();
         this.createCreditDisplay();
         this.createNewsText();
         this.createNews();
         this.createBoundaryLines();
         this.createOpenCharactersText();
         var _loc2_:Graveyard = new Graveyard(param1);
         if(_loc2_.hasCharacters())
         {
            this.openCharactersText.setColor(TAB_SELECTED);
            this.createOpenGraveyardText();
         }
         this.createCharacterListChar();
         this.makeMenuOptionsBar();
         if(!param1.isNameChosen())
         {
            this.createChooseNameLink();
         }
      }
      
      private function makeMenuOptionsBar() : void
      {
         this.playButton.clicked.add(this.onPlayClick);
         this.menuOptionsBar = new MenuOptionsBar();
         this.menuOptionsBar.addButton(this.playButton,MenuOptionsBar.CENTER);
         this.menuOptionsBar.addButton(this.backButton,MenuOptionsBar.LEFT);
         this.menuOptionsBar.addButton(this.classesButton,MenuOptionsBar.RIGHT);
         addChild(this.menuOptionsBar);
      }
      
      private function createNews() : void
      {
         var _loc1_:NewsView = null;
         _loc1_ = new NewsView();
         _loc1_.x = NEWS_X;
         _loc1_.y = 112;
         addChild(_loc1_);
      }
      
      private function createScrollbar() : void
      {
         this.scrollBar = new Scrollbar(16,399);
         this.scrollBar.x = 443;
         this.scrollBar.y = 113;
         this.scrollBar.setIndicatorSize(399,this.characterList.height);
         this.scrollBar.addEventListener(Event.CHANGE,this.onScrollBarChange);
         addChild(this.scrollBar);
      }
      
      private function createNewsText() : void
      {
         this.newsText = new TextFieldDisplayConcrete().setSize(18).setColor(TAB_UNSELECTED);
         this.newsText.setBold(true);
         this.newsText.setStringBuilder(new LineBuilder().setParams(TextKey.CHARACTER_SELECTION_NEWS));
         this.newsText.filters = [this.DROP_SHADOW];
         this.newsText.x = NEWS_X;
         this.newsText.y = 79;
         addChild(this.newsText);
      }
      
      private function createCharacterListChar() : void
      {
         this.characterListType = CharacterList.TYPE_CHAR_SELECT;
         this.characterList = new CharacterList(this.model,CharacterList.TYPE_CHAR_SELECT);
         this.characterList.x = this.CHARACTER_LIST_X_POS;
         this.characterList.y = this.CHARACTER_LIST_Y_POS;
         this.characterListHeight = this.characterList.height;
         if(this.characterListHeight > this.SCROLLBAR_REQUIREMENT_HEIGHT)
         {
            this.createScrollbar();
         }
         addChild(this.characterList);
      }
      
      private function createCharacterListGrave() : void
      {
         this.characterListType = CharacterList.TYPE_GRAVE_SELECT;
         this.characterList = new CharacterList(this.model,CharacterList.TYPE_GRAVE_SELECT);
         this.characterList.x = this.CHARACTER_LIST_X_POS;
         this.characterList.y = this.CHARACTER_LIST_Y_POS;
         this.characterListHeight = this.characterList.height;
         if(this.characterListHeight > this.SCROLLBAR_REQUIREMENT_HEIGHT)
         {
            this.createScrollbar();
         }
         addChild(this.characterList);
      }
      
      private function removeCharacterList() : void
      {
         if(this.characterList != null)
         {
            removeChild(this.characterList);
            this.characterList = null;
         }
         if(this.scrollBar != null)
         {
            removeChild(this.scrollBar);
            this.scrollBar = null;
         }
      }
      
      private function createOpenCharactersText() : void
      {
         this.openCharactersText = new TextFieldDisplayConcrete().setSize(18).setColor(TAB_UNSELECTED);
         this.openCharactersText.setBold(true);
         this.openCharactersText.setStringBuilder(new LineBuilder().setParams(TextKey.CHARACTER_SELECTION_CHARACTERS));
         this.openCharactersText.filters = [this.DROP_SHADOW];
         this.openCharactersText.x = this.CHARACTER_LIST_X_POS;
         this.openCharactersText.y = 79;
         this.openCharactersText.addEventListener(MouseEvent.CLICK,this.onOpenCharacters);
         addChild(this.openCharactersText);
      }
      
      private function onOpenCharacters(param1:MouseEvent) : void
      {
         if(this.characterListType != CharacterList.TYPE_CHAR_SELECT)
         {
            this.removeCharacterList();
            this.openCharactersText.setColor(TAB_SELECTED);
            this.openGraveyardText.setColor(TAB_UNSELECTED);
            this.createCharacterListChar();
         }
      }
      
      private function createOpenGraveyardText() : void
      {
         this.openGraveyardText = new TextFieldDisplayConcrete().setSize(18).setColor(TAB_UNSELECTED);
         this.openGraveyardText.setBold(true);
         this.openGraveyardText.setStringBuilder(new LineBuilder().setParams(TextKey.CHARACTER_SELECTION_GRAVEYARD));
         this.openGraveyardText.filters = [this.DROP_SHADOW];
         this.openGraveyardText.x = this.CHARACTER_LIST_X_POS + 150;
         this.openGraveyardText.y = 79;
         this.openGraveyardText.addEventListener(MouseEvent.CLICK,this.onOpenGraveyard);
         addChild(this.openGraveyardText);
      }
      
      private function onOpenGraveyard(param1:MouseEvent) : void
      {
         if(this.characterListType != CharacterList.TYPE_GRAVE_SELECT)
         {
            this.removeCharacterList();
            this.openCharactersText.setColor(TAB_UNSELECTED);
            this.openGraveyardText.setColor(TAB_SELECTED);
            this.createCharacterListGrave();
         }
      }
      
      private function createCreditDisplay() : void
      {
         this.creditDisplay = new CreditDisplay();
         this.creditDisplay.draw(this.model.getCredits(),this.model.getFame());
         this.creditDisplay.x = this.getReferenceRectangle().width;
         this.creditDisplay.y = 20;
         addChild(this.creditDisplay);
      }
      
      private function createChooseNameLink() : void
      {
         this.nameChooseLink_ = new DeprecatedClickableText(16,false,TextKey.CHARACTER_SELECTION_AND_NEWS_SCREEN_CHOOSE_NAME);
         this.nameChooseLink_.y = 50;
         this.nameChooseLink_.setAutoSize(TextFieldAutoSize.CENTER);
         this.nameChooseLink_.x = this.getReferenceRectangle().width / 2;
         this.nameChooseLink_.addEventListener(MouseEvent.CLICK,this.onChooseName);
         addChild(this.nameChooseLink_);
      }
      
      private function createNameText() : void
      {
         this.nameText = new TextFieldDisplayConcrete().setSize(22).setColor(11776947);
         this.nameText.setBold(true).setAutoSize(TextFieldAutoSize.CENTER);
         this.nameText.setStringBuilder(new StaticStringBuilder(this.model.getName()));
         this.nameText.filters = [this.DROP_SHADOW];
         this.nameText.y = 24;
         this.nameText.x = (this.getReferenceRectangle().width - this.nameText.width) / 2;
         addChild(this.nameText);
      }
      
      internal function getReferenceRectangle() : Rectangle
      {
         var _loc1_:Rectangle = new Rectangle();
         if(stage)
         {
            _loc1_ = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
         }
         return _loc1_;
      }
      
      private function createBoundaryLines() : void
      {
         this.lines = new Shape();
         this.lines.graphics.clear();
         this.lines.graphics.lineStyle(2,5526612);
         this.lines.graphics.moveTo(0,this.BOUNDARY_LINE_ONE_Y);
         this.lines.graphics.lineTo(this.getReferenceRectangle().width,this.BOUNDARY_LINE_ONE_Y);
         this.lines.graphics.moveTo(466,107);
         this.lines.graphics.lineTo(466,526);
         this.lines.graphics.lineStyle();
         addChild(this.lines);
      }
      
      private function onChooseName(param1:MouseEvent) : void
      {
         this.chooseName.dispatch();
      }
      
      private function onScrollBarChange(param1:Event) : void
      {
         if(this.characterList != null)
         {
            this.characterList.setPos(-this.scrollBar.pos() * (this.characterListHeight - 400));
         }
      }
      
      public function showBeginnersOfferButton() : void
      {
         this.beginnersPackageButton = new BeginnersPackageButton();
         this.beginnersPackageButton.x = 14;
         this.beginnersPackageButton.y = 40;
         addChild(this.beginnersPackageButton);
         this.removeIfAble(this.packageButton);
      }
      
      public function showPackageButton() : void
      {
         this.packageButton = new PackageButton();
         this.packageButton.init();
         this.packageButton.x = 6;
         this.packageButton.y = 40;
         addChild(this.packageButton);
         this.removeIfAble(this.beginnersPackageButton);
      }
      
      private function removeIfAble(param1:DisplayObject) : void
      {
         if(Boolean(param1) && contains(param1))
         {
            removeChild(param1);
         }
      }
      
      private function onPlayClick() : void
      {
         if(this.model.getCharacterCount() == 0)
         {
            this.newCharacter.dispatch();
         }
         else
         {
            this.playGame.dispatch();
         }
      }
      
      public function setName(param1:String) : void
      {
         this.nameText.setStringBuilder(new StaticStringBuilder(this.model.getName()));
         this.nameText.x = (this.getReferenceRectangle().width - this.nameText.width) * 0.5;
         if(this.nameChooseLink_)
         {
            removeChild(this.nameChooseLink_);
            this.nameChooseLink_ = null;
         }
      }
   }
}

