using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace StangelandWarehouse
{
    public class Warehouse
    {
        private string URL;
        private string Email;
        private string Password;
        private string BearerToken;
        private int TimeoutInSeconds;

        public Warehouse(string URL, string Email, string Password, int TimeoutInSeconds)
        {
            this.URL = URL;
            this.Email = Email;
            this.Password = Password;
            this.TimeoutInSeconds = TimeoutInSeconds;
        }

        public void SetBearerToken(string BearerToken)
        {
            this.BearerToken = BearerToken;
        }

        public bool IsLoggedIn()
        {
            return BearerToken != "";
        }

        public bool Login()
        {
            BearerToken = "";
            using (var client = CreateClient())
            {
                var jsonSerializerSettings = new JsonSerializerSettings
                {
                    NullValueHandling = NullValueHandling.Ignore
                };

                var credentials = new TokenRequest
                {
                    email = Email,
                    password = Password
                };

                var content = new StringContent(JsonConvert.SerializeObject(credentials), Encoding.UTF8, "application/json");
                var response = client.PostAsync("tokens", content).Result;

                if (response.IsSuccessStatusCode)
                {
                    BearerToken = JsonConvert.DeserializeObject<TokenResponse>(response.Content.ReadAsStringAsync().Result, jsonSerializerSettings).token;
                }
            }
            return IsLoggedIn();
        }

        private HttpClient CreateClient(bool ExcludeAuthorization = false)
        {
            HttpClientHandler handler = new HttpClientHandler();
            handler.ClientCertificateOptions = ClientCertificateOption.Manual;

            ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3 | SecurityProtocolType.Tls | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls12;
            ServicePointManager.ServerCertificateValidationCallback =
                (httpRequestMessage, cert, cetChain, policyErrors) =>
                {
                    return true;
                };

            HttpClient client = new HttpClient(handler);
            client.BaseAddress = new Uri(URL);
            client.Timeout = new TimeSpan(0, 0, TimeoutInSeconds);

            HttpRequestHeaders headers = client.DefaultRequestHeaders;
            headers.Clear();
            headers.Add("Accept", "application/json");
            //headers.Add("Content-Type", "application/json");

            headers.Add("Authorization", "Bearer " + BearerToken);
            return client;
        }

        private T GetContent<T>(params string[] path)
        {
            using (var client = CreateClient())
            {
                return client.GetContent<T>(path);
            }
        }

        private HttpResponseMessage PostContent<T>(T payload, params string[] path)
        {
            using (var client = CreateClient())
            {
                var jsonSerializerSettings = new JsonSerializerSettings
                {
                    NullValueHandling = NullValueHandling.Ignore
                };

                var content = new StringContent(JsonConvert.SerializeObject(payload), Encoding.UTF8, "application/json");
                return client.PostAsync(string.Join("/", path), content).Result;
            }
        }

        private HttpResponseMessage PatchContent<T>(T payload, params string[] path)
        {
            using (var client = CreateClient())
            {
                var jsonSerializerSettings = new JsonSerializerSettings
                {
                    NullValueHandling = NullValueHandling.Ignore
                };

                var content = new StringContent(JsonConvert.SerializeObject(payload), Encoding.UTF8, "application/json");
                return client.PatchAsync(content, path).Result;
            }
        }

        public List<Location> GetLocations()
        {
            return GetContent<List<Location>>("locations");
        }

        public Location GetLocation(int id)
        {
            return GetContent<Location>("locations", id.ToString());
        }

        public Location GetLocation(string number)
        {
            var result = GetContent<List<Location>>("locations?number=" + WebUtility.UrlEncode(number));
            return result.FirstOrDefault();
        }

        public bool locationExists(string number)
        {
            var result = GetContent<List<Location>>("locations?number=" + WebUtility.UrlEncode(number));
            if (result.Count == 0) {
                return false;
            }
            return true;
        }

        public List<Article> GetArticles()
        {
            return GetContent<List<Article>>("articles");
        }

        public Article GetArticle(int id)
        {
            return GetContent<Article>("articles", id.ToString());
        }

        public Article GetArticle(string number)
        {
            var result = GetContent<List<Article>>("articles?number=" + WebUtility.UrlEncode(number));
            return result.FirstOrDefault();
        }

        public bool articleExists(string number)
        {
            var result = GetContent<List<Article>>("articles?number=" + WebUtility.UrlEncode(number));
            if (result.Count == 0) {
                return false;
            }
            return true;
        }

        public List<ArticleLocation> GetArticleLocations()
        {
            return GetContent<List<ArticleLocation>>("article-locations");
        }

        public ArticleLocation GetArticleLocation(int id)
        {
            return GetContent<ArticleLocation>("article-locations", id.ToString());
        }

        public List<ArticleLocation> GetArticleLocations(int article_id)
        {
            var result = GetContent<List<ArticleLocation>>("article-locations?article_id=" + article_id);
            return result;
        }

        public List<WorkOrder> GetWorkOrders()
        {
            return GetContent<List<WorkOrder>>("work-orders");
        }

        public List<WorkOrder> GetWorkOrders(string status)
        {
            return GetContent<List<WorkOrder>>("work-orders?status=" + status);
        }
        public WorkOrder GetWorkOrder(int id)
        {
            return GetContent<WorkOrder>("work-orders", id.ToString());
        }

        public bool UpsertLocation(Location location)
        {
            if (string.IsNullOrWhiteSpace(location.number))
            {
                return false;
            }

            var location2 = GetLocation(location.number);
            if (location2 == null)
            {
                return InsertLocation(location);
            }
            else
            {
                location.id = location2.id;
                return UpdateLocation(location);
            }
        }

        public bool InsertLocation(Location location)
        {
            location.id = null;
            var response = PostContent(location, "locations");
            return response.IsSuccessStatusCode;
        }

        public bool UpdateLocation(Location location)
        {
            var id = location.id;
            location.id = null;
            var response = PatchContent(location, "locations", id.ToString());
            return response.IsSuccessStatusCode;
        }

        public bool UpsertArticle(Article article)
        {
            if (string.IsNullOrWhiteSpace(article.number))
            {
                return false;
            }

            var article2 = GetArticle(article.number);
            if (article2 == null)
            {
                return InsertArticle(article);
            }
            else
            {
                article.id = article2.id;
                return UpdateArticle(article);
            }
        }

        public bool InsertArticle(Article article)
        {
            article.id = null;
            var response = PostContent(article, "articles");
            return response.IsSuccessStatusCode;
        }

        public bool UpdateArticle(Article article)
        {
            var id = article.id;
            article.id = null;
            var response = PatchContent(article, "articles", id.ToString());
            return response.IsSuccessStatusCode;
        }

        public bool UpsertArticleLocation(ArticleLocation articleLocation)
        {
            if (!articleLocation.article_id.HasValue || articleLocation.article_id == 0 ||
                !articleLocation.location_id.HasValue || articleLocation.location_id == 0)
            {
                return false;
            }

            var articleLocation2 = GetArticleLocations(articleLocation.article_id.Value).FirstOrDefault(al => al.location_id == articleLocation.location_id);
            if (articleLocation2 == null)
            {
                return InsertArticleLocation(articleLocation);
            }
            else
            {
                articleLocation.id = articleLocation2.id;
                return UpdateArticleLocation(articleLocation);
            }
        }

        public bool InsertArticleLocation(ArticleLocation articleLocation)
        {
            articleLocation.id = null;

            var response = PostContent(articleLocation, "article-locations");
            return response.IsSuccessStatusCode;
        }

        public bool UpdateArticleLocation(ArticleLocation articleLocation)
        {
            var id = articleLocation.id;
            articleLocation.id = null;
            var response = PatchContent(articleLocation, "article-locations", id.ToString());
            return response.IsSuccessStatusCode;
        }
    }

    static class WarehouseExtensions
    {
        public static T GetContent<T>(this HttpClient client, params string[] path)
        {
            var jsonSerializerSettings = new JsonSerializerSettings
            {
                NullValueHandling = NullValueHandling.Ignore
            };

            HttpResponseMessage response = client.GetAsync(string.Join("/", path)).Result;
            return JsonConvert.DeserializeObject<T>(response.Content.ReadAsStringAsync().Result, jsonSerializerSettings);
        }

        public static Task<HttpResponseMessage> PatchAsync(this HttpClient client, HttpContent content, params string[] path)
        {
            var message = new HttpRequestMessage(new HttpMethod("PATCH"), string.Join("/", path)) { Content = content };
            return client.SendAsync(message);
        }
    }
}
