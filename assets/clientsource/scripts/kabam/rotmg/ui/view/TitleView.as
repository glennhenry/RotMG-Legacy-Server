package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.screens.AccountScreen;
   import com.company.assembleegameclient.screens.TitleMenuOption;
   import com.company.assembleegameclient.ui.SoundIcon;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.account.transfer.view.KabamLoginView;
   import kabam.rotmg.application.model.PlatformModel;
   import kabam.rotmg.application.model.PlatformType;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.ui.model.EnvironmentData;
   import kabam.rotmg.ui.view.components.DarkLayer;
   import kabam.rotmg.ui.view.components.MapBackground;
   import kabam.rotmg.ui.view.components.MenuOptionsBar;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class TitleView extends Sprite
   {
      
      internal static var TitleScreenGraphic:Class = TitleView_TitleScreenGraphic;
      
      public static const MIDDLE_OF_BOTTOM_BAND:Number = 589.45;
      
      public static var queueEmailConfirmation:Boolean = false;
      
      public static var queuePasswordPrompt:Boolean = false;
      
      public static var queuePasswordPromptFull:Boolean = false;
      
      public static var queueRegistrationPrompt:Boolean = false;
      
      public static var kabammigrateOpened:Boolean = false;
      
      private var versionText:TextFieldDisplayConcrete;
      
      private var copyrightText:TextFieldDisplayConcrete;
      
      private var menuOptionsBar:MenuOptionsBar;
      
      private var data:EnvironmentData;
      
      public var playClicked:Signal;
      
      public var serversClicked:Signal;
      
      public var accountClicked:Signal;
      
      public var legendsClicked:Signal;
      
      public var languagesClicked:Signal;
      
      public var supportClicked:Signal;
      
      public var kabamTransferClicked:Signal;
      
      public var editorClicked:Signal;
      
      public var quitClicked:Signal;
      
      public var optionalButtonsAdded:Signal;
      
      private var migrateButton:TitleMenuOption;
      
      public function TitleView()
      {
         var _loc2_:String = null;
         this.menuOptionsBar = this.makeMenuOptionsBar();
         this.optionalButtonsAdded = new Signal();
         super();
         addChild(new MapBackground());
         addChild(new DarkLayer());
         addChild(new TitleScreenGraphic());
         addChild(this.menuOptionsBar);
         addChild(new AccountScreen());
         this.makeChildren();
         addChild(new SoundIcon());
         var _loc1_:PlatformModel = StaticInjectorContext.getInjector().getInstance(PlatformModel);
         if(_loc1_.getPlatform() == PlatformType.WEB)
         {
            this.makeMigrateButton();
            addChild(this.migrateButton);
            _loc2_ = "";
            try
            {
               _loc2_ = ExternalInterface.call("window.location.search.substring",1);
            }
            catch(err:Error)
            {
            }
            if(Boolean(!kabammigrateOpened) && Boolean(_loc2_) && _loc2_ == "kabammigrate")
            {
               kabammigrateOpened = true;
               this.openKabamTransferView();
            }
         }
      }
      
      public function openKabamTransferView() : void
      {
         var _loc1_:OpenDialogSignal = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
         _loc1_.dispatch(new KabamLoginView());
      }
      
      private function makeMenuOptionsBar() : MenuOptionsBar
      {
         var _loc1_:TitleMenuOption = ButtonFactory.getPlayButton();
         var _loc2_:TitleMenuOption = ButtonFactory.getServersButton();
         var _loc3_:TitleMenuOption = ButtonFactory.getAccountButton();
         var _loc4_:TitleMenuOption = ButtonFactory.getLegendsButton();
         var _loc5_:TitleMenuOption = ButtonFactory.getSupportButton();
         this.playClicked = _loc1_.clicked;
         this.serversClicked = _loc2_.clicked;
         this.accountClicked = _loc3_.clicked;
         this.legendsClicked = _loc4_.clicked;
         this.supportClicked = _loc5_.clicked;
         var _loc6_:MenuOptionsBar = new MenuOptionsBar();
         _loc6_.addButton(_loc1_,MenuOptionsBar.CENTER);
         _loc6_.addButton(_loc2_,MenuOptionsBar.LEFT);
         _loc6_.addButton(_loc5_,MenuOptionsBar.LEFT);
         _loc6_.addButton(_loc3_,MenuOptionsBar.RIGHT);
         _loc6_.addButton(_loc4_,MenuOptionsBar.RIGHT);
         return _loc6_;
      }
      
      private function makeChildren() : void
      {
         this.versionText = this.makeText().setHTML(true).setAutoSize(TextFieldAutoSize.LEFT).setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
         this.versionText.y = MIDDLE_OF_BOTTOM_BAND;
         addChild(this.versionText);
         this.copyrightText = this.makeText().setAutoSize(TextFieldAutoSize.RIGHT).setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
         this.copyrightText.setStringBuilder(new LineBuilder().setParams(TextKey.COPYRIGHT));
         this.copyrightText.filters = [new DropShadowFilter(0,0,0)];
         this.copyrightText.x = 800;
         this.copyrightText.y = MIDDLE_OF_BOTTOM_BAND;
         addChild(this.copyrightText);
      }
      
      public function makeText() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = null;
         _loc1_ = new TextFieldDisplayConcrete().setSize(12).setColor(8355711);
         _loc1_.filters = [new DropShadowFilter(0,0,0)];
         return _loc1_;
      }
      
      public function initialize(param1:EnvironmentData) : void
      {
         this.data = param1;
         this.updateVersionText();
         this.handleOptionalButtons();
      }
      
      private function updateVersionText() : void
      {
         this.versionText.setStringBuilder(new StaticStringBuilder(this.data.buildLabel));
      }
      
      private function handleOptionalButtons() : void
      {
         this.data.isAdmin && this.createEditorButton();
         this.data.isDesktop && this.createQuitButton();
         this.optionalButtonsAdded.dispatch();
      }
      
      private function createQuitButton() : void
      {
         var _loc1_:TitleMenuOption = ButtonFactory.getQuitButton();
         this.menuOptionsBar.addButton(_loc1_,MenuOptionsBar.RIGHT);
         this.quitClicked = _loc1_.clicked;
      }
      
      private function createEditorButton() : void
      {
         var _loc1_:TitleMenuOption = ButtonFactory.getEditorButton();
         this.menuOptionsBar.addButton(_loc1_,MenuOptionsBar.RIGHT);
         this.editorClicked = _loc1_.clicked;
      }
      
      private function makeMigrateButton() : void
      {
         this.migrateButton = new TitleMenuOption("Want to migrate your Kabam.com account?",16,false);
         this.migrateButton.setAutoSize(TextFieldAutoSize.CENTER);
         this.kabamTransferClicked = new NativeMappedSignal(this.migrateButton,MouseEvent.CLICK);
         this.migrateButton.setTextKey("Want to migrate your Kabam.com account?");
         this.migrateButton.x = 400;
         this.migrateButton.y = 500;
      }
   }
}

