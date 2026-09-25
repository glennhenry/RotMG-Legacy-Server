package kabam.rotmg.language.service
{
   import com.company.assembleegameclient.ui.dialogs.ErrorDialog;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.language.model.LanguageModel;
   import kabam.rotmg.language.model.StringMap;
   
   public class GetLanguageService extends BaseTask
   {
      
      private static const LANGUAGE:String = "LANGUAGE";
      
      [Inject]
      public var model:LanguageModel;
      
      [Inject]
      public var strings:StringMap;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var client:AppEngineClient;
      
      private var language:String;
      
      public function GetLanguageService()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.language = this.model.getLanguageFamily();
         this.client.complete.addOnce(this.onComplete);
         this.client.setMaxRetries(3);
         this.client.sendRequest("/app/getLanguageStrings",{"languageType":this.language});
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.onLanguageResponse(param2);
         }
         else
         {
            this.onLanguageError();
         }
         completeTask(param1,param2);
      }
      
      private function onLanguageResponse(param1:String) : void
      {
         var _loc3_:Array = null;
         this.strings.clear();
         var _loc2_:Object = JSON.parse(param1);
         for each(_loc3_ in _loc2_)
         {
            this.strings.setValue(_loc3_[0],_loc3_[1],_loc3_[2]);
         }
      }
      
      private function onLanguageError() : void
      {
         this.strings.setValue("ok","ok",this.model.getLanguageFamily());
         var _loc1_:ErrorDialog = new ErrorDialog("Unable to load language [" + this.language + "]");
         this.openDialog.dispatch(_loc1_);
         completeTask(false);
      }
   }
}

