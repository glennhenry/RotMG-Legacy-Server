package kabam.rotmg.characters.reskin.control
{
   import flash.display.DisplayObject;
   import kabam.lib.console.signals.HideConsoleSignal;
   import kabam.rotmg.characters.reskin.view.ReskinCharacterView;
   import kabam.rotmg.classes.model.CharacterSkins;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.classes.view.CharacterSkinListItemFactory;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   
   public class OpenReskinDialogCommand
   {
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var hideConsole:HideConsoleSignal;
      
      [Inject]
      public var player:PlayerModel;
      
      [Inject]
      public var model:ClassesModel;
      
      [Inject]
      public var factory:CharacterSkinListItemFactory;
      
      public function OpenReskinDialogCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.hideConsole.dispatch();
         this.openDialog.dispatch(this.makeView());
      }
      
      private function makeView() : ReskinCharacterView
      {
         var _loc1_:ReskinCharacterView = new ReskinCharacterView();
         _loc1_.setList(this.makeList());
         _loc1_.x = (800 - _loc1_.width) * 0.5;
         _loc1_.y = (600 - _loc1_.viewHeight) * 0.5;
         return _loc1_;
      }
      
      private function makeList() : Vector.<DisplayObject>
      {
         var _loc1_:CharacterSkins = this.getCharacterSkins();
         return this.factory.make(_loc1_);
      }
      
      private function getCharacterSkins() : CharacterSkins
      {
         return this.model.getSelected().skins;
      }
   }
}

