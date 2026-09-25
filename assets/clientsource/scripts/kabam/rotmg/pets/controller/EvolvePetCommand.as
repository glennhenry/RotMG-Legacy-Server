package kabam.rotmg.pets.controller
{
   import com.company.assembleegameclient.editor.Command;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.messaging.impl.EvolvePetInfo;
   import kabam.rotmg.pets.view.dialogs.evolving.EvolveDialog;
   import org.swiftsuspenders.Injector;
   
   public class EvolvePetCommand extends Command
   {
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var evolvePetInfo:EvolvePetInfo;
      
      [Inject]
      public var injector:Injector;
      
      public function EvolvePetCommand()
      {
         super();
      }
      
      override public function execute() : void
      {
         var _loc1_:EvolveDialog = this.injector.getInstance(EvolveDialog);
         this.openDialog.dispatch(_loc1_);
         _loc1_.evolveAnimation.setEvolvedPets(this.evolvePetInfo);
      }
   }
}

