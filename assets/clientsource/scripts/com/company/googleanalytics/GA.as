package com.company.googleanalytics
{
   import com.google.analytics.GATracker;
   
   public class GA
   {
      
      private static var tracker:GATracker = null;
      
      public function GA()
      {
         super();
         throw new Error("Don\'t instance this class");
      }
      
      public static function global() : GATracker
      {
         return tracker;
      }
      
      public static function setTracker(param1:GATracker) : void
      {
         GA.tracker = param1;
      }
   }
}

