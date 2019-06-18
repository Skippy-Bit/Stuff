namespace StangelandWarehouse
{
    public class Article
    {
        public int? id { get; set; } = null;
        public string number { get; set; } = "";
        public string description { get; set; } = "";
        public string unit_of_measurement { get; set; } = "";
        public double cost_price { get; set; } = 0;

        public int GetID()
        {
            return id.HasValue ? id.Value : 0;
        }

        public void SetID(int newID)
        {
            id = newID;
        }

        public void NullID()
        {
            id = null;
        }
    }
}
