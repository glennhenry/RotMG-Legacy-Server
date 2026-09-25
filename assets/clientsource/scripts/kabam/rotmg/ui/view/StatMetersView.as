package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.ExperienceBoostTimerPopup;
   import com.company.assembleegameclient.ui.StatusBar;
   import flash.display.Sprite;
   import flash.events.Event;
   import kabam.rotmg.text.model.TextKey;
   
   public class StatMetersView extends Sprite
   {
      
      private var expBar_:StatusBar;
      
      private var fameBar_:StatusBar;
      
      private var hpBar_:StatusBar;
      
      private var mpBar_:StatusBar;
      
      private var areTempXpListenersAdded:Boolean;
      
      private var curXPBoost:int;
      
      private var expTimer:ExperienceBoostTimerPopup;
      
      public function StatMetersView()
      {
         super();
         this.expBar_ = new StatusBar(176,16,5931045,5526612,TextKey.EXP_BAR_LEVEL);
         this.fameBar_ = new StatusBar(176,16,14835456,5526612,TextKey.CURRENCY_FAME);
         this.hpBar_ = new StatusBar(176,16,14693428,5526612,TextKey.STATUS_BAR_HEALTH_POINTS);
         this.mpBar_ = new StatusBar(176,16,6325472,5526612,TextKey.STATUS_BAR_MANA_POINTS);
         this.hpBar_.y = 24;
         this.mpBar_.y = 48;
         this.expBar_.visible = true;
         this.fameBar_.visible = false;
         addChild(this.expBar_);
         addChild(this.fameBar_);
         addChild(this.hpBar_);
         addChild(this.mpBar_);
      }
      
      public function update(param1:Player) : void
      {
         this.expBar_.setLabelText(TextKey.EXP_BAR_LEVEL,{"level":param1.level_});
         if(param1.level_ != 20)
         {
            if(this.expTimer)
            {
               this.expTimer.update(param1.xpTimer);
            }
            if(!this.expBar_.visible)
            {
               this.expBar_.visible = true;
               this.fameBar_.visible = false;
            }
            this.expBar_.draw(param1.exp_,param1.nextLevelExp_,0);
            if(this.curXPBoost != param1.xpBoost_)
            {
               this.curXPBoost = param1.xpBoost_;
               if(this.curXPBoost)
               {
                  this.expBar_.showMultiplierText();
               }
               else
               {
                  this.expBar_.hideMultiplierText();
               }
            }
            if(param1.xpTimer)
            {
               if(!this.areTempXpListenersAdded)
               {
                  this.expBar_.addEventListener("MULTIPLIER_OVER",this.onExpBarOver);
                  this.expBar_.addEventListener("MULTIPLIER_OUT",this.onExpBarOut);
                  this.areTempXpListenersAdded = true;
               }
            }
            else
            {
               if(this.areTempXpListenersAdded)
               {
                  this.expBar_.removeEventListener("MULTIPLIER_OVER",this.onExpBarOver);
                  this.expBar_.removeEventListener("MULTIPLIER_OUT",this.onExpBarOut);
                  this.areTempXpListenersAdded = false;
               }
               if(Boolean(this.expTimer) && Boolean(this.expTimer.parent))
               {
                  removeChild(this.expTimer);
                  this.expTimer = null;
               }
            }
         }
         else
         {
            if(!this.fameBar_.visible)
            {
               this.fameBar_.visible = true;
               this.expBar_.visible = false;
            }
            this.fameBar_.draw(param1.currFame_,param1.nextClassQuestFame_,0);
         }
         this.hpBar_.draw(param1.hp_,param1.maxHP_,param1.maxHPBoost_,param1.maxHPMax_);
         this.mpBar_.draw(param1.mp_,param1.maxMP_,param1.maxMPBoost_,param1.maxMPMax_);
      }
      
      private function onExpBarOver(param1:Event) : void
      {
         addChild(this.expTimer = new ExperienceBoostTimerPopup());
      }
      
      private function onExpBarOut(param1:Event) : void
      {
         if(Boolean(this.expTimer) && Boolean(this.expTimer.parent))
         {
            removeChild(this.expTimer);
            this.expTimer = null;
         }
      }
   }
}

