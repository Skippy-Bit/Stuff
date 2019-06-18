namespace StangelandWarehouse
{
    public class WorkOrder
    {
        public int? id { get; set; } = null;
        public string number { get; set; } = "";
        public string description { get; set; } = "";
        public string dep_nr { get; set; } = "";
        public string dep_name { get; set; } = "";
        public string machine_nr { get; set; } = "";
        public string machine_name { get; set; } = "";
        public string status { get; set; } = "";
        public string link_work_order_pdf { get; set; } = "";


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
