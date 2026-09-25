package kabam.rotmg.packages
{
   import kabam.rotmg.account.core.control.IsAccountRegisteredGuard;
   
   public class IsAccountRegisteredToBuyPackageGuard extends IsAccountRegisteredGuard
   {
      
      public function IsAccountRegisteredToBuyPackageGuard()
      {
         super();
      }
      
      override protected function getString() : String
      {
         return "Dialog.registerToBuyPackage";
      }
   }
}

