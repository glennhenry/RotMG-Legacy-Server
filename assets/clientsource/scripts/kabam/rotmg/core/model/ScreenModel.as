package kabam.rotmg.core.model
{
   import com.company.assembleegameclient.screens.AccountLoadingScreen;
   
   public class ScreenModel
   {
      
      private var currentType:Class;
      
      public function ScreenModel()
      {
         super();
      }
      
      public function setCurrentScreenType(param1:Class) : void
      {
         if(param1 != AccountLoadingScreen)
         {
            this.currentType = param1;
         }
      }
      
      public function getCurrentScreenType() : Class
      {
         return this.currentType;
      }
   }
}

