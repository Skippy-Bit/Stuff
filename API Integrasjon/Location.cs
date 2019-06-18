using Newtonsoft.Json;
using System;
using System.Collections.Generic;

namespace StangelandWarehouse
{
    public class Location
    {
        public int? id { get; set; } = null;
        public string number { get; set; } = "";
        public string name { get; set; } = "";
        public bool is_active { get; set; } = true;

        public int GetID() {
            return id.HasValue ? id.Value : 0;
        }
        
        public void SetID(int newID) {
            id = newID;
        }

        public void NullID() {
            id = null;
        }
    }
}
