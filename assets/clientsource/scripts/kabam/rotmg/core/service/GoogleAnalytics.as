package kabam.rotmg.core.service
{
   import com.company.googleanalytics.GA;
   import com.google.analytics.GATracker;
   import flash.display.Stage;
   
   public class GoogleAnalytics
   {
      
      private var tracker:GATracker;
      
      public function GoogleAnalytics()
      {
         super();
      }
      
      public function init(param1:Stage, param2:String) : void
      {
         this.tracker = new GATracker(param1,param2);
         GA.setTracker(this.tracker);
      }
      
      public function trackEvent(param1:String, param2:String, param3:String, param4:Number) : Boolean
      {
         return this.tracker.trackEvent(param1,param2,param3,param4);
      }
      
      public function trackPageView(param1:String) : void
      {
         this.tracker.trackPageview(param1);
      }
   }
}

