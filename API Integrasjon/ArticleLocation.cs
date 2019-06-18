namespace StangelandWarehouse
{
    public class ArticleLocation
    {
        public int? id { get; set; } = null;
        public int? article_id { get; set; } = null;
        public int? location_id { get; set; } = null;
        public double quantity { get; set; } = 0;
        public string shelf_code { get; set; } = "";

        public int GetID()
        {
            return id.HasValue ? id.Value : 0;
        }

        public int GetArticleID()
        {
            return article_id.HasValue ? article_id.Value : 0;
        }

        public int GetLocationID()
        {
            return location_id.HasValue ? location_id.Value : 0;
        }

        public void SetID(int newID)
        {
            id = newID;
        }

        public void SetArticleID(int newID)
        {
            article_id = newID;
        }

        public void SetLocationID(int newID)
        {
            location_id = newID;
        }

        public void NullID()
        {
            id = null;
        }

        public void NullArticleID()
        {
            article_id = null;
        }

        public void NullLocationID()
        {
            location_id = null;
        }
    }
}
