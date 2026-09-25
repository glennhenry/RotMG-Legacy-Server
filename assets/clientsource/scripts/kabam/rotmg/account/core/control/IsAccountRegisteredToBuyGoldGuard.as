package kabam.rotmg.account.core.control
{
   public class IsAccountRegisteredToBuyGoldGuard extends IsAccountRegisteredGuard
   {
      
      public function IsAccountRegisteredToBuyGoldGuard()
      {
         super();
      }
      
      override protected function getString() : String
      {
         return "Dialog.registerToUseGold";
      }
   }
}

