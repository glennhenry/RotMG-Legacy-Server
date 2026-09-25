package kabam.rotmg.account.kabam.view
{
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.account.core.view.AccountInfoView;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class KabamAccountInfoView extends Sprite implements AccountInfoView
   {
      
      private static const FONT_SIZE:int = 18;
      
      private var accountText:TextFieldDisplayConcrete;
      
      private var userName:String = "";
      
      private var isRegistered:Boolean;
      
      public function KabamAccountInfoView()
      {
         super();
         this.makeAccountText();
      }
      
      private function makeAccountText() : void
      {
         this.accountText = new TextFieldDisplayConcrete().setSize(FONT_SIZE).setColor(11776947);
         this.accountText.setAutoSize(TextFieldAutoSize.CENTER);
         this.accountText.filters = [new DropShadowFilter(0,0,0,1,4,4)];
         addChild(this.accountText);
      }
      
      public function setInfo(param1:String, param2:Boolean) : void
      {
         this.userName = param1;
         this.isRegistered = param2;
         this.accountText.setStringBuilder(new LineBuilder().setParams(TextKey.KABAMACCOUNTINFOVIEW_ACCOUNTINFO,{"userName":param1}));
      }
   }
}

