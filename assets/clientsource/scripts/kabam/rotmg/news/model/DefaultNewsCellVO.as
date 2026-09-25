package kabam.rotmg.news.model
{
   public class DefaultNewsCellVO extends NewsCellVO
   {
      
      public function DefaultNewsCellVO(param1:int)
      {
         super();
         imageURL = "";
         linkDetail = "https://forums.wildshadow.com/";
         headline = param1 == 0 ? "Realm Forums and Wiki" : "Forums";
         startDate = new Date().getTime() - 1000000000;
         endDate = new Date().getTime() + 1000000000;
         networks = ["kabam.com","kongregate","steam","rotmg"];
         linkType = NewsCellLinkType.OPENS_LINK;
         priority = 999999;
         slot = param1;
      }
   }
}

