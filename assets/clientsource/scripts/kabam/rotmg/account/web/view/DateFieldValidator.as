package kabam.rotmg.account.web.view
{
   import kabam.rotmg.account.ui.components.DateField;
   
   public class DateFieldValidator
   {
      
      public function DateFieldValidator()
      {
         super();
      }
      
      public static function getPlayerAge(param1:DateField) : uint
      {
         var _loc2_:Date = new Date(getBirthDate(param1));
         var _loc3_:Date = new Date();
         var _loc4_:uint = Number(_loc3_.fullYear) - Number(_loc2_.fullYear);
         if(_loc2_.month > _loc3_.month || _loc2_.month == _loc3_.month && _loc2_.date > _loc3_.date)
         {
            _loc4_--;
         }
         return _loc4_;
      }
      
      public static function getBirthDate(param1:DateField) : Number
      {
         var _loc2_:String = param1.months.text + "/" + param1.days.text + "/" + param1.years.text;
         return Date.parse(_loc2_);
      }
   }
}

