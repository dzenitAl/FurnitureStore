using System.Net;

namespace FurnitureStore.Models.Shared
{
    public class CustomException : Exception
    {
        public HttpStatusCode? StatusCode { get; set; }
        public string ErrorMessage { get; set; }
        public CustomException(string message, HttpStatusCode statusCode = HttpStatusCode.InternalServerError)
            : base(message)
        {
            StatusCode = statusCode;
            ErrorMessage = message;
        }
    }
}
