using Newtonsoft.Json;
using System;
using System.Collections.Generic;

namespace StangelandWarehouse
{
    public class TokenRequest
    {
        public string email { get; set; } = "";
        public string password { get; set; } = "";
    }

    public class TokenResponse
    {
        public string token { get; } = "";
        public DateTime valid_to { get; }
    }
}
