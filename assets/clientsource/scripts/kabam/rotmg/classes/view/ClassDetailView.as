package kabam.rotmg.classes.view
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.assets.model.Animation;
   import kabam.rotmg.assets.services.IconFactory;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.ui.view.SignalWaiter;
   import kabam.rotmg.util.components.StarsView;
   
   public class ClassDetailView extends Sprite
   {
      
      private static const RIGHT_JUSTIFICATION_STATS:int = 205;
      
      private static const WIDTH:int = 344;
      
      private static const TEXT_WIDTH:int = 188;
      
      private var classNameText:TextFieldDisplayConcrete;
      
      private var classDescriptionText:TextFieldDisplayConcrete;
      
      private var questCompletionText:TextFieldDisplayConcrete;
      
      private var levelTitleText:TextFieldDisplayConcrete;
      
      private var levelText:TextFieldDisplayConcrete;
      
      private var fameTitleText:TextFieldDisplayConcrete;
      
      private var fameText:TextFieldDisplayConcrete;
      
      private var fameIcon:Bitmap;
      
      private var nextGoalText:TextFieldDisplayConcrete;
      
      private var nextGoalDetailText:TextFieldDisplayConcrete;
      
      private var questCompletedStars:StarsView;
      
      private var showNextGoal:Boolean;
      
      private var animContainer:Sprite;
      
      private var animation:Animation;
      
      private const waiter:SignalWaiter;
      
      public function ClassDetailView()
      {
         var _loc1_:DropShadowFilter = null;
         this.waiter = new SignalWaiter();
         super();
         this.waiter.complete.add(this.layout);
         _loc1_ = new DropShadowFilter(0,0,0,1,8,8);
         this.animContainer = new Sprite();
         this.animContainer.x = (WIDTH - 104) * 0.5;
         addChild(this.animContainer);
         this.classNameText = new TextFieldDisplayConcrete().setSize(20).setColor(16777215).setBold(true).setAutoSize(TextFieldAutoSize.CENTER).setTextWidth(TEXT_WIDTH);
         this.classNameText.filters = [_loc1_];
         this.waiter.push(this.classNameText.textChanged);
         addChild(this.classNameText);
         this.classDescriptionText = new TextFieldDisplayConcrete().setSize(14).setColor(16777215).setTextWidth(TEXT_WIDTH).setWordWrap(true);
         this.classDescriptionText.filters = [_loc1_];
         this.waiter.push(this.classDescriptionText.textChanged);
         addChild(this.classDescriptionText);
         this.questCompletionText = new TextFieldDisplayConcrete().setSize(14).setColor(16777215).setBold(true);
         this.questCompletionText.filters = [_loc1_];
         this.questCompletionText.setStringBuilder(new LineBuilder().setParams(TextKey.CLASS_QUEST_COMPLETED));
         this.waiter.push(this.questCompletionText.textChanged);
         addChild(this.questCompletionText);
         this.levelTitleText = new TextFieldDisplayConcrete().setSize(14).setColor(16777215).setBold(true);
         this.levelTitleText.filters = [_loc1_];
         this.levelTitleText.setStringBuilder(new LineBuilder().setParams(TextKey.CLASS_HIGHEST_LEVEL));
         this.waiter.push(this.levelTitleText.textChanged);
         addChild(this.levelTitleText);
         this.levelText = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setBold(true);
         this.levelText.filters = [_loc1_];
         this.waiter.push(this.levelText.textChanged);
         addChild(this.levelText);
         this.fameTitleText = new TextFieldDisplayConcrete().setSize(14).setColor(16777215).setBold(true);
         this.fameTitleText.filters = [_loc1_];
         this.fameTitleText.setStringBuilder(new LineBuilder().setParams(TextKey.CLASS_MOST_FAME));
         this.waiter.push(this.fameTitleText.textChanged);
         addChild(this.fameTitleText);
         this.fameText = new TextFieldDisplayConcrete().setSize(16).setColor(15387756).setBold(true);
         this.fameText.filters = [_loc1_];
         this.waiter.push(this.fameText.textChanged);
         addChild(this.fameText);
         this.fameIcon = new Bitmap(IconFactory.makeFame());
         this.fameIcon.filters = [_loc1_];
         addChild(this.fameIcon);
         this.nextGoalText = new TextFieldDisplayConcrete().setSize(14).setColor(16777215).setBold(true);
         this.nextGoalText.filters = [_loc1_];
         this.nextGoalText.setStringBuilder(new LineBuilder().setParams(TextKey.CLASS_NEXT_GOAL));
         this.nextGoalText.visible = false;
         addChild(this.nextGoalText);
         this.nextGoalDetailText = new TextFieldDisplayConcrete().setSize(14).setColor(16777215);
         this.nextGoalDetailText.filters = [_loc1_];
         this.nextGoalDetailText.visible = false;
         addChild(this.nextGoalDetailText);
         this.questCompletedStars = new StarsView();
         addChild(this.questCompletedStars);
      }
      
      public function setData(param1:String, param2:String, param3:int, param4:int, param5:int) : void
      {
         this.classNameText.setStringBuilder(new LineBuilder().setParams(param1));
         this.classDescriptionText.setStringBuilder(new LineBuilder().setParams(param2));
         this.levelText.setStringBuilder(new StaticStringBuilder(String(param4)));
         this.fameText.setStringBuilder(new StaticStringBuilder(String(param5)));
      }
      
      public function setNextGoal(param1:String, param2:int) : void
      {
         this.showNextGoal = param2 != -1;
         if(this.showNextGoal)
         {
            this.nextGoalDetailText.setStringBuilder(new LineBuilder().setParams(TextKey.CLASS_NEXT_GOAL_DETAIL,{
               "goal":String(param2),
               "quest":param1
            }));
            this.nextGoalDetailText.y = this.nextGoalText.y + this.nextGoalText.height;
            this.nextGoalDetailText.x = WIDTH / 2 - this.nextGoalDetailText.width / 2;
            this.waiter.push(this.nextGoalDetailText.textChanged);
            this.waiter.push(this.nextGoalText.textChanged);
         }
      }
      
      public function setWalkingAnimation(param1:Animation) : void
      {
         this.animation && this.removeAnimation(this.animation);
         this.animation = param1;
         this.animation && this.addAnimation(this.animation);
         this.layout();
      }
      
      private function removeAnimation(param1:Animation) : void
      {
         param1.stop();
         this.animContainer.removeChild(param1);
      }
      
      private function addAnimation(param1:Animation) : void
      {
         this.animContainer.addChild(param1);
         param1.start();
      }
      
      private function layout() : void
      {
         this.classNameText.x = WIDTH / 2 - this.classNameText.width / 2;
         this.classNameText.y = 110;
         this.classDescriptionText.y = this.classNameText.y + this.classNameText.height + 5;
         this.classDescriptionText.x = WIDTH / 2 - this.classDescriptionText.width / 2;
         this.questCompletionText.y = this.classDescriptionText.y + this.classDescriptionText.height + 20;
         this.questCompletionText.x = RIGHT_JUSTIFICATION_STATS - this.questCompletionText.width;
         this.questCompletedStars.y = this.questCompletionText.y - 2;
         this.questCompletedStars.x = RIGHT_JUSTIFICATION_STATS + 18;
         this.levelTitleText.y = this.questCompletionText.y + this.questCompletionText.height + 5;
         this.levelTitleText.x = RIGHT_JUSTIFICATION_STATS - this.levelTitleText.width;
         this.levelText.y = this.levelTitleText.y;
         this.levelText.x = RIGHT_JUSTIFICATION_STATS + 18;
         this.fameTitleText.y = this.levelTitleText.y + this.levelTitleText.height + 5;
         this.fameTitleText.x = RIGHT_JUSTIFICATION_STATS - this.fameTitleText.width;
         this.fameText.y = this.fameTitleText.y;
         this.fameText.x = RIGHT_JUSTIFICATION_STATS + 18;
         this.fameIcon.y = this.fameTitleText.y - 2;
         this.fameIcon.x = this.fameText.x + this.fameText.width + 3;
         this.nextGoalText.y = this.fameTitleText.y + this.fameTitleText.height + 17;
         this.nextGoalText.x = WIDTH / 2 - this.nextGoalText.width / 2;
         this.nextGoalText.visible = this.showNextGoal;
         this.nextGoalDetailText.y = this.nextGoalText.y + this.nextGoalText.height;
         this.nextGoalDetailText.x = WIDTH / 2 - this.nextGoalDetailText.width / 2;
         this.nextGoalDetailText.visible = this.showNextGoal;
      }
   }
}

